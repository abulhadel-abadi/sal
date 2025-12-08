import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Royal Honey',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9), // خلفية رمادية فاتحة جداً
        fontFamily: 'Segoe UI', // خط نظيف
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      home: const Main(),
    );
  }
}
class Product {
  final String title;
  final String category;
  final double price;
  final String image;
  final double rating;

  Product(this.title, this.category, this.price, this.image, this.rating);
}

final List<Product> allProducts = [
  Product("عسل سدر ملكي", "سدر", 300.0, "images/Royal Sider.jpg", 5.0),
  Product("العسل الجبلي", "جبلي", 120.0, "images/Mountain Honey.jpg", 4.5),
  Product("عسل سمره", "سمره", 200.0, "images/Samra.jpeg", 4.8),
  Product("عسل المراعي", "مراعي", 180.0, "images/Pastures.png", 4.2),
  Product("شمع عسل طبيعي", "شمع", 150.0, "images/Grove.jpg", 4.9),
  Product("عسل سدر طبيعي", "سدر", 250.0, "images/Sider.jpg", 4.3),
];

final ValueNotifier<Map<String, int>> cartNotifier = ValueNotifier({});

void addToCart(Product product) {
  final map = Map<String, int>.from(cartNotifier.value);
  map[product.title] = (map[product.title] ?? 0) + 1;
  cartNotifier.value = map;
}

void removeOneFromCart(Product product) {
  final map = Map<String, int>.from(cartNotifier.value);
  if (!(map.containsKey(product.title))) return;
  final current = (map[product.title] ?? 0);
  if (current <= 1) {
    map.remove(product.title);
  } else {
    map[product.title] = current - 1;
  }
  cartNotifier.value = map;
}

int cartItemCount(Product product) => cartNotifier.value[product.title] ?? 0;


class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ShopPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFFFFA000),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'المتجر'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'السلة'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("متجر ألوانه للعسل"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))],
        backgroundColor: Colors.orangeAccent,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [Color(0xFFFFB300), Color(0xFFFF6F00)]),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 20, top: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("خصم 20%", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text("على جميع أنواع\nعسل السدر", style: TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.orange),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopPage()));
                            },
                            child: const Text("تسوق الآن")
                        )
                      ],
                    ),
                  ),
                  const Positioned(left: -20, bottom: -20, child: Icon(Icons.hive, size: 150, color: Colors.white24)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("الأكثر مبيعاً", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ProductItemCard(product: allProducts[index], isWide: false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  final List<String> categories = ["الكل", "سدر", "الجبلي", "سمره", "مراعي", "شمع"];
  String selectedCategory = "الكل";

  @override
  Widget build(BuildContext context) {

    String normalizeCategory(String s) => s.startsWith('ال') ? s.substring(2) : s;

    List<Product> filteredProducts = selectedCategory == "الكل"
        ? allProducts
        : allProducts
        .where((p) => normalizeCategory(p.category) == normalizeCategory(selectedCategory))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text("المتجر"),backgroundColor: Colors.orange,),
      body: Column(
        children: [

          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = categories[index] == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(categories[index]),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFFB300),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductItemCard(product: filteredProducts[index], isWide: false);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Product product;
  const DetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFFFFB300),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.amber[50],
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text("${product.price} ر.س", style: const TextStyle(fontSize: 22, color: Color(0xFFFF6F00), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        Text(" ${product.rating} (120 تقييم)", style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("الوصف", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text(
                      "هذا العسل طبيعي 100% تم استخراجه بعناية فائقة من مناحلنا الخاصة. يتميز بمذاق غني وفوائد صحية متعددة لرفع المناعة.",
                      style: TextStyle(color: Colors.black54, height: 1.5),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                        ),
                        onPressed: () {
                          addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تمت الإضافة للسلة")));
                        },
                        child: const Text("أضف إلى السلة", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("سلة التسوق"),backgroundColor: Colors.orangeAccent,),
      body: Column(
        children: [

          Expanded(
            child: ValueListenableBuilder<Map<String, int>>(
              valueListenable: cartNotifier,
              builder: (context, cartMap, _) {
                final products = allProducts;
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  separatorBuilder: (c, i) => const Divider(),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final qty = cartMap[product.title] ?? 0;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(color: Colors.amber[50], borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(product.image, fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${product.price} ر.س"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () { removeOneFromCart(product); }, icon: const Icon(Icons.remove_circle_outline, color: Colors.grey)),
                          Text(qty.toString(), style: const TextStyle(fontSize: 16)),
                          IconButton(onPressed: () { addToCart(product); }, icon: const Icon(Icons.add_circle, color: Colors.amber)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder<Map<String, int>>(
            valueListenable: cartNotifier,
            builder: (context, cartMap, _) {
              double subtotal = 0;
              cartMap.forEach((title, qty) {
                final product = allProducts.firstWhere((p) => p.title == title);
                subtotal += product.price * qty;
              });
              final shipping = subtotal > 0 ? 20.0 : 0.0;
              final total = subtotal + shipping;

              return Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                ),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("المجموع الفرعي"), Text("${subtotal.toStringAsFixed(0)} ر.س")]),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("الشحن"), Text("${shipping.toStringAsFixed(0)} ر.س")]),
                    const Divider(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("الإجمالي", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("${total.toStringAsFixed(0)} ر.س", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber))
                        ]
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB300), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutPage()));
                        },
                        child: Text("إتمام الشراء (${total.toStringAsFixed(0)} ر.س)", style: const TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الدفع والشحن"),backgroundColor: Colors.orangeAccent,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("معلومات المستلم", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم الكامل',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'الرجاء إدخال الاسم' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'عنوان التوصيل',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'الرجاء إدخال عنوان التوصيل' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("طريقة الدفع", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // بطاقة ائتمانية وهمية
            Container(
              height: 140,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [Color(0xFF232526), Color(0xFF414345)]),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.credit_card, color: Colors.white, size: 30),
                  Text("**** **** **** 1234", style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2)),
                ],
              ),
            ),
            const Spacer(),
            ValueListenableBuilder<Map<String, int>>(
              valueListenable: cartNotifier,
              builder: (context, cartMap, _) {
                double subtotal = 0;
                cartMap.forEach((title, qty) {
                  final product = allProducts.firstWhere((p) => p.title == title);
                  subtotal += product.price * qty;
                });
                final shipping = subtotal > 0 ? 20.0 : 0.0;
                final total = subtotal + shipping;

                return Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("المجموع الفرعي"), Text("${subtotal.toStringAsFixed(0)} ر.س")]),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("الشحن"), Text("${shipping.toStringAsFixed(0)} ر.س")]),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                        ),
                        onPressed: () {
                          if (cartMap.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('السلة فارغة')));
                            return;
                          }
                          if (!_formKey.currentState!.validate()) return;
                          // Proceed to payment (mock)
                          showDialog(context: context, builder: (_) => AlertDialog(
                            title: const Icon(Icons.check_circle, color: Colors.green, size: 50),
                            content: Text('تم استلام طلبك بنجاح!\nالمبلغ: ${total.toStringAsFixed(0)} ر.س', textAlign: TextAlign.center),
                            actions: [
                              TextButton(onPressed: () {
                                // clear cart and pop
                                cartNotifier.value = {};
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }, child: const Text('حسناً'))
                            ],
                          ));
                        },
                        child: Text("تأكيد ودفع (${total.toStringAsFixed(0)} ر.س)", style: const TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          const CircleAvatar(radius: 50, backgroundColor: Colors.amber, child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 10),
          const Text("متجر الوانه", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("tarshom abdullah@example.com", style: TextStyle(color: Colors.grey)),
          const Text("abadi abdullah@example.com", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                children: const [
                  ProfileTile(icon: Icons.history, title: "طلباتي السابقة"),
                  ProfileTile(icon: Icons.location_on_outlined, title: "عناويني"),
                  ProfileTile(icon: Icons.favorite_border, title: "المفضلة"),
                  Divider(),
                  ProfileTile(icon: Icons.info_outline, title: "من نحن"),
                  ProfileTile(icon: Icons.phone_outlined, title: "اتصل بنا"),
                  ProfileTile(icon: Icons.logout, title: "تسجيل الخروج", isDestructive: true),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProductItemCard extends StatelessWidget {
  final Product product;
  final bool isWide;

  const ProductItemCard({super.key, required this.product, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsPage(product: product))),
      child: Container(
        width: 160,
        margin: isWide ? null : const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${product.price} ر.س", style: const TextStyle(color: Color(0xFFFF6F00), fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.black87),
                        onPressed: () {
                          addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تمت الإضافة للسلة")));
                        },
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;
  const ProfileTile({super.key, required this.icon, required this.title, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isDestructive ? Colors.red[50] : Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: isDestructive ? Colors.red : Colors.black87),
      ),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}