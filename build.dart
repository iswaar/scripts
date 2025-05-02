import 'dart:io';

class logger {
  void warn(String message) {
    print('WARNING: $message');
  }

  void info(String message) {
    print('INFO: $message');
  }
}

void compile(logger log, Directory Folder) {
  ProcessResult process = Process.runSync("dart", [
    "compile",
    "exe",
    Folder.path + "/src/main.dart",
    "-o",
    "build/" + Folder.path.split('/').last,
  ]);
  if (process.exitCode == 0) {
    log.info("Successfull compiled ${Folder.path}/src/main.dart");
    exit(0);
  } else {
    log.warn("Failed to build ${Folder.path}/src/main.dart");
    print("=== StdERR " + "=" * (stdout.terminalColumns - 11));
    print(process.stderr);
    exit(1);
  }
}

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print("--build : compile");
    exit(-1);
  }
  logger log = logger();
  void iterate(FileSystemEntity entity) {
    if ((entity.statSync().type == FileSystemEntityType.directory) &
        (!([
          '.git',
          '.vscode',
          'build',
          '.zsh',
        ].any((String x) => entity.path.contains(x))))) {
      compile(log, Directory(entity.path));
    }
  }

  if (arguments.first == "--build") {
    Directory(
      ".",
    ).listSync().forEach((FileSystemEntity entity) => iterate(entity));
  }
}
