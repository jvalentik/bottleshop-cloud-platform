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

import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/loader_widget.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/help/presentation/providers/help_providers.dart';
import 'package:delivery/src/features/help/presentation/widgets/help_section.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/home_page_template.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:routeborn/routeborn.dart';

class HelpPage extends RoutebornPage {
  static const String pagePathBase = 'help';

  HelpPage()
      : super.builder(
          pagePathBase,
          (_) => _HelpPageView(),
        );

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.help);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _HelpPageView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final scrollCtrl = useScrollController();

    if (shouldUseMobileLayout(context)) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.help),
          leading: CloseButton(
            color: kPrimaryColor,
            onPressed: () => ref.read(navigationProvider).setNestingBranch(
                  context,
                  RoutebornBranchParams.of(context).getBranchParam()
                          as NestingBranch? ??
                      NestingBranch.shop,
                ),
          ),
        ),
        body: CupertinoScrollbar(
          controller: scrollCtrl,
          child: _Body(
            scrollCtrl: scrollCtrl,
          ),
        ),
      );
    } else {
      return HomePageTemplate(
        scaffoldKey: scaffoldKey,
        body: Scrollbar(
          controller: scrollCtrl,
          child: PageBodyTemplate(
            child: _Body(
              scrollCtrl: scrollCtrl,
            ),
          ),
        ),
      );
    }
  }
}

class _Body extends HookConsumerWidget {
  final ScrollController scrollCtrl;

  const _Body({Key? key, required this.scrollCtrl}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      controller: scrollCtrl,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ref.watch(mdContentProvider).when(
            data: (mds) {
              return Column(
                children: <Widget>[
                  HelpSection(
                    icon: Icons.help,
                    title: context.l10n.faq,
                    subTitle: context.l10n.someAnswers,
                    mdString: mds.item1,
                  ),
                  HelpSection(
                    icon: Icons.attractions,
                    title: context.l10n.contactDetails,
                    subTitle: context.l10n.contactInformation,
                    mdString: mds.item2,
                  ),
                ],
              );
            },
            loading: () => const Loader(),
            error: (_, __) {
              return const Text('');
            },
          ),
    );
  }
}
