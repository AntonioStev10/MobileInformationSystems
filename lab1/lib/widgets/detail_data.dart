import 'package:flutter/material.dart';

class DetailData extends StatelessWidget {
  final int id;

  const DetailData({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: 500,
      ),
      child: const Column(
        children: [],
      ),
    );
  }
}
