import 'package:bottleshop_admin/src/features/backdrop/presentation/widgets/backdrop.dart';
import 'package:flutter/material.dart';

/// An animated button that can be used to trigger the backdrop functionality of
/// [BackdropScaffold].
///
/// This button is implicitly used within [BackdropAppBar].
/// This button can also be passed to the [BackdropAppBar.actions].
///
/// When being pressed, [BackdropToggleButton] looks for a [Backdrop] instance
/// above it in the widget tree and toggles its opening/closing.
///
/// Example:
/// ```dart
/// Widget build(BuildContext context) {
///   return MaterialApp(
///     title: 'Backdrop Demo',
///     home: BackdropScaffold(
///       ...
///       actions: <Widget>[
///         BackdropToggleButton(
///           icon: AnimatedIcons.list_view,
///         ),
///       ],
///     ),
///   );
/// }
/// ```
class BackdropToggleButton extends StatelessWidget {
  /// Animated icon that is used for the contained [AnimatedIcon].
  ///
  /// Defaults to [AnimatedIcons.close_menu].
  final AnimatedIconData icon;

  /// Creates an instance of [BackdropToggleButton].
  const BackdropToggleButton({
    Key? key,
    this.icon = AnimatedIcons.close_menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        icon: AnimatedIcon(
          icon: icon,
          progress: Backdrop.of(context).controller!.view,
        ),
        onPressed: () => Backdrop.of(context).fling(),
      );
}
