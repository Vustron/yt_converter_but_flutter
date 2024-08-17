// utils
import 'package:flutter/material.dart';

Container deleteBg() {
  return Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: const Icon(Icons.delete, color: Colors.white),
  );
}
