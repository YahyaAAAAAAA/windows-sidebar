import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/packages/context_menu/context_menu_builder.dart';
import 'package:windows_widgets/core/utils/constants.dart';

const double _kMinTileHeight = 24;

class ContextMenu extends StatefulWidget {
  final Offset position;

  final ContextMenuBuilder builder;

  final double verticalPadding;

  final double width;

  final Color? color;

  final double? borderRadius;

  final double? elevation;

  const ContextMenu({
    super.key,
    required this.position,
    required this.builder,
    this.verticalPadding = 8,
    this.width = 320,
    this.color,
    this.borderRadius,
    this.elevation = 8,
  });

  @override
  State<ContextMenu> createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  final Map<ValueKey, double> _heights = {};

  @override
  Widget build(BuildContext context) {
    final children = widget.builder(context);

    double height = 2 * widget.verticalPadding;

    for (var element in _heights.values) {
      height += element;
    }

    final heightsNotAvailable = children.length - _heights.length;
    height += heightsNotAvailable * _kMinTileHeight;

    if (height > MediaQuery.of(context).size.height) {
      height = MediaQuery.of(context).size.height;
    }

    double paddingLeft = widget.position.dx;
    double paddingTop = widget.position.dy;
    double paddingRight =
        MediaQuery.of(context).size.width - widget.position.dx - widget.width;
    if (paddingRight < 0) {
      paddingLeft += paddingRight;
      paddingRight = 0;
    }
    double paddingBottom =
        MediaQuery.of(context).size.height - widget.position.dy - height;
    if (paddingBottom < 0) {
      paddingTop += paddingBottom;
      paddingBottom = 0;
    }
    return AnimatedPadding(
      padding: EdgeInsets.fromLTRB(
        paddingLeft,
        paddingTop,
        paddingRight,
        paddingBottom,
      ),
      duration: _kShortDuration,
      child: SizedBox.shrink(
        child: Card(
          color: widget.color ?? context.theme.cardColor,
          elevation: widget.elevation,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? kBorderRadius.outer,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? kBorderRadius.outer,
            ),
            child: Material(
              color: Colors.transparent,
              elevation: 0,
              child: ListView(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
                children:
                    children
                        .map(
                          (e) => _GrowingWidget(
                            child: e,
                            onHeightChange: (height) {
                              setState(() {
                                _heights[ValueKey(e)] = height;
                              });
                            },
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const _kShortDuration = Duration(milliseconds: 75);

class _GrowingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<double> onHeightChange;

  const _GrowingWidget({required this.child, required this.onHeightChange});

  @override
  __GrowingWidgetState createState() => __GrowingWidgetState();
}

class __GrowingWidgetState extends State<_GrowingWidget> with AfterLayoutMixin {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(key: _key, child: widget.child);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final newHeight = _key.currentContext!.size!.height;
    widget.onHeightChange.call(newHeight);
  }
}
