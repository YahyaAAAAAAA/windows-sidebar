import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class WindowData with EquatableMixin {
  final Widget child;
  final IconData icon;
  final Alignment fitAlignment;
  final int id;
  final bool isFitted;
  final bool isAnimated;
  final VoidCallback? onClose;
  final VoidCallback? onMinimize;
  final String? title;
  final double? height;
  final double? width;
  final Offset? position;
  final FocusNode? focusNode;
  final bool isMinimized;
  final bool isDragging;

  WindowData({
    required this.id,
    required this.child,
    required this.icon,
    this.onClose,
    this.onMinimize,
    this.isMinimized = false,
    this.isDragging = false,
    this.focusNode,
    this.height,
    this.width,
    this.title = '',
    this.position = const Offset(20, 20),
    this.fitAlignment = Alignment.center,
    this.isAnimated = true,
    this.isFitted = false,
  });

  WindowData copyWith({
    Widget? child,
    IconData? icon,
    Alignment? fitAlignment,
    int? id,
    bool? isFitted,
    bool? isAnimated,
    VoidCallback? onClose,
    VoidCallback? onMinimize,
    String? title,
    double? height,
    double? width,
    bool? isOpen,
    bool? isMinimized,
    bool? isDragging,
    Offset? position,
    FocusNode? focusNode,
  }) {
    return WindowData(
      id: id ?? this.id,
      child: child ?? this.child,
      icon: icon ?? this.icon,
      fitAlignment: fitAlignment ?? this.fitAlignment,
      isFitted: isFitted ?? this.isFitted,
      isAnimated: isAnimated ?? this.isAnimated,
      onClose: onClose ?? this.onClose,
      onMinimize: onMinimize ?? this.onMinimize,
      title: title ?? this.title,
      height: height ?? this.height,
      width: width ?? this.width,
      isDragging: isDragging ?? this.isDragging,
      isMinimized: isMinimized ?? this.isMinimized,
      position: position ?? this.position,
      focusNode: focusNode ?? this.focusNode,
    );
  }

  @override
  List<Object?> get props => [
    id,
    child,
    icon,
    fitAlignment,
    isFitted,
    isAnimated,
    onClose,
    onMinimize,
    title,
    height,
    width,
    isDragging,
    isMinimized,
    position,
    focusNode,
  ];
}
