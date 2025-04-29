import 'dart:io';

class logger {
  void warn ( String message ) {
    print('WARNING: $message');
  }
  void info ( String message ) {
    print('INFO: $message');
  }
}


void compile (logger log) {
  if (Process.runSync(
        "dart", ["compile", "exe", "src/main.dart", "-o", "build/waybar"]
  ).exitCode == 0) {
    log.info("Successfull compiled src/main.dart"); 
    exit(0);
  } else {
    log.warn("Failed to build src/main.dart");      
    exit(1); 
  }
}

void run (logger log, List<String> args) {
  if (Process.runSync("dart", ["run", "src/main.dart"] + args).exitCode == 0
  ) {
    log.info("Successfull ran src/main.dart");
    exit(0);
  } else {
    log.warn("Error running src/main.dart");
    exit(1);
  }
}



void main ( List<String> arguments ) {
  if (arguments.isEmpty) {
    print("""
--build : compile
--run   : quick run""");
    exit(-1);
  }
  logger log = logger();
  if (arguments.first == "--build") {
    compile(log);
  } 
  if (arguments.first == "--run") {
    run(log, arguments);
  }
}