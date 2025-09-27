import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_fitted_box.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/features/shared/domain/models/window_data.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/window_cubit.dart';

class WindowWidget extends StatefulWidget {
  final WindowData data;
  final Function(int id)? onBringToFront;
  final Function(Offset newPosition)? onDragUpdated;
  final void Function(DragStartDetails)? onDragStarted;
  final void Function(DragEndDetails)? onDragEnd;

  const WindowWidget({
    super.key,
    required this.data,
    this.onBringToFront,
    this.onDragUpdated,
    this.onDragEnd,
    this.onDragStarted,
  });

  @override
  State<WindowWidget> createState() => _WindowWidgetState();
}

class _WindowWidgetState extends State<WindowWidget> {
  late ValueNotifier<Offset> _dragPosition;
  final GlobalKey _windowKey = GlobalKey();
  Size? _windowSize;

  @override
  void initState() {
    super.initState();
    _dragPosition = ValueNotifier(widget.data.position ?? const Offset(20, 20));
  }

  @override
  void dispose() {
    _dragPosition.dispose();
    super.dispose();
  }

  void _updateWindowSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox = _windowKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _windowSize = renderBox.size;
        });
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Use measured size if available, otherwise fallback to defaults
    Size windowSize;
    if (_windowSize != null) {
      windowSize = _windowSize!;
    } else {
      // Fallback sizes
      windowSize = widget.data.isMinimized
          ? Size(kItemButton.width, kItemButton.height)
          : Size(widget.data.width ?? 400.0, widget.data.height ?? 300.0);
    }

    Offset newPosition = _dragPosition.value + details.delta;

    //constrain the position within screen bounds
    newPosition = Offset(
      newPosition.dx.clamp(0.0, screenSize.width - windowSize.width),
      newPosition.dy.clamp(0.0, screenSize.height - windowSize.height),
    );

    _dragPosition.value = newPosition;
  }

  void _onPanEnd(DragEndDetails details) {
    widget.onDragUpdated?.call(_dragPosition.value);
    widget.onDragEnd?.call(details);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: _dragPosition,
      builder: (context, position, child) {
        return Positioned(
          top: position.dy,
          left: position.dx,
          child: GestureDetector(
            onTap: () => widget.onBringToFront?.call(widget.data.id),
            onSecondaryTap: () => widget.onBringToFront?.call(widget.data.id),
            onTapDown: (_) => widget.onBringToFront?.call(widget.data.id),
            child: SizedBox(
              key: _windowKey,
              child: widget.data.isMinimized ? buildMinimizedWidget(context, position) : buildWidget(context, position),
            ),
          ),
        );
      },
    );
  }

  Widget buildMinimizedWidget(BuildContext context, Offset position) {
    //update size after build
    _updateWindowSize();

    return GestureDetector(
      onPanUpdate: (details) => _onPanUpdate(details, context),
      onPanStart: widget.onDragStarted,
      onPanEnd: _onPanEnd,
      child: AppContainer(
        width: kItemButton.width,
        height: kItemButton.height,
        onTap: () => context.read<WindowCubit>().restoreWindow(widget.data),
        elevation: widget.data.isDragging ? kElevation.sharp : kElevation.soft,
        borderRadius: BorderRadius.circular(kBorderRadius.circle),
        child: Icon(widget.data.icon),
      ),
    );
  }

  Widget buildWidget(BuildContext context, Offset position) {
    // Update size after build
    _updateWindowSize();

    return AppFittedBox(
      enabled: widget.data.isFitted,
      alignment: widget.data.fitAlignment,
      child: AppContainer(
        color: context.theme.indicatorColor,
        isAnimated: widget.data.isAnimated,
        isCentred: true,
        elevation: widget.data.isDragging ? kElevation.sharp : kElevation.soft,
        width: widget.data.width,
        height: widget.data.height,
        child: Stack(
          children: [
            //draggable bar
            Positioned.fill(
              child: GestureDetector(
                onPanUpdate: (details) => _onPanUpdate(details, context),
                onPanStart: widget.onDragStarted,
                onPanEnd: _onPanEnd,
                child: const AppContainer(
                  color: Colors.transparent,
                  borderWidth: 0,
                  child: Row(children: [Text('')]),
                ),
              ),
            ),

            //top left widgets
            IgnorePointer(
              child: Padding(
                padding: kPadding.small.pAll,
                child: Row(
                  spacing: 1,
                  children: [
                    Icon(widget.data.icon, size: kIconSize.micro),
                    BodySmallText(widget.data.title ?? ''),
                  ],
                ),
              ),
            ),

            widget.data.child,
          ],
        ),
      ),
    );
  }
}
