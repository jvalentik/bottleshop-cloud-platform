import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/features/auth/presentation/dialogs/terms_and_conditions_dialog.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TermsAndConditionsTile extends HookConsumerWidget {
  const TermsAndConditionsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecked = ref.watch(termsAcceptanceProvider);
    return IntrinsicWidth(
      child: CheckboxListTile(
        activeColor: Theme.of(context).primaryColor,
        checkColor: Theme.of(context).colorScheme.secondary,
        selected: isChecked,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (newValue) async {
          if (newValue == true) {
            if (await showDialog<bool>(
                  context: context,
                  builder: (context) => const TermsAndConditionsDialog(),
                ) ==
                true) {
              ref.read(termsAcceptanceProvider.notifier).acceptTerms();
            } else {
              ref.read(termsAcceptanceProvider.notifier).rejectTerms();
            }
          } else {
            ref.read(termsAcceptanceProvider.notifier).rejectTerms();
          }
        },
        value: isChecked,
        title: Text(
          context.l10n.termsTitleMainScreen,
          textAlign: TextAlign.left,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}
