import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import 'basket_screen.dart';
import 'basket_item.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Map<String, BasketItem> basketItems = <String, BasketItem>{};
  int _selectedIndex = 0;

  void addToBasket(String name, String image, int price) {
    setState(() {
      if (basketItems.containsKey(name)) {

        final currentItem = basketItems[name]!;
        basketItems[name] = BasketItem(
          name: name,
          image: image,
          price: price,
          quantity: currentItem.quantity + 1,
        );
      } else {

        basketItems[name] = BasketItem(
          name: name,
          image: image,
          price: price,
          quantity: 1,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $name to basket'),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }


  Widget _buildCategoryButton(String text, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedIndex = ['Hottest', 'Popular', 'New combo', 'Top']
                .indexOf(text);
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Color(0xFFFFB067) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_basket_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BasketScreen(items: basketItems),
                    ),
                  );
                },
              ),
              if (basketItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      basketItems.values
                          .fold(0, (sum, item) => sum + item.quantity)
                          .toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello ${widget.userName}, What fruit salad\ncombo do you want today?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.tune),
                hintText: 'Search for fruit salad combos',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Recommended Combo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildComboCard('Honey lime combo', 2000, 'assets/honey_lime.png'),
                  _buildComboCard('Berry mango combo', 8000, 'assets/berry_mango.png'),
                ],
              ),
            ),
            SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton('Hottest', _selectedIndex == 0),
                  _buildCategoryButton('Popular', _selectedIndex == 1),
                  _buildCategoryButton('New combo', _selectedIndex == 2),
                  _buildCategoryButton('Top', _selectedIndex == 3),
                ],
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildComboCard('Quinoa fruit salad', 10000, 'assets/quinoa.png'),
                _buildComboCard('Tropical fruit salad', 10000, 'assets/tropical.png'),
                _buildComboCard('Melon fruit salad', 10000, 'assets/melon.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}