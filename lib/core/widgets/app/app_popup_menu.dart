import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';

class AppPopupMenu<T> extends StatefulWidget {
  final Widget child;
  final List<AppPopupMenuItem<T>> items;
  final T? value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final double elevation;
  final double buttonElevation;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? hoverColor;
  final Radius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? buttonPadding;
  final EdgeInsets? itemPadding;
  final double? width;
  final double? menuWidth;
  final double? menuHeight;
  final double? height;
  final double? itemHeight;
  final bool enabled;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;
  final bool showSelectedIndicator;
  final bool sortSelectedFirst;

  const AppPopupMenu({
    super.key,
    required this.child,
    required this.items,
    this.value,
    this.groupValue,
    this.onChanged,
    this.elevation = 8.0,
    this.buttonElevation = 0,
    this.backgroundColor,
    this.selectedColor,
    this.hoverColor,
    this.borderRadius,
    this.padding,
    this.buttonPadding,
    this.itemPadding,
    this.width,
    this.menuWidth,
    this.menuHeight,
    this.height,
    this.itemHeight,
    this.enabled = true,
    this.onOpened,
    this.onClosed,
    this.showSelectedIndicator = true,
    this.sortSelectedFirst = true,
  });

  @override
  State<AppPopupMenu<T>> createState() => _AppPopupMenuState<T>();
}

class _AppPopupMenuState<T> extends State<AppPopupMenu<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightAnimation;
  late final Animation<double> _fadeAnimation;
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _heightAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _closeMenu();
    _controller.dispose();
    super.dispose();
  }

  void _openMenu() {
    if (!widget.enabled || _isOpen) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => _AppPopupMenuOverlay<T>(
            position: position,
            buttonSize: renderBox.size,
            items: _getSortedItems(),
            heightAnimation: _heightAnimation,
            fadeAnimation: _fadeAnimation,
            elevation: widget.elevation,
            backgroundColor: _getBackgroundColor(context),
            selectedColor: _getSelectedColor(context),
            hoverColor: _getHoverColor(context),
            borderRadius: _getBorderRadius(),
            padding: _getPadding(),
            itemPadding: _getItemPadding(),
            width: widget.width,
            menuWidth: widget.menuWidth,
            menuHeight: widget.menuHeight,
            itemHeight: widget.itemHeight,
            groupValue: widget.groupValue,
            showSelectedIndicator: widget.showSelectedIndicator,
            onItemSelected: _onItemSelected,
            onDismiss: _closeMenu,
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
    _isOpen = true;
    widget.onOpened?.call();
  }

  void _closeMenu() {
    if (!_isOpen) return;

    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isOpen = false;
      widget.onClosed?.call();
    });
  }

  void _onItemSelected(AppPopupMenuItem<T> item) {
    _closeMenu();
    if (item.enabled && widget.onChanged != null) {
      widget.onChanged!(item.value);
    }
    item.onSelected?.call();
  }

  List<AppPopupMenuItem<T>> _getSortedItems() {
    if (!widget.sortSelectedFirst) {
      return widget.items;
    }

    final selected = <AppPopupMenuItem<T>>[];
    final unselected = <AppPopupMenuItem<T>>[];

    for (final item in widget.items) {
      final isSelected = item.value == widget.groupValue;
      if (isSelected) {
        selected.add(item);
      } else {
        unselected.add(item);
      }
    }

    return [...selected, ...unselected];
  }

  Color _getBackgroundColor(BuildContext context) {
    return widget.backgroundColor ?? context.theme.cardColor;
  }

  Color _getSelectedColor(BuildContext context) {
    return widget.selectedColor ??
        context.theme.disabledColor.withValues(alpha: 0.1);
  }

  Color _getHoverColor(BuildContext context) {
    return widget.hoverColor ?? context.theme.hoverColor;
  }

  Radius _getBorderRadius() {
    return widget.borderRadius ?? Radius.circular(kBorderRadius.outer);
  }

  EdgeInsets _getPadding() {
    return widget.padding ?? const EdgeInsets.symmetric(vertical: 4.0);
  }

  EdgeInsets _getItemPadding() {
    return widget.itemPadding ?? kPadding.small.pAll;
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      onTap: widget.enabled ? _openMenu : null,
      width: widget.width,
      height: widget.height,
      padding: widget.buttonPadding,
      elevation: widget.buttonElevation,
      color:
          widget.enabled
              ? context.theme.iconButtonTheme.style?.backgroundColor?.resolve(
                    {},
                  ) ??
                  context.theme.cardColor
              : context.theme.indicatorColor,
      child: Stack(
        children: [
          widget.child,
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.expand_more,
              size: kIconSize.small,
              color:
                  widget.enabled
                      ? context.theme.disabledColor
                      : context.theme.disabledColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppPopupMenuOverlay<T> extends StatelessWidget {
  final Offset position;
  final Size buttonSize;
  final List<AppPopupMenuItem<T>> items;
  final Animation<double> heightAnimation;
  final Animation<double> fadeAnimation;
  final double elevation;
  final Color backgroundColor;
  final Color selectedColor;
  final Color hoverColor;
  final Radius borderRadius;
  final EdgeInsets padding;
  final EdgeInsets itemPadding;
  final double? width;
  final double? menuWidth;
  final double? menuHeight;
  final double? itemHeight;
  final T? groupValue;
  final bool showSelectedIndicator;
  final Function(AppPopupMenuItem<T>) onItemSelected;
  final VoidCallback onDismiss;

  const _AppPopupMenuOverlay({
    required this.position,
    required this.buttonSize,
    required this.items,
    required this.heightAnimation,
    required this.fadeAnimation,
    required this.elevation,
    required this.backgroundColor,
    required this.selectedColor,
    required this.hoverColor,
    required this.borderRadius,
    required this.padding,
    required this.itemPadding,
    required this.width,
    required this.menuWidth,
    required this.menuHeight,
    required this.itemHeight,
    required this.groupValue,
    required this.showSelectedIndicator,
    required this.onItemSelected,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.translucent,
      child: ClipRRect(
        child: ColoredBox(
          color: Colors.transparent,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: heightAnimation,
                builder: (context, child) {
                  return Positioned(
                    left:
                        menuWidth == null
                            ? position.dx
                            : position.dx - (menuWidth! - width!),
                    top: position.dy,
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: Material(
                        elevation: elevation,
                        borderRadius: BorderRadius.all(borderRadius),
                        color: backgroundColor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(borderRadius),
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: heightAnimation.value,
                            child: AppContainer(
                              width: menuWidth ?? width ?? buttonSize.width,
                              height: menuHeight,
                              padding: padding,
                              borderWidth: 0,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      items
                                          .map(
                                            (item) =>
                                                _AppPopupMenuItemWidget<T>(
                                                  item: item,
                                                  isSelected:
                                                      item.value == groupValue,
                                                  selectedColor: selectedColor,
                                                  hoverColor: hoverColor,
                                                  itemPadding: itemPadding,
                                                  itemHeight: itemHeight,
                                                  showSelectedIndicator:
                                                      showSelectedIndicator,
                                                  onSelected:
                                                      () =>
                                                          onItemSelected(item),
                                                ),
                                          )
                                          .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppPopupMenuItemWidget<T> extends StatefulWidget {
  final AppPopupMenuItem<T> item;
  final bool isSelected;
  final Color selectedColor;
  final Color hoverColor;
  final EdgeInsets itemPadding;
  final double? itemHeight;
  final bool showSelectedIndicator;
  final VoidCallback onSelected;

  const _AppPopupMenuItemWidget({
    required this.item,
    required this.isSelected,
    required this.selectedColor,
    required this.hoverColor,
    required this.itemPadding,
    this.itemHeight,
    required this.showSelectedIndicator,
    required this.onSelected,
  });

  @override
  State<_AppPopupMenuItemWidget<T>> createState() =>
      _AppPopupMenuItemWidgetState<T>();
}

class _AppPopupMenuItemWidgetState<T>
    extends State<_AppPopupMenuItemWidget<T>> {
  bool _isHovered = false;

  Color _getTextColor(BuildContext context) {
    if (!widget.item.enabled) {
      return context.theme.disabledColor;
    }

    // if (_isHovered) {
    //   return context.theme.primaryColor;
    // }

    return context.theme.colorScheme.onSurface;
  }

  Color _getIconColor(BuildContext context) {
    if (!widget.item.enabled) {
      return context.theme.disabledColor;
    }

    if (_isHovered) {
      return context.theme.primaryColor;
    }

    return context.iconColor;
  }

  Color? _getTileColor(BuildContext context) {
    if (!widget.item.enabled) {
      return null;
    }

    if (widget.isSelected && _isHovered) {
      return widget.hoverColor;
    }

    if (widget.isSelected) {
      return widget.selectedColor;
    }

    if (_isHovered) {
      return widget.hoverColor;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.itemPadding,
      child: MouseRegion(
        onEnter:
            widget.item.enabled
                ? (_) => setState(() => _isHovered = true)
                : null,
        onExit:
            widget.item.enabled
                ? (_) => setState(() => _isHovered = false)
                : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isSelected && widget.showSelectedIndicator)
              Align(
                alignment: Alignment.centerLeft,
                child: AppContainer(
                  width: kDashVert.width,
                  height: kDashVert.heightHovered,
                  color: context.primaryColor,
                  borderWidth: 0,
                ),
              ),
            ListTile(
              onTap: widget.item.enabled ? widget.onSelected : null,
              minTileHeight: widget.itemHeight ?? kContextMenu.height,
              hoverColor: widget.hoverColor,
              splashColor: context.theme.splashColor,
              tileColor: widget.item.color ?? _getTileColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kBorderRadius.outer),
              ),
              leading:
                  widget.item.leading ??
                  (widget.item.icon != null
                      ? Icon(
                        widget.item.icon,
                        color: _getIconColor(context),
                        size: kIconSize.tiny,
                      )
                      : null),
              title:
                  widget.item.title ??
                  BodyMediumText(
                    widget.item.text,
                      config:  AppTextConfiguration(
                    color: _getTextColor(context),
                      ),
                  ),
              trailing: widget.item.trailing,
            ),
          ],
        ),
      ),
    );
  }
}

class AppPopupMenuItem<T> {
  final String text;
  final T value;
  final Widget? title;
  final Widget? leading;
  final Widget? trailing;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onSelected;
  final bool enabled;

  const AppPopupMenuItem({
    required this.text,
    required this.value,
    this.title,
    this.leading,
    this.trailing,
    this.color,
    this.icon,
    this.onSelected,
    this.enabled = true,
  });
}
