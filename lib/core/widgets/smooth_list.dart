import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';

/// Extra scroll offset to be added while the scroll is happened
/// Default value is 2.5
const double defaultScrollOffset = 2.5;

/// Duration/length for how long the animation should go
/// after the scroll has happened
/// Default value is 1500ms
const int defaultAnimationDuration = 1500;

class SmoothList extends StatefulWidget {
  /// Scroll Controller for controlling the scroll behavior manually
  /// so we can animate to next scrolled position and avoid the jerky movement
  /// of default scroll
  final ScrollController controller;

  /// Child scrollable widget.
  final Widget child;

  /// Scroll speed for adjusting the smoothness and add a bit of extra scroll
  /// Default value is 2.5
  /// You can try it for a range of 2 - 5
  final double scrollSpeed;

  /// Duration/length for how long the animation should go
  /// after the scroll has happened
  /// Default value is 1500ms
  final int scrollAnimationLength;

  /// Curve of the animation.
  final Curve curve;

  /// Trackpad scroll sensitivity multiplier
  /// Default value is 0.8 (reduces trackpad sensitivity)
  final double trackpadSensitivity;

  const SmoothList({
    super.key,
    required this.controller,
    required this.child,
    this.scrollSpeed = defaultScrollOffset,
    this.scrollAnimationLength = defaultAnimationDuration,
    this.curve = Curves.easeOutCubic,
    this.trackpadSensitivity = 0.8,
  });

  @override
  State<SmoothList> createState() => _SmoothListState();
}

class _SmoothListState extends State<SmoothList> with TickerProviderStateMixin {
  // Data variables
  double _scroll = 0;
  bool _isAnimating = false;
  double _targetScroll = 0;
  DateTime _lastScrollTime = DateTime.now();

  // Trackpad specific variables
  Timer? _trackpadDebounceTimer;
  double _accumulatedTrackpadDelta = 0;
  DateTime _lastTrackpadEvent = DateTime.now();
  bool _isTrackpadScrolling = false;
  static const int _trackpadDebounceMs = 16; // ~60fps
  static const int _trackpadEndDelayMs = 100;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(scrollListener);
    _targetScroll = widget.controller.initialScrollOffset;
  }

  @override
  void didUpdateWidget(covariant SmoothList oldWidget) {
    if (!widget.controller.hasClients) {
      widget.controller.addListener(scrollListener);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _trackpadDebounceTimer?.cancel();
    widget.controller.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Listener(onPointerSignal: onPointerSignal, child: widget.child),
    );
  }

  /// Smooth scroll function for mouse wheel
  void _smoothScrollTo(double delta) {
    final now = DateTime.now();
    final timeDiff = now.difference(_lastScrollTime).inMilliseconds;
    _lastScrollTime = now;

    // Update target scroll position
    _targetScroll += (delta * widget.scrollSpeed);

    // Bound the scroll value
    _targetScroll = _targetScroll.clamp(
      0.0,
      widget.controller.position.maxScrollExtent,
    );

    // Calculate animation duration based on time between scrolls
    int animationDuration =
        timeDiff < 50
            ? widget.scrollAnimationLength ~/ 4
            : widget.scrollAnimationLength;

    // If at bounds, use shorter animation
    if (_targetScroll == widget.controller.position.maxScrollExtent ||
        _targetScroll == 0) {
      animationDuration = widget.scrollAnimationLength ~/ 4;
    }

    // Start animation to target
    widget.controller
        .animateTo(
          _targetScroll,
          duration: Duration(milliseconds: animationDuration),
          curve: widget.curve,
        )
        .then((_) {
          if (mounted) setState(() => _isAnimating = false);
        });

    setState(() => _isAnimating = true);
  }

  /// Handle trackpad scrolling with debouncing and accumulation
  void _handleTrackpadScroll(double delta) {
    final now = DateTime.now();
    _lastTrackpadEvent = now;
    _isTrackpadScrolling = true;

    // Accumulate delta for smoother scrolling
    _accumulatedTrackpadDelta += delta * widget.trackpadSensitivity;

    // Cancel existing timer
    _trackpadDebounceTimer?.cancel();

    // Set up debounced scroll execution
    _trackpadDebounceTimer = Timer(
      const Duration(milliseconds: _trackpadDebounceMs),
      () {
        if (!mounted) return;

        // Apply accumulated scroll
        final currentOffset = widget.controller.offset;
        final newOffset = (currentOffset + _accumulatedTrackpadDelta).clamp(
          0.0,
          widget.controller.position.maxScrollExtent,
        );

        // Use a very short animation for smoother trackpad feel
        widget.controller.animateTo(
          newOffset,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutQuart,
        );

        // Update target scroll
        _targetScroll = newOffset;

        // Reset accumulated delta
        _accumulatedTrackpadDelta = 0;

        // Set timer to detect end of trackpad scrolling
        Timer(const Duration(milliseconds: _trackpadEndDelayMs), () {
          if (mounted &&
              DateTime.now().difference(_lastTrackpadEvent).inMilliseconds >
                  _trackpadEndDelayMs) {
            _isTrackpadScrolling = false;
          }
        });
      },
    );
  }

  void scrollListener() {
    _scroll = widget.controller.offset;
    // Update target scroll when user manually scrolls (but not during trackpad)
    if (!_isAnimating && !_isTrackpadScrolling) {
      _targetScroll = _scroll;
    }
  }

  void onPointerSignal(PointerSignalEvent pointerSignal) {
    if (pointerSignal is PointerScrollEvent) {
      // Prevent default scroll behavior

      if (pointerSignal.kind == PointerDeviceKind.trackpad) {
        // Handle trackpad with debouncing and accumulation
        _handleTrackpadScroll(pointerSignal.scrollDelta.dy);
      } else {
        // Handle mouse wheel with smooth scrolling
        _smoothScrollTo(pointerSignal.scrollDelta.dy);
      }
    }
  }
}
