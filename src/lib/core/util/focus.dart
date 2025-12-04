import 'package:flutter/material.dart';

void unFocusTextField() {
  FocusManager.instance.primaryFocus?.unfocus();
}
