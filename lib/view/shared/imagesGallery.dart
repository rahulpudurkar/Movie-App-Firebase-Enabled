import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class imagesGallery extends StatelessWidget {
  final List<String> imageUrls;

  imagesGallery({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: imageUrls.map((url) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), 
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: url,
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(), 
                  errorWidget: (context, url, error) => Icon(Icons.error), 
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
