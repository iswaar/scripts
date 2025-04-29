import 'dart:io';


String get_background () {
  ProcessResult query = Process.runSync("swww", ["query"]);
  if (query.exitCode == 1) {
    exit(1);
  }
  if (query.stdout.isNotEmpty) {
    return query.stdout;
  }
  return "";
}