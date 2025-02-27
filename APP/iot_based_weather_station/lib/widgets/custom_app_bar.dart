// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'dart:ui';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Blur effect
          child: AppBar(
            backgroundColor: Colors.black.withOpacity(0.3), // Glass effect
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {},
            ),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 4),
                Text("Portable weather Station",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.wb_sunny, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: Container( 
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.12))),
              ),
            ),
          ),
        )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}