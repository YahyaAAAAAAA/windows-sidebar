import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/packages/spring_curve/spring_curve.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_fitted_box.dart';

enum AppSwitchState { on, off, onSide, offSide }

class AppSwitch extends StatefulWidget {
  final bool value;
  final void Function(bool)? onChanged;
  final Size? size;
  final Size? thumbSize;
  final Duration? duration;
  final Color? thumbActiveColor;
  final Color? thumbInactiveColor;
  final BorderRadiusGeometry? thumbBorderRadius;
  final Color? trackOutlineActiveColor;
  final Color? trackOutlineInactiveColor;
  final double trackBorderWidth;
  final BorderRadiusGeometry? trackBorderRadius;
  final Color? trackActiveColor;
  final Color? trackInactiveColor;
  final double elevation;
  final IconData? icon;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.size,
    this.thumbSize,
    this.duration,
    this.thumbActiveColor,
    this.thumbInactiveColor,
    this.thumbBorderRadius,
    this.trackOutlineActiveColor,
    this.trackOutlineInactiveColor,
    this.trackBorderWidth = 0.5,
    this.trackBorderRadius,
    this.trackActiveColor,
    this.trackInactiveColor,
    this.elevation = 0,
    this.icon,
  });

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  late Size size;
  late Size thumbSize;
  late Duration duration;
  late Color thumbActiveColor;
  late Color thumbInactiveColor;
  late Color trackOutlineActiveColor;
  late Color trackOutlineInactiveColor;
  late Color trackActiveColor;
  late Color trackInactiveColor;

  //private
  double left = 0;
  double center = 0;
  double upperLimit = 0;
  bool isDragging = false;
  bool isHovered = false;
  Color thumbColor = Colors.black;
  Color trackOutlineColor = Colors.black;
  Color trackColor = Colors.black;

  AppSwitchState state = AppSwitchState.off;
  AppSwitchState stateOnDrag = AppSwitchState.off;

  @override
  void initState() {
    super.initState();
    size = widget.size ?? const Size(40, 20);
    thumbSize = widget.thumbSize ?? const Size(12, 12);
    duration = widget.duration ?? 1.seconds;
    upperLimit = size.width - thumbSize.width - (kPadding.small * 2.5); //2 for padding edges, 0.5 for scale
    center = upperLimit / 2;

    //init left position based on widget.value
    onTapUpdate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //thumb
    thumbActiveColor =
        widget.thumbActiveColor ?? context.theme.switchTheme.thumbColor?.resolve({}) ?? context.theme.cardColor;
    thumbInactiveColor =
        widget.thumbInactiveColor ??
        context.theme.switchTheme.thumbColor?.resolve({WidgetState.disabled}) ??
        context.theme.disabledColor;

    //border
    trackOutlineActiveColor =
        widget.trackOutlineActiveColor ??
        context.theme.switchTheme.trackOutlineColor?.resolve({}) ??
        context.theme.primaryColor;
    trackOutlineInactiveColor =
        widget.trackOutlineInactiveColor ??
        context.theme.switchTheme.trackOutlineColor?.resolve({WidgetState.disabled}) ??
        context.theme.disabledColor;

    //background
    trackActiveColor =
        widget.trackActiveColor ?? context.theme.switchTheme.trackColor?.resolve({}) ?? context.theme.primaryColor;
    trackInactiveColor =
        widget.trackInactiveColor ??
        context.theme.switchTheme.trackColor?.resolve({WidgetState.disabled}) ??
        Colors.transparent;

    //init colors
    thumbColor = widget.value ? thumbActiveColor : thumbInactiveColor;
    trackOutlineColor = widget.value ? trackOutlineActiveColor : trackOutlineInactiveColor;
    trackColor = widget.value ? trackActiveColor : trackInactiveColor;
  }

  @override
  void didUpdateWidget(AppSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update position when external value changes
    if (oldWidget.value != widget.value && !isDragging) {
      onTapUpdate();
    }
  }

  AppSwitchState updateState() {
    if (left == 0) {
      return state = AppSwitchState.off;
    } else if (left == center) {
      return state = AppSwitchState.on;
    } else if (left < center) {
      return state = AppSwitchState.offSide;
    } else {
      return state = AppSwitchState.onSide;
    }
  }

  //sets initial position and onChanged position
  void onTapUpdate() => setState(() {
    left = widget.value ? upperLimit : 0;
    updateState();
  });

  void onTap() => widget.onChanged?.call(!widget.value);

  void onDragUpdate(DragUpdateDetails details) {
    setState(() => left = (left + details.delta.dx).clamp(0, upperLimit));
  }

  void onDragEnd(DragEndDetails details) => setState(() {
    isDragging = false;
    updateState();

    switch (state) {
      //left side
      case AppSwitchState.off || AppSwitchState.offSide:
        //still on left -> push it back
        if (stateOnDrag == AppSwitchState.offSide) {
          left = 0;
        }
        //not left and can change -> push it forward
        else if (widget.value) {
          left = upperLimit;
          onTap();
        }
        //not left but can't change -> push it back
        else {
          left = 0;
        }
        break;
      default:
        //right side
        if (stateOnDrag == AppSwitchState.onSide) {
          left = upperLimit;
        }
        //not right but can't change -> push it back
        else if (widget.value) {
          left = upperLimit;
        }
        //not right and can change -> push it forward
        else {
          left = 0;
          onTap();
        }

        break;
    }
  });

  void onDragStart(DragStartDetails details) => setState(() {
    isDragging = true;
    stateOnDrag = updateState(); //save state for drag end
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton.leaf(
      child: MouseRegion(
        onEnter: (event) => setState(() => isHovered = true),
        onExit: (event) => setState(() => isHovered = false),
        child: GestureDetector(
          onPanStart: onDragStart,
          onPanEnd: onDragEnd,
          onPanUpdate: onDragUpdate,
          child: AppContainer(
            width: size.width,
            height: size.height,
            onTap: widget.onChanged != null ? onTap : null,
            elevation: widget.elevation,
            color: getFillColor(),
            borderRadius: widget.trackBorderRadius ?? BorderRadius.circular(kBorderRadius.circle),
            borderColor: getTrackColor(),
            borderWidth: widget.trackBorderWidth,
            padding: kPadding.small.pHori.add(1.pLeft),
            isAnimated: true,
            duration: kDuration.medium,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedPositioned(
                  duration: isDragging ? Duration.zero : duration,
                  curve: ElegantSpring.windows,
                  left: left,
                  child: AnimatedScale(
                    duration: 150.milliseconds,
                    curve: Curves.easeInOut,
                    scale: isHovered ? 1.1 : 1,
                    child: Transform.scale(
                      scaleX: isDragging ? 1.2 : 1,
                      child: AppContainer(
                        width: thumbSize.width,
                        height: thumbSize.height,
                        isAnimated: true,
                        duration: kDuration.medium,
                        borderWidth: 0,
                        color: getThumbColor(),
                        borderRadius: widget.thumbBorderRadius ?? BorderRadius.circular(kBorderRadius.circle),
                        child: AppFittedBox(child: Icon(widget.icon)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color getThumbColor() {
    if (isDragging) {
      return thumbColor;
    }
    return thumbColor = widget.value ? thumbActiveColor : thumbInactiveColor;
  }

  Color getTrackColor() {
    if (isDragging) {
      return trackOutlineColor;
    }
    return trackOutlineColor = widget.value ? trackOutlineActiveColor : trackOutlineInactiveColor;
  }

  Color getFillColor() {
    if (isDragging) {
      return trackColor;
    }
    return trackColor = widget.value ? trackActiveColor : trackInactiveColor;
  }
}
