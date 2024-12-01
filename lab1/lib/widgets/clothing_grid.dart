import 'package:flutter/material.dart';
import '../models/clothing_model.dart';
import '../widgets/clothing_card.dart';

class ClothingGrid extends StatefulWidget {
  final List<ClothingItem> clothingItems;

  const ClothingGrid({super.key, required this.clothingItems});

  @override
  _ClothingGridState createState() => _ClothingGridState();
}

class _ClothingGridState extends State<ClothingGrid> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GridView.count(
      padding: const EdgeInsets.all(6),
      crossAxisCount: 2,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      semanticChildCount: widget.clothingItems.length,
      childAspectRatio: 200 / 244,
      physics: const BouncingScrollPhysics(),
      children: widget.clothingItems.map((item) {
        return ClothingCard(
          id: item.id,
          name: item.name,
          image: item.img,
          price: item.price,
          description: item.description,
        );
      }).toList(),
    );
  }
}
