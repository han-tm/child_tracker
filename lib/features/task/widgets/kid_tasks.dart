import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

class KidTasksWidget extends StatelessWidget {
  const KidTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTaskChip = KidTaskChip.values[0];
    return Column(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 12, 24),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: KidTaskChip.values
                .map((e) => TaskChip(
                      label: kidTaskChipRusName(e),
                      selected: selectedTaskChip == e,
                    ))
                .toList(),
          ),
        ),
        const Expanded(
          child: KidTaskList(tasks: []),
        ),
      ],
    );
  }
}
