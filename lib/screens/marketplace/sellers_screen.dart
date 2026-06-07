import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';

class SellersScreen extends StatefulWidget {
  const SellersScreen({super.key});

  @override
  _SellersScreenState createState() => _SellersScreenState();
}

class _SellersScreenState extends State<SellersScreen> {
  // Active button index
  int activeIndex = 0;
  final List<String> buttonLabels = [
    'Featured Items',
    'Most Recent',
    'Newest',
    'Popular',
    'Trending'
  ];

  // Sample product list
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Chequered Red Shirt',
      'price': 44.00,
      'image':
          'assets/images/daily_activity.png', // Replace with your asset path
      'discountedPrice': 50.00,
    },
    {
      'name': 'Zipped Jacket',
      'price': 43.00,
      'image': 'assets/images/inventory.png',
      'discountedPrice': null,
    },
    {
      'name': 'Navy Sports Jacket',
      'price': 35.00,
      'image': 'assets/images/sales.png',
      'discountedPrice': null,
    },
    {
      'name': 'Ocean Blue Shirt',
      'price': 32.00,
      'image': 'assets/images/expenses.png',
      'discountedPrice': null,
    },
    {
      'name': 'Navy Sports Jacket',
      'price': 35.00,
      'image': 'assets/images/sales.png',
      'discountedPrice': null,
    },
    {
      'name': 'Ocean Blue Shirt',
      'price': 32.00,
      'image': 'assets/images/expenses.png',
      'discountedPrice': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: buttonLabels.length,
                itemBuilder: (context, index) {
                  final isActive = index == activeIndex;

                  return Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 15.0 : 8.0,
                        right: index == 0 ? 8.0 : 8.0),
                    child: isActive
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                activeIndex = index;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  kPrimaryColor, // Active button color
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              buttonLabels[index],
                            ),
                          )
                        : OutlinedButton(
                            onPressed: () {
                              setState(() {
                                activeIndex = index;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              buttonLabels[index],
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
          // Product grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7, // Adjust this ratio for card aspect
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 1,
                        vertical: index == 0 || index == 1 ? 1 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kCanvasColor,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 1.0)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              product['image'],
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    '\$${product['price'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (product['discountedPrice'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        '\$${product['discountedPrice'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 5),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Add to Bag action
                                },
                                icon:
                                    Icon(Icons.shopping_bag_outlined, size: 16),
                                label: Text('Buy It Now'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    minimumSize: Size(double.infinity, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Add to Bag action
                                },
                                icon:
                                    Icon(Icons.shopping_bag_outlined, size: 16),
                                label: Text('Add to Bag'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    foregroundColor: Colors.black,
                                    minimumSize: Size(double.infinity, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
