import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/auth_providers.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/detail_text.dart';
import 'package:bottleshop_admin/src/features/login/presentation/pages/intro_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppNavigationDrawer extends HookWidget {
  const AppNavigationDrawer({
    super.key,
  });

  Future<PackageInfo> getVersion() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final subTextTheme = AppTheme.subtitle1TextStyle.copyWith(fontSize: 15);

    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${context.read(loggedUserProvider).state!.nick}',
                  style: AppTheme.headline1TextStyle.copyWith(fontSize: 20),
                ),
                Text(
                  context.read(loggedUserProvider).state!.email,
                  style: subTextTheme,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Vybavené objednávky prihláseným používateľom:',
                    style: subTextTheme,
                  ),
                ),
                DetailText(
                  theme: subTextTheme,
                  title: 'Dnes: ',
                  value: 'TODO',
                  valueTheme: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                DetailText(
                  theme: subTextTheme,
                  title: 'Tento týždeň: ',
                  value: 'TODO',
                  valueTheme: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                DetailText(
                  theme: subTextTheme,
                  title: 'Tento mesiac: ',
                  value: 'TODO',
                  valueTheme: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Odhlásiť sa'),
            onTap: () => context
                .read(authenticationServiceProvider)
                .signOut()
                .then(
                  (value) => context
                      .read(navigationProvider.notifier)
                      .replaceAllWith([IntroActivityPage()]),
                )
                .catchError(
                  (_) => print('TODO: something went wrong'),
                ),
          ),
          FutureBuilder(
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final data = snapshot.data as PackageInfo;
                  return Center(
                    child: Text(
                      'Version: ${data.version}',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'Error',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
            future: getVersion(),
          ),
        ],
      ),
    );
  }
}
