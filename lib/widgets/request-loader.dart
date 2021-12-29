import 'package:flutter/material.dart';

Positioned requestLoader() {
  return Positioned(
      child: Expanded(
    flex: 1,
    child: Container(
      decoration: BoxDecoration(color: Color(0xFF3b5999).withOpacity(.85)),
      ),
    ),
  );
}
