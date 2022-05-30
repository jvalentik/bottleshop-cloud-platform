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

import 'package:delivery/src/core/presentation/widgets/bottom_navigation_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class MaterialBottomNavigationScaffold extends HookConsumerWidget {
  const MaterialBottomNavigationScaffold({
    required this.navigationBarItems,
    Key? key,
  }) : super(key: key);

  final List<BottomNavigationTab> navigationBarItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = useMemoized(() => GlobalKey());

    final currentId = useState(0).value;

    return Scaffold(
      key: scaffoldKey,
      body: IndexedStack(index: currentId, children: const []),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedFontSize: 14,
          unselectedFontSize: 11,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.grey,
          iconSize: 24,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: currentId,
          items: navigationBarItems.map((item) => item.bottomNavigationBarItem).toList(),
          onTap: (id) {
            //TODO:
            logWarning('OnTap is captured but not handle');
          }),
    );
  }
}
