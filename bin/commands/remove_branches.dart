import 'dart:io';
import 'package:interact_cli/interact_cli.dart';

import '../config/command_context.dart';

class RemoveBranches {
  Future<void> execure(CommandContext context) async {
    final branchResult = await Process.run(
      'git',
      ['branch'],
    );

    List<String> branches = (branchResult.stdout as String)
        .split('\n')
        .where((element) => !element.startsWith('*'))
        .where((element) => element.isNotEmpty)
        .map((e) => e.trim())
        .toList();

    if (branches.isEmpty) {
      print('no branches found');
      return;
    }

    final selected = MultiSelect(
      prompt: 'Select branches to delete',
      options: branches,
      defaults: List.filled(branches.length, true),
    ).interact().map((e) => branches[e]).toList();

    await Future.wait(
      selected.map(
        (branch) => Process.start(
          'git',
          ['branch', '-D', branch],
        ),
      ),
    );

    print('Branches deleted:\n\t${selected.join('\n\t')}');
  }
}
