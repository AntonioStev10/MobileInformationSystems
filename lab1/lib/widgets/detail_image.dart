import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  final String image;

  const DetailImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(image,
          fit: BoxFit.contain, alignment: Alignment.center),
    );
  }
}
