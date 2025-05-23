import 'dart:math';
import 'query.dart';
import 'dart:io';

void background_process(String process) {
  // uses bash for now ( maybe temporary lol )
  Process.start('bash', [
    "-c",
    ' ( ( ($process)& ) && disown) || echo failed ; exit',
  ], mode: ProcessStartMode.detached);
}

void reload_pywal(String background) {
  String user = Process.runSync("whoami", []).stdout.toString();
  if (Process.runSync("pidof", ["swww-daemon"]).exitCode == 0) {
    Process.runSync('wal', ["-i", background]);
  } else {
    Process.runSync("ffmpeg", [
      "-y",
      "-i",
      background,
      "-vf",
      "select=gte(n\, 10)",
      "-vframes",
      "1",
      "/home/$user/.tmp.jpg",
    ]);
    Process.runSync("wal", ["-i", "/home/$user/.tmp.jpg"]);
  }
}

void set_background(String background, {bool live = false}) {
  if (live) {
    // start mpvpaper in the background and make it loop without audio on eDP-1
    if (is_live_background()) {
      Process.runSync('pkill', ['mpvpaper']);
    }
    background_process("mpvpaper eDP-1 '$background' -o 'no-audio loop'");
  } else {
    // set the background using swww as the wallpaper engine

    if (is_live_background()) {
      background_process('swww-daemon --format xrgb');
    }

    Process.runSync("swww", [
      "img",
      background,
      "--transition-type=grow",
      "--transition-duration=3",
      "--transition-pos=top",
    ]);
  }
}

void control(File background, {bool live = false}) {
  if (!live) {
    Process.runSync('pkill', ['mpvpaper']);
    set_background(background.path, live: live);
  } else {
    Process.runSync('pkill', ['swww']);
    set_background(background.path, live: live);
  }
}

void random_background() {
  String current_background = get_background();
  String wallpaper_directory = get_directory(current_background);
  List<String> avaliable_backgrounds = [];
  for (var file in directory_list_files(Directory(wallpaper_directory))) {
    if (file != current_background) {
      avaliable_backgrounds += [file.path];
    }
  }
  String chosen =
      avaliable_backgrounds[Random().nextInt(avaliable_backgrounds.length)];
  set_background(chosen, live: (is_live_background()));
}

void increment(Directory directory, File current_background) {
  List<String> listing = [];
  directory_list_files(
    directory,
  ).forEach(((FileSystemEntity file) => listing += [file.path]));
  listing.sort();
  int index = listing.indexOf('${current_background.path}');
  String next = listing[(index + 1) % listing.length];
  set_background(next, live: is_live_background());
}

void decrement(Directory directory, File current_background) {
  List<String> listing = [];
  directory_list_files(
    directory,
  ).forEach(((FileSystemEntity file) => listing += [file.path]));
  listing.sort();
  int index = listing.indexOf('${current_background.path}');
  String next = listing[index - 1];
  set_background(next, live: is_live_background());
}

void Folder_switch(Directory master_folder, int offset) {
  List<String> folders = [];
  List<String> avaliable_backgrounds = [];
  int index = folders.indexOf(File(get_background()).parent.parent.path);
  String chosen;

  void correct_type(File file, {bool live = false}) {
    int type = check_live_or_static(file.path);

    // ignore other types
    if (type == -1) {
      return null;
    }

    if (live) {
      if (type == 0) {
        avaliable_backgrounds += [file.path];
      }
    } else {
      if (type == 1) {
        avaliable_backgrounds += [file.path];
      }
    }
  }

  directory_list_folders(
    master_folder,
  ).forEach((Directory dir) => folders += [dir.path]);
  folders.sort();
  Directory next_folder = Directory(folders[(index + offset) % folders.length]);
  directory_list_files(
    next_folder,
  ).forEach((File file) => correct_type(file, live: is_live_background()));
  chosen =
      avaliable_backgrounds[Random().nextInt(avaliable_backgrounds.length)];
  set_background(chosen, live: is_live_background());
}
