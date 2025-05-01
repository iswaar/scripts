import 'dart:io';
import 'query.dart';
import 'override.dart';

void main(List<String> arguments) {
  String user = Process.runSync('whoami', []).stdout;
  File default_background_static = File(
    "/home/$user/.wallpapers/static/default.png",
  );
  File default_background_live = File(
    "/home/$user/.wallpapers/live/default.mp4",
  );

  if (default_background_live.parent.parent !=
      default_background_static.parent.parent) {
    print(
      'live and static wallpapers parent parent directories does not match',
    );
    exit(-1);
  }

  Directory default_directory = default_background_static.parent.parent;

  if (arguments.isEmpty) {
    print("#");
  } else if (arguments[0] == "--bar") {
    reload_pywal(get_background());
  } else if (arguments[0] == "--toggle") {
    if (is_live_background()) {
      control(default_background_live, live: false);
    } else {
      control(default_background_static, live: true);
    }
  } else if (is_live_background()) {}
}
