<?php

namespace App\Http\Controllers;

use App\Events\NewMessageSent;
use App\Http\Requests\GetMessageRequest;
use App\Http\Requests\StoreMessageRequest;
use Kreait\Firebase\Contract\Database;
use Kreait\Firebase\Exception\Auth\RevokedIdToken;
use Illuminate\Http\JsonResponse;
use Kreait\Firebase\Contract\Auth;

class ChatMessageController extends Controller
{
    protected $database;
    protected $tablename = 'chat_messages';
    protected $auth;

    public function __construct(Database $database, Auth $auth)
    {
        $this->database = $database;
        $this->auth = $auth;
    }

    /**
     * Gets chat message
     *
     * @param GetMessageRequest $request
     * @return JsonResponse
     */
    public function index(GetMessageRequest $request): JsonResponse
    {
        $data = $request->validated();
        $chatId = $data['chat_id'];
        $currentPage = $data['page'];
        $pageSize = $data['page_size'] ?? 15;

        try {
            // Get messages ordered by created_at
            $messagesRef = $this->database->getReference("{$this->tablename}/{$chatId}/messages")
                ->orderByChild('created_at')
                ->limitToLast($pageSize)
                ->getSnapshot();

            if ($messagesRef->exists()) {
                // Convert the snapshot to an array and reverse it to get the correct order
                $messages = array_reverse($messagesRef->getValue());

                return $this->success($messages, 'Messages retrieved successfully');
            } else {
                return $this->success([], 'No messages found');
            }
        } catch (\Exception $e) {
            return $this->error($e->getMessage());
        }
    }

    /**
     * Create a chat message
     *
     * @param StoreMessageRequest $request
     * @return JsonResponse
     */
    // public function store(StoreMessageRequest $request) : JsonResponse
    // {
    //     try {

    //         $data = $request->validated();
    //         $data['created_by'] = $this->getUserIdFromToken();
    //         $data['created_at'] = now()->toDateTimeString();

    //         $chatId = $data['chat_id'];
    //         unset($data['chat_id']);

    //         // Save message to Firebase Realtime Database
    //         $messageRef = $this->database->getReference("{$this->tablename}/{$chatId}/messages")->push($data);
    //         $messageId = $messageRef->getKey();

    //         // Retrieve the message along with user information
    //         $message = $this->database->getReference("{$this->tablename}/{$chatId}/messages/{$messageId}")->getValue();
    //         $message['id'] = $messageId;

    //         $this->sendNotificationToOther($chatId, $message);

    //         return $this->success($message, 'Message has been sent successfully.');
    //     } catch (\Exception $e) {
    //         return $this->error($e->getMessage());
    //     }
    // }
    public function store(StoreMessageRequest $request): JsonResponse
    {
        try {
            $data = $request->validated();
            $data['created_by'] = $this->getUserIdFromToken();
            $data['created_at'] = now()->toDateTimeString();

            $chatId = $data['chat_id'];

            // Save message to Firebase Realtime Database
            $messageRef = $this->database->getReference("{$this->tablename}/{$chatId}/messages")->push($data);
            $messageId = $messageRef->getKey();

            // Retrieve the message along with user information
            $message = $this->database->getReference("{$this->tablename}/{$chatId}/messages/{$messageId}")->getValue();
            $message['id'] = $messageId;
            $message['chat_id'] = $chatId; // Make sure chat_id is included

            $this->sendNotificationToOther($chatId, $message);

            return $this->success($message, 'Message has been sent successfully.');
        } catch (\Exception $e) {
            return $this->error($e->getMessage());
        }
    }


    /**
     * Send notification to other users
     *
     * @param string $chatId
     * @param array $chatMessage
     */
    private function sendNotificationToOther(string $chatId, array $chatMessage) : void
    {
        broadcast(new NewMessageSent($chatMessage))->toOthers();
        try {
            $userId = $this->getUserIdFromToken();

            // Ambil partisipan dari chat kecuali user saat ini
            $chatParticipants = $this->database->getReference("{$this->tablename}/{$chatId}/participants")
                ->getValue();

            if ($chatParticipants) {
                foreach ($chatParticipants as $participantId => $participant) {
                    if ($participantId !== $userId) {
                        $otherUser = $this->database->getReference("users/{$participantId}")->getValue();
                        if ($otherUser) {
                            // Send notification to other user
                            $this->sendNewMessageNotification($otherUser, [
                                'senderName' => auth()->user()->name,
                                'message' => $chatMessage['message'],
                                'chatId' => $chatId
                            ]);
                        }
                    }
                }
            }
        } catch (\Exception $e) {

        }
    }


    // private function sendNotificationToOther(string $chatId, array $chatMessage): void
    // {
    //     // Broadcast the event to Pusher
    //     broadcast(new NewMessageSent($chatMessage))->toOthers();
    //     $user = auth()->user();
    //     $userId = $this->getUserIdFromToken();
    //     // $userId = Auth::id();

    //     // Get participants of the chat except the sender
    //     $participantsRef = $this->database->getReference("{$this->tablename}/{$chatId}/participants")->getSnapshot();
    //     $participants = $participantsRef->getValue();

    //     foreach ($participants as $participantId => $participant) {
    //         if ($participantId !== $userId) {
    //             // Assuming you have a method to send notifications to the user
    //             $this->sendNewMessageNotification($participantId, $chatMessage);
    //         }
    //     }
    // }

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