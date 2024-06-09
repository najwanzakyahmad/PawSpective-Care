<?php

namespace App\Http\Controllers;

use App\Http\Requests\GetChatRequest;
use App\Http\Requests\StoreChatRequest;
use Kreait\Firebase\Contract\Database;
use Kreait\Firebase\Exception\Auth\RevokedIdToken;
use Kreait\Firebase\Contract\Auth;
use Illuminate\Http\JsonResponse;
use Kreait\Firebase\Auth\Token\Verifier;

class ChatController extends Controller
{
    protected $database;
    protected $tablename;
    protected $auth;
    protected $tokenVerifier;

    public function __construct(Database $database, Auth $auth)
    {
        $this->database = $database;
        $this->tablename = 'chats';
        $this->auth = $auth;
    }

    /**
     * Gets chats
     */
    public function index(GetChatRequest $request): JsonResponse
    {
        try {
            $data = $request->validated();
            $userId = $this->getUserIdFromToken();
            $isPrivate = $request->has('is_private') ? (int)$data['is_private'] : 1;

            $chatsRef = $this->database->getReference('chats')
                ->orderByChild('is_private')
                ->equalTo($isPrivate)
                ->getSnapshot();

            $chats = [];
            foreach ($chatsRef->getValue() as $chatId => $chat) {
                if (isset($chat['participants'][$userId])) {
                    $chats[$chatId] = $chat;
                }
            }
            return $this->success(['chats' => $chats], "Chats fetched successfully");
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), $e->getCode() ?: 500);
        }
    }

    public function store(StoreChatRequest $request): JsonResponse
    {
        try {
            $data = $this->prepareStoreData($request);

            if ($data['userId'] === $data['otherUserId']) {
                return $this->error('You cannot create a chat with yourself', 400);
            }

            $previousChat = $this->getPreviousChat($data['otherUserId']);
            if ($previousChat === null) {
                // Generate a new ID for the chat
                $chatRef = $this->database->getReference('chats')->push($data['data']);
                $chatId = $chatRef->getKey();

                // Set participants
                $participants = [
                    $data['userId'] => ['user_id' => $data['userId']],
                    $data['otherUserId'] => ['user_id' => $data['otherUserId']]
                ];
                $this->database->getReference("chats/{$chatId}/participants")->set($participants);

                // Save the chat ID along with other chat data
                $data['data']['chat_id'] = $chatId;
                $chatRef->set($data['data']);
                $this->database->getReference("chats/{$chatId}/participants")->set($participants);
                // Retrieve and return the newly created chat
                $chat = $this->database->getReference("chats/{$chatId}")->getValue();
                return $this->success(['chat' => $chat], "Chat created successfully");
            }

            return $this->success(['chat' => $previousChat], "Chat already exists");
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), $e->getCode() ?: 500);
        }
    }


    /**
     * Check if user and other user has previous chat or not
     */
    private function getPreviousChat(string $otherUserId): mixed
    {
        try {
            $userId = $this->getUserIdFromToken();
            $chatsRef = $this->database->getReference('chats')
                ->orderByChild('is_private')
                ->equalTo(1)
                ->getSnapshot();

            foreach ($chatsRef->getValue() as $chatId => $chat) {
                if (isset($chat['participants'][$userId]) && isset($chat['participants'][$otherUserId])) {
                    return $chat;
                }
            }

            return null;
        } catch (\Exception $e) {
            throw new \Exception('Error checking previous chat: ' . $e->getMessage());
        }
    }

    /**
     * Prepares data for store a chat
     */
    private function prepareStoreData(StoreChatRequest $request): array
    {
        try {
            $data = $request->validated();
            $otherUserId = (string)$data['user_id'];
            $userId = $this->getUserIdFromToken();
            unset($data['user_id']);
            $data['created_by'] = $userId;
            $data['created_at'] = now()->toDateTimeString();
            return [
                'otherUserId' => $otherUserId,
                'userId' => $userId,
                'data' => $data,
            ];
        } catch (\Exception $e) {
            throw new \Exception('Error preparing store data: ' . $e->getMessage());
        }
    }

    /**
     * Gets a single chat
     */
    public function show(string $chatId): JsonResponse
    {
        try {
            // Retrieve chat details from Firebase
            $chatRef = $this->database->getReference("chats/{$chatId}");
            $chatSnapshot = $chatRef->getSnapshot();
            $chat = $chatSnapshot->getValue();

            if (!$chat) {
                return $this->error('Chat not found', 404);
            }

            // Retrieve last message
            $lastMessageRef = $chatRef->getChild('messages')->orderByChild('updated_at')->limitToLast(1)->getSnapshot();
            $lastMessage = null;
            if ($lastMessageRef->exists()) {
                foreach ($lastMessageRef->getValue() as $messageId => $message) {
                    $message['id'] = $messageId;
                    $lastMessage = $message;
                    break;
                }
            }

            // Retrieve participants
            $participantsRef = $chatRef->getChild('participants')->getSnapshot();
            $participants = $participantsRef->getValue() ?: [];

            // Fetch user details for participants and last message
            $userIds = array_map(function ($participant) {
                return $participant['user_id'];
            }, $participants);

            if ($lastMessage) {
                $userIds[] = $lastMessage['user_id'];
            }

            $users = [];
            foreach ($userIds as $userId) {
                $userSnapshot = $this->database->getReference("users/{$userId}")->getSnapshot();
                if ($userSnapshot->exists()) {
                    $users[$userId] = $userSnapshot->getValue();
                }
            }

            // Attach user details to participants and last message
            foreach ($participants as &$participant) {
                $participant['user'] = $users[$participant['user_id']] ?? null;
            }

            if ($lastMessage) {
                $lastMessage['user'] = $users[$lastMessage['user_id']] ?? null;
            }

            // Prepare chat data
            $chat['lastMessage'] = $lastMessage;
            $chat['participants'] = $participants;

            return $this->success($chat, 'Chat fetched successfully');
        } catch (\Exception $e) {
            return $this->error($e->getMessage(), $e->getCode() ?: 500);
        }
    }

    /**
     * Get User ID from Firebase token
     */
    private function getUserIdFromToken(): string
    {
        try {
            $token = request()->bearerToken();

            if (!$token) {
                throw new \Exception('Token not provided');
            }

            $verifiedIdToken = $this->auth->verifyIdToken($token, true, 300);
            $userId = $verifiedIdToken->claims()->get('sub');


            if (!$userId) {
                throw new \Exception('Unable to get user ID from token');
            }

            return $userId;
        } catch (RevokedIdToken $e) {
            throw new \Exception('Token has been revoked', 401);
        } catch (\InvalidArgumentException $e) {
            throw new \Exception('Invalid token format', 400);
        } catch (\Exception $e) {
            throw new \Exception('Token verification failed: ' . $e->getMessage(), 401);
        }
    }
}
