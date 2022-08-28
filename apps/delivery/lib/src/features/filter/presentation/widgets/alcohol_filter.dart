// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/generated/l10n.dart';
import 'package:delivery/src/features/filter/presentation/filter_drawer.dart';
import 'package:delivery/src/features/filter/presentation/providers/providers.dart';
import 'package:delivery/src/features/filter/presentation/viewmodels/filter_model.dart';
import 'package:delivery/src/features/filter/utils/filters_formatting_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlcoholFilter extends HookWidget {
  const AlcoholFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filterType = useProvider(filterTypeScopedProvider);

    final alcoholRange = useProvider(filterModelProvider(filterType)
        .select((value) => value.state.alcoholRange));
    final isAlcoholActive = useProvider(filterModelProvider(filterType)
        .select((value) => value.state.isAlcoholActive));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).alcohol),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                color: isAlcoholActive
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                FilterFormattingUtils.getAlcoholRangeString(alcoholRange),
                textAlign: TextAlign.right,
              ),
            )
          ],
        ),
        RangeSlider(
          activeColor: Theme.of(context).colorScheme.secondary,
          min: FilterConstants.minAlcohol.toDouble(),
          max: FilterConstants.maxAlcohol.toDouble(),
          divisions: FilterConstants.alcoholDivisions,
          values: alcoholRange,
          onChanged: (value) {
            context.read(filterModelProvider(filterType)).state =
                context.read(filterModelProvider(filterType)).state.copyWith(
                      alcoholRange: value,
                    );
          },
          labels: RangeLabels(
            '${alcoholRange.start.round()}%',
            '${alcoholRange.end.round()}%',
          ),
        ),
      ],
    );
  }
}
