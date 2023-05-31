import 'package:flutter/material.dart';
import '../models/models.dart';

class RecommendationCard extends StatelessWidget {
  final CharactersModel recData;

  RecommendationCard({
    required this.recData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      clipBehavior: Clip.none,
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  recData.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              recData.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
