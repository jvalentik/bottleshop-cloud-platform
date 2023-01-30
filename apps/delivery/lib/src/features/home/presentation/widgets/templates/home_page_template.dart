import 'package:delivery/src/features/home/presentation/widgets/landing/header.dart';
import 'package:delivery/src/features/home/presentation/widgets/molecules/breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePageTemplate extends HookConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget body;
  final Widget? filterBtn;

  const HomePageTemplate({
    Key? key,
    required this.scaffoldKey,
    required this.body,
    this.filterBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        key: scaffoldKey,
        body: Column(children: [
          ResponsiveWrapper(
            maxWidth: 1920,
            minWidth: 50,
            defaultScale: true,
            breakpoints: const [
              ResponsiveBreakpoint.autoScaleDown(
                50,
                name: MOBILE,
              ),
              ResponsiveBreakpoint.autoScaleDown(600,
                  name: MOBILE, scaleFactor: 0.63),
              ResponsiveBreakpoint.autoScaleDown(900,
                  name: TABLET, scaleFactor: 0.63),
              ResponsiveBreakpoint.autoScale(1440, name: DESKTOP),
            ],
            child: ResponsiveConstraints(
              child: Header(
                scaffoldKey: scaffoldKey,
                filterBtn: filterBtn,
              ),
            ),
          ),
          const Breadcrumbs(),
          Expanded(
            child: ClipRect(
              child: OverlaySupport.local(child: body),
            ),
          ),
        ]));
  }
}
