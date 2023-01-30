import 'package:badges/badges.dart';
import 'package:delivery/src/core/data/res/app_theme.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/bottleshop_badge.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Menu extends HookConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationProvider);
    final hasUser =
        ref.watch(currentUserProvider.select((value) => value != null));
    final currentBranch = ref.watch(
        navigationProvider.select((value) => value.getNestingBranch(context)));
    return Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 35),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Menu",
                      style: GoogleFonts.publicSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Image.asset(
                          kXIcon,
                          width: 20,
                          fit: BoxFit.fitWidth,
                        )),
                  ]),
            ),
            ListTile(
              title: Text(
                context.l10n.homeButton.toUpperCase(),
                style: publicSansTextTheme.bodyText1,
              ),
              onTap: () {
                if (currentBranch == NestingBranch.landing) {
                  Scaffold.of(context).closeDrawer();
                } else {
                  navigation.setNestingBranch(context, NestingBranch.landing);
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: Text(
                "ESHOP",
                style: publicSansTextTheme.bodyText1,
              ),
              onTap: () {
                if (currentBranch == NestingBranch.shop) {
                  Scaffold.of(context).closeDrawer();
                } else {
                  navigation.setNestingBranch(context, NestingBranch.shop);
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: Text(
                context.l10n.categoriesButton,
                style: publicSansTextTheme.bodyText1,
              ),
              onTap: () {
                if (currentBranch == NestingBranch.categories) {
                  Scaffold.of(context).closeDrawer();
                } else {
                  navigation.setNestingBranch(
                      context, NestingBranch.categories);
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: ref.watch(activeOrdersCountProvider).maybeWhen(
                    data: (count) => Wrap(children: <Widget>[
                      BottleshopBadge(
                        alignment: Alignment.centerLeft,
                        showBadge: count > 0,
                        badgeText: count.toString(),
                        position: BadgePosition.topEnd(end: -15, top: -10),
                        child: Text(
                          context.l10n.ordersButton,
                          style: publicSansTextTheme.bodyText1,
                        ),
                      ),
                    ]),
                    orElse: () => Text(
                      context.l10n.ordersButton,
                      style: publicSansTextTheme.bodyText1,
                    ),
                  ),
              onTap: () {
                if (currentBranch == NestingBranch.orders) {
                  Scaffold.of(context).closeDrawer();
                } else {
                  navigation.setNestingBranch(context, NestingBranch.orders);
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: Text(
                context.l10n.saleButton,
                style: publicSansTextTheme.bodyText1,
              ),
              onTap: () {
                if (currentBranch == NestingBranch.sale) {
                  Scaffold.of(context).closeDrawer();
                } else {
                  navigation.setNestingBranch(context, NestingBranch.sale);
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: Text(
                context.l10n.contactButton,
                style: publicSansTextTheme.bodyText1,
              ),
              onTap: () {
                if (currentBranch == NestingBranch.help) {
                  Scaffold.of(context).closeDrawer();
                } else {
                  navigation.setNestingBranch(context, NestingBranch.help);
                  Navigator.pop(context);
                }
              },
            ),
            // TODO login button to be added later
            // ConstrainedBox(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Container(
            //       margin: EdgeInsets.symmetric(
            //         horizontal: 16,
            //       ),
            //       child: hasUser
            //           ? LandingPageButton(
            //               txt: context.l10n.logOut,
            //               nestingBranch: NestingBranch.account)
            //           : LandingPageButton(
            //               txt: context.l10n.logIn,
            //               nestingBranch: NestingBranch.account),
            //     ),
            //   ),
            //   constraints: BoxConstraints(
            //       maxHeight:
            //           max(60.0, MediaQuery.of(context).size.height - 420 - 16)),
            // ),
            // SizedBox(
            //   height: 16,
            // )
          ],
        ));
  }
}
