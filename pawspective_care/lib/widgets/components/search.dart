import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:feather_icons/feather_icons.dart';

class SearchColumn extends StatelessWidget {
  const SearchColumn({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(71, 79, 122, 1.0),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  prefixIcon: const Icon(FeatherIcons.search,
                      color: Color.fromRGBO(255, 208, 236, 1.0)),
                  suffixIcon: const Icon(FeatherIcons.mic,
                      color: Color.fromRGBO(255, 208, 236, 1.0))),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: const Duration(seconds: 2))
        .shimmer(duration: const Duration(seconds: 2));
  }
}
