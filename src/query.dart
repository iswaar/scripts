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
  return '';
}

List<int> get_process_id(String process) {
  String ps = Process.runSync('bash', ['-c', 'ps -e | grep "$process"']).stdout;
  List<String> line_split = ps.split('\n');
  List<int> data = [];
  for (var line in line_split) {
    data += [int.parse(line.split(' ')[0])];
  }
  return data;
}

List<File> directory_list_files(Directory path) {
  List<FileSystemEntity> listing = path.listSync();
  List<File> data = [];
  for (var entity in listing) {
    if (entity.statSync().type == FileSystemEntityType.file) {
      data += [File(entity.path)];
    }
  }
  return data;
}

List<Directory> directory_list_folders(Directory path) {
  List<FileSystemEntity> listing = path.listSync();
  List<Directory> data = [];
  for (var entity in listing) {
    if (entity.statSync().type == FileSystemEntityType.directory) {
      data += [Directory(entity.path)];
    }
  }
  return data;
}

String get_directory(String file) {
  File FS_entity = File(file);
  return FS_entity.parent.toString();
}

bool is_live_background() {
  return ((Process.runSync("pidof", ["swww-daemon"]).exitCode) != 0);
}
