import 'package:flutter/material.dart';

enum NavTabItem {
  move(Size(24, 24), 'Move', Icons.local_fire_department_outlined),
  eat(Size(24, 24), 'Eat', Icons.restaurant_rounded),
  expore(Size(24, 24), 'Explore', Icons.explore_rounded),
  library(Size(24, 24), 'Library', Icons.collections_bookmark_rounded);

  const NavTabItem(this.size, this.label, this.selectedIcon);

  final Size size;
  final String label;
  final IconData selectedIcon;
}
