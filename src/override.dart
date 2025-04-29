import 'dart:io';

void reload_pywal (String background) {
  String user = Process.runSync("whoami", []).stdout.toString();
  if (Process.runSync("pidof", ["swww-daemon"]).exitCode == 0) { 
    Process.runSync('wal', ["-i", background]);
  } else {
    Process.runSync("ffmpeg", [
      "-y", "-i", background, "-vf", "select=gte(n\, 10)", "-vframes",
      "1", "/home/$user/.tmp.jpg"
    ]);
    Process.runSync("wal", ["-i", "/home/$user/.tmp.jpg"]);
  }
}