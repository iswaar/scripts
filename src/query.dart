import 'dart:io';

String get_background() {
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

List<String> directory_list_files(Directory path) {
  List<FileSystemEntity> listing = path.listSync();
  List<String> data = [];
  for (var entity in listing) {
    if (entity.statSync().type == FileSystemEntityType.file) {
      data += [entity.path];
    }
  }
  return data;
}

List<String> directory_list_folders(Directory path) {
  List<FileSystemEntity> listing = path.listSync();
  List<String> data = [];
  for (var entity in listing) {
    if (entity.statSync().type == FileSystemEntityType.directory) {
      data += [entity.path];
    }
  }
  return data;
}

String get_directory(String file) {
  File FS_entity = File(file);
  return FS_entity.parent.toString();
}
