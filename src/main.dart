import 'dart:io';
import 'query.dart';
import 'override.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("#");
  } else if (arguments[0] == "--bar") {
    reload_pywal(get_background());
  } 
}
