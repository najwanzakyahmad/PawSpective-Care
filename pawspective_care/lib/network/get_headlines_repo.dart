import 'dart:convert';
import 'package:pawspective_care/models/article_model.dart';
import 'package:http/http.dart' as http;

class GetHeadlines {
  static Future<List<ArticleModel>> getHeadlines() async {
    const url =
        'https://newsapi.org/v2/everything?q=cats+dogs+pets+care&apiKey=035baea4ea114dfbae42cf3d77f27c79';
    // 'https://newsapi.org/v2/everything?q=(dog health OR cat health OR dog care OR cat care OR dog treatment OR cat treatment)&apiKey=035baea4ea114dfbae42cf3d77f27c79';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> list = json.decode(response.body);
        List<dynamic> articleRawList = list["articles"];
        List<ArticleModel> articleModelList = articleRawList
            .map((article) => ArticleModel(
                source: article['source']['name'],
                author: article['author'],
                title: article['title'],
                description: article['description'],
                articleUrl: article['url'],
                imageUrl: article["urlToImage"],
                publishedAt: article["publishedAt"],
                content: article["content"]))
            .toList();
        return articleModelList;
      } else {
        throw Exception("Failed to load headlines");
      }
    } catch (e) {
      throw Exception("Failed to load headlines");
    }
  }
}
