import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

//todo vertical borders can be better
class SmoothListView extends StatefulWidget {
  final int itemCount;
  final bool shrinkWrap;
  final Widget? Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final Axis scrollDirection;

  const SmoothListView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.separatorBuilder,
    required this.scrollDirection,
    this.shrinkWrap = false,
  });

  @override
  State<SmoothListView> createState() => _SmoothListViewState();
}

class _SmoothListViewState extends State<SmoothListView> {
  final ScrollController scrollController = ScrollController();
  bool showRightArrow = false;
  bool showLeftArrow = false;
  bool showUpArrow = false;
  bool showDownArrow = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(checkScroll);
  }

  void checkScroll() {
    if (widget.scrollDirection == Axis.horizontal) {
      setState(() {
        showRightArrow =
            scrollController.offset < scrollController.position.maxScrollExtent;
        showLeftArrow =
            scrollController.offset > scrollController.position.minScrollExtent;
      });
    }
    if (widget.scrollDirection == Axis.vertical) {
      setState(() {
        showUpArrow =
            scrollController.offset > scrollController.position.minScrollExtent;
        showDownArrow =
            scrollController.offset < scrollController.position.maxScrollExtent;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(checkScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Listener(
          onPointerSignal: (pointerSignal) {
            if (widget.scrollDirection == Axis.horizontal) {
              if (pointerSignal is PointerScrollEvent) {
                scrollController.animateTo(
                  scrollController.offset + pointerSignal.scrollDelta.dy,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            }
            if (widget.scrollDirection == Axis.vertical) {
              if (pointerSignal is PointerScrollEvent) {
                scrollController.animateTo(
                  scrollController.offset + pointerSignal.scrollDelta.dx,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            }
          },
          child: ScrollConfiguration(
            behavior: HorizontalScrollBehavior(),
            child: ListView.separated(
              shrinkWrap: widget.shrinkWrap,
              scrollDirection: widget.scrollDirection,
              controller: scrollController,
              itemCount: widget.itemCount,
              physics: BouncingScrollPhysics(),
              separatorBuilder: widget.separatorBuilder,
              itemBuilder: widget.itemBuilder,
            ),
          ),
        ),
        if (showRightArrow)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: GColors.windowColor.shade700,
              ),
            ),
          ),
        if (showLeftArrow)
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => scrollController.animateTo(
                scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: GColors.windowColor.shade700,
              ),
            ),
          ),
        if (showUpArrow)
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () => scrollController.animateTo(
                scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: GColors.windowColor.shade700,
              ),
            ),
          ),
        if (showDownArrow)
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () => scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: GColors.windowColor.shade700,
              ),
            ),
          ),
      ],
    );
  }
}

class HorizontalScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
