import 'package:flutter/material.dart';
import 'package:pawspective_care/network/get_headlines_repo.dart';
import 'package:pawspective_care/models/article_model.dart';
import 'package:pawspective_care/widgets/components/bottom_navigation_widget.dart';
import 'package:pawspective_care/widgets/helpers/loading_animation_widget.dart';
import 'package:pawspective_care/widgets/tiles/news_article_tile_widget.dart';
import 'package:pawspective_care/widgets/components/gradient_container_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<ArticleModel>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = GetHeadlines.getHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "ARTICLES LIST",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white),
                  ),
                ),
                const SearchColumn(),
                const SizedBox(height: 10),
                FutureBuilder<List<ArticleModel>>(
                  future: _articlesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingWidget();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No articles found.'));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var article = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(217, 217, 217, 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: NewsArticleTile(
                              author: article.author,
                              title: article.title,
                              date: article.publishedAt,
                              imageUrl: article.imageUrl,
                              articleUrl: article.articleUrl,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),

                // FutureBuilder<List<ArticleModel>>(
                //   future: _articlesFuture,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(child: CircularProgressIndicator());
                //     } else if (snapshot.hasError) {
                //       return Center(child: Text('Error: ${snapshot.error}'));
                //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //       return const Center(child: Text('No articles found.'));
                //     } else {
                //       return ListView.builder(
                //         shrinkWrap: true,
                //         physics: const NeverScrollableScrollPhysics(),
                //         itemCount: snapshot.data!.length,
                //         itemBuilder: (context, index) {
                //           var article = snapshot.data![index];
                //           return Container(
                //             constraints: BoxConstraints(
                //               maxWidth: MediaQuery.of(context).size.width,
                //             ),
                //             margin: const EdgeInsets.only(bottom: 16.0),
                //             padding: const EdgeInsets.all(0),
                //             decoration: BoxDecoration(
                //               color: const Color.fromRGBO(217, 217, 217, 1.0),
                //               borderRadius: BorderRadius.circular(8.0),
                //             ),
                //             child: NewsArticleTile(
                //               author: article.author,
                //               title: article.title,
                //               date: article.publishedAt,
                //               imageUrl: article.imageUrl,
                //               articleUrl: article.articleUrl,
                //             ),
                //           );
                //         },
                //       );
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
