import 'dart:io';


String get_background () {
  ProcessResult query = Process.runSync("swww", ["query"]);
  if (query.exitCode == 1) {
    exit(1);
  }
  if (query.stdout.isNotEmpty) {
    String data = query.stdout.toString();
    data = data.split("image: ")[1].split("\n")[0];
    return data;
  }
  return "";
}