import 'package:flutter/material.dart';
import '../models/clothing_model.dart';
import '../widgets/clothing_grid.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    List<ClothingItem> clothingItems = [
      ClothingItem(
        id: 1,
        name: "Polo Shirt",
        img: "https://m.media-amazon.com/images/I/81NahZXF9QL._AC_SL1396_.jpg",
        price: 19.99,
        description: "Comfortable polo shirt made of cotton.",
      ),
      ClothingItem(
        id: 2,
        name: "Jeans",
        img:
            "https://lsco.scene7.com/is/image/lsco/005010193-alt1-pdp-ld?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=2000&hei=1840",
        price: 99.99,
        description: "Stylish and comfortable jeans for everyday wear.",
      ),
      ClothingItem(
        id: 3,
        name: "Jacket",
        img:
            "https://lsco.scene7.com/is/image/lsco/163650128-front-pdp-ld?fmt=jpeg&qlt=70&resMode=sharp2&fit=crop,1&op_usm=0.6,0.6,8&wid=2000&hei=1840",
        price: 149.99,
        description: "Warm jacket perfect for winter and outdoor activities.",
      ),
      ClothingItem(
        id: 4,
        name: "Sneakers",
        img:
            "https://www.robelshoes.eu/sub/robel.sk/images/shop-active-images/yw0yw009110k4-whtblk_6_1.jpg",
        price: 59.99,
        description: "Comfortable sneakers for casual wear.",
      ),
      ClothingItem(
        id: 5,
        name: "Hat",
        img:
            "https://imagena1.lacoste.com/dw/image/v2/AAUP_PRD/on/demandware.static/-/Sites-master/default/dw4cff100a/RK2056_HDE_24.jpg",
        price: 15.99,
        description: "Stylish hat to complete your look.",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("212029"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ClothingGrid(clothingItems: clothingItems),
    );
  }
}
