import 'package:bottleshop_admin/src/features/backdrop/presentation/widgets/backdrop.dart';
import 'package:flutter/material.dart';

/// Implements the back layer to be used for navigation.
///
/// This class can be used as a back layer for [BackdropScaffold]. It enables to
/// use the back layer as a navigation list, similar to a [Drawer].
///
/// Usage example:
/// ```dart
/// int _currentIndex = 0;
/// final List<Widget> _pages = [Widget1(), Widget2()];
///
/// @override
/// Widget build(BuildContext context) {
///   return MaterialApp(
///     title: 'Backdrop Demo',
///     home: BackdropScaffold(
///       appBar: BackdropAppBar(
///         title: Text('Navigation Example'),
///         actions: <Widget>[
///           BackdropToggleButton(
///             icon: AnimatedIcons.list_view,
///           )
///         ],
///       ),
///       stickyFrontLayer: true,
///       frontLayer: _pages[_currentIndex],
///       backLayer: BackdropNavigationBackLayer(
///         items: [
///           ListTile(title: Text('Widget 1')),
///           ListTile(title: Text('Widget 2')),
///         ],
///         onTap: (int position) => {setState(() => _currentIndex = position)},
///       ),
///     ),
///   );
/// }
/// ```
class BackdropNavigationBackLayer extends StatelessWidget {
  /// The items to be inserted into the underlying [ListView] of the
  /// [BackdropNavigationBackLayer].
  final List<Widget> items;

  /// Callback that is called whenever a list item is tapped by the user.
  final ValueChanged<int>? onTap;

  /// Customizable separator used with [ListView.separated].
  final Widget? separator;

  /// Creates an instance of [BackdropNavigationBackLayer] to be used with
  /// [BackdropScaffold].
  ///
  /// The argument [items] is required and must not be `null` and not empty.
  BackdropNavigationBackLayer({
    Key? key,
    required this.items,
    this.onTap,
    this.separator,
  })  : assert(items.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) => ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, position) => InkWell(
          child: items[position],
          onTap: () {
            // fling backdrop
            Backdrop.of(context).fling();

            // call onTap function and pass new selected index
            onTap?.call(position);
          },
        ),
        separatorBuilder: (builder, position) => separator ?? Container(),
      );
}
