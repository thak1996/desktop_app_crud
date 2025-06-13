import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../core/colors.dart';
import 'menu_itens.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final controller = MenuItens();
  int currentIndex = 0;
  bool selectedItem = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          background(
            Column(
              children: [
                Icon(AntDesign.sketch_outline, size: 150),
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      selectedItem = currentIndex == index;
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selectedItem
                              ? AppColors.primaryColor.withValues(alpha: 0.05)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(item.icon),
                          title: Text(item.title),
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: controller.items.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return SizedBox(child: controller.items[currentIndex].page);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget background(Widget child) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    width: 200,
    height: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.9),
          blurRadius: 1,
          spreadRadius: 0,
        ),
      ],
    ),
    child: child,
  );
}
