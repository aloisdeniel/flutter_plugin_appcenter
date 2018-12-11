import 'dart:io';

void main() async {
  print("-----------------------");
  print("     < B U I L D >");
  print("-----------------------");

  final packageFolders = [
    "src/appcenter",
    "src/appcenter_analytics",
    "src/appcenter_crashes"
  ];

  await stepProcess(
      "Formatting code",
      ".",
      'dartfmt',
      [
        '-w',
      ]..addAll(packageFolders.map((p) => p + "/lib")));

  // Updating version in pubspecs
  String version;
  await step("Enter the new version", () {
    version = stdin.readLineSync();
  });
  for (var dir in packageFolders) {
    var pubspec = File(dir + "/pubspec.yaml");
    await step("Updating version in '${pubspec.path}'", () async {
      var contents = await pubspec.readAsString();
      contents = contents.replaceFirst(
          RegExp('version: ([^\\n]*)'), 'version: ' + version.trim());
      await pubspec.writeAsString(contents);
    });
  }

  // Dry run
  for (var dir in packageFolders) {
    await stepProcess(
        "Dry run for '$dir' package", dir, 'pub', ['publish', '--dry-run']);
  }

  bool readyForPublishing = false;
  await step("Ready for publishing ? (y/N)", () {
    readyForPublishing = stdin.readLineSync().toLowerCase() == "y";
  });

  if (readyForPublishing) {
    for (var dir in packageFolders) {
      await stepProcess(
          "Publising '$dir' package", dir, 'pub', ['publish', '--force']);
    }
  }
}

Future stepProcess(
    String description, String cwd, String command, List<String> args) {
  return step(description, () async {
    final result = await Process.run(
      command,
      args,
      workingDirectory: cwd,
    );
    print("<end>");
    print(result.stdout);
    print(result.stderr);
  });
}

Future step(String description, Future execute()) {
  print("\n${_step++}. $description...");
  print("----------------------------------------------------");
  return execute();
}

var _step = 1;
