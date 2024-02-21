import 'package:args/args.dart';

import 'commands/remove_branches.dart';
import 'config/command_context.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addCommand(
      'branch',
      ArgParser()..addCommand('remove'),
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart gitt.dart <flags> [arguments]');
  print(argParser.usage);
}

Future<void> main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('gitt version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    switch (results.command) {
      case ArgResults(name: 'branch', command: final branchCommand):
        switch (branchCommand) {
          case ArgResults(name: 'remove'):
            await RemoveBranches().execure(CommandContext(verbose: verbose));

          default:
            print('no command provided, exitting');
        }

      default:
        print('no command provided, exitting');
    }

    return;
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
