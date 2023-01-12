import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditOpeningHoursCheckbox extends HookWidget {
  const EditOpeningHoursCheckbox({
    Key? key,
    required this.rowIndex,
  }) : super(key: key);

  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    useProvider(hasChangedProvider).state;

    final openingHours = useProvider(editedHoursProvider).state;
    final today = openingHours?.today(rowIndex);

    void newOpeningHours(
        OpeningHoursModel? openingHours, bool? value, int rowIndex) {
      context.read(editedHoursProvider).state = openingHours?.setDay(
        rowIndex,
        value == false
            ? OpeningHoursEntryModel.closed()
            : OpeningHoursEntryModel.opened(),
      );
    }

    return Checkbox(
      key: ValueKey(rowIndex),
      value: today?.isOpened(),
      onChanged: (value) {
        context.read(hasChangedProvider).state = true;
        newOpeningHours(openingHours, value, rowIndex);
      },
    );
  }
}
