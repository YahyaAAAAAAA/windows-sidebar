import 'package:flutter/material.dart';

class AppListView extends StatelessWidget {
  final IndexedWidgetBuilder? itemBuilder;
  final List<Widget>? children;
  final int itemCount;
  final double spacing;
  final Axis axis;
  final bool shrinkWrap;
  final bool reverse;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppListView({
    super.key,
    this.children,
    this.itemBuilder,
    this.itemCount = 0,
    this.spacing = 0,
    this.axis = Axis.vertical,
    this.shrinkWrap = false,
    this.reverse = false,
    this.padding,
    this.margin,
    this.controller,
    this.physics,
  }) : assert((children != null) ^ (itemBuilder != null), 'Must provide either children or itemBuilder, not both');

  bool get isUsingChildren => children != null;
  int get actualItemCount => isUsingChildren ? children!.length : itemCount;

  Widget _buildSeparator() => axis == Axis.vertical ? SizedBox(height: spacing) : SizedBox(width: spacing);

  @override
  Widget build(BuildContext context) {
    if (actualItemCount == 0) return const SizedBox.shrink();

    if (spacing <= 0) {
      return isUsingChildren
          ? ListView(
              scrollDirection: axis,
              shrinkWrap: shrinkWrap,
              reverse: reverse,
              padding: padding,
              physics: physics,
              controller: controller,
              children: children!,
            )
          : ListView.builder(
              itemCount: itemCount,
              itemBuilder: itemBuilder!,
              scrollDirection: axis,
              shrinkWrap: shrinkWrap,
              reverse: reverse,
              padding: padding,
              physics: physics,
              controller: controller,
            );
    }

    return Container(
      margin: margin,
      child: ListView.separated(
        itemCount: actualItemCount,
        scrollDirection: axis,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
        padding: padding,
        physics: physics,
        controller: controller,
        separatorBuilder: (_, _) => _buildSeparator(),
        itemBuilder: isUsingChildren ? (_, i) => children![i] : itemBuilder!,
      ),
    );
  }
}
