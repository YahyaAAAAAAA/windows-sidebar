import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/features/shared/domain/models/window_data.dart';
import 'package:windows_widgets/features/shared/domain/models/window_data_manager.dart';

@injectable
class WindowCubit extends Cubit<List<WindowData>> with LogLayerMixin {
  WindowCubit() : super([]) {
    init(WindowDataManager.initialWindows);
  }

  void init(List<WindowData> windows) {
    emit(windows);
    logInfo(init);
  }

  void updatePosition(WindowData? window, Offset newPosition) {
    if (window == null) {
      logWarning('Attempted to update position of a null window');
      return;
    }

    _updateWindow(
      window.id,
      (window) => window.position == newPosition ? window : window.copyWith(position: newPosition),
    );

    logInfo(updatePosition, [window.title, window.id]);
  }

  void bringToFront(WindowData? window) {
    if (window == null) {
      logWarning('Attempted to bring null window to front');
      return;
    }

    //quick check if already in front
    if (state.isNotEmpty && state.last.id == window.id) return;

    final index = _findWindowIndex(window.id);
    if (index == -1) {
      logWarning('Window ${window.id} not found for bringing to front');
      return;
    }

    //already in front
    if (index == state.length - 1) return;

    final newState = [...state];
    final movedWindow = newState.removeAt(index);
    newState.add(movedWindow);

    logInfo(bringToFront, [window.title, window.id]);
    emit(newState);
  }

  void restoreWindow(WindowData? window) {
    if (window == null) {
      logWarning('Attempted to restore null window');
      return;
    }

    _updateWindow(window.id, (window) => window.copyWith(isMinimized: !window.isMinimized));

    logInfo(restoreWindow, [window.title, window.id, 'isMinimized: ${!window.isMinimized}']);
  }

  void closeWindow(WindowData? window) {
    if (window == null) {
      logWarning('Attempted to close null window');
      return;
    }

    final index = _findWindowIndex(window.id);
    if (index == -1) {
      logWarning('Window ${window.id} not found for closing');
      return;
    }

    final newState = [...state];
    newState.removeAt(index);

    logInfo(closeWindow, [window.title, window.id]);
    emit(newState);
  }

  void createWindow(WindowData? window) {
    if (window == null) {
      logWarning('Attempted to create null window');
      return;
    }

    final index = _findWindowIndex(window.id);

    //already exists
    if (index != -1) {
      logWarning('Window ${window.id} already exists');
      return;
    }

    final newState = [...state];
    newState.add(window);

    logInfo(createWindow, [window.title, window.id]);
    emit(newState);
  }

  void toggleDrag(WindowData? window) {
    if (window == null) {
      logWarning('Attempted to toggle drag of null window');
      return;
    }

    _updateWindow(window.id, (window) => window.copyWith(isDragging: !window.isDragging));
  }

  //batch operations
  void updateMultipleWindows(Map<int, WindowData Function(WindowData)> updates) {
    if (updates.isEmpty) {
      logWarning('updateMultipleWindows called with empty updates');
      return;
    }

    final newState = [...state];
    bool hasChanges = false;
    final updatedWindowIds = <int>[];

    for (final entry in updates.entries) {
      final index = _findWindowIndex(entry.key);
      if (index != -1) {
        final oldWindow = newState[index];
        final updatedWindow = entry.value(oldWindow);

        if (oldWindow != updatedWindow) {
          newState[index] = updatedWindow;
          hasChanges = true;
          updatedWindowIds.add(entry.key);
        }
      } else {
        logWarning('Window ${entry.key} not found in batch update');
      }
    }

    if (hasChanges) {
      logInfo(updateMultipleWindows, [updatedWindowIds]);
      emit(newState);
    } else {
      logWarning('No changes in batch update');
    }
  }

  bool exists(WindowData? window) {
    if (window == null) return false;
    return _findWindowIndex(window.id) != -1;
  }

  bool existsById(int windowId) => _findWindowIndex(windowId) != -1;

  WindowData? getWindowById(int id) {
    final index = _findWindowIndex(id);
    return index != -1 ? state[index] : null;
  }

  List<WindowData> get windows => state;

  List<WindowData> get visibleWindows => state.where((w) => !w.isMinimized).toList();

  List<WindowData> get minimizedWindows => state.where((w) => w.isMinimized).toList();

  WindowData? get topWindow => state.isNotEmpty ? state.last : null;

  WindowData? get bottomWindow => state.isNotEmpty ? state.first : null;

  int get windowCount => state.length;

  int get visibleWindowCount => state.where((w) => !w.isMinimized).length;

  int get minimizedWindowCount => state.where((w) => w.isMinimized).length;

  //---private helper methods---

  int _findWindowIndex(int windowId) => state.indexWhere((window) => window.id == windowId);

  void _updateWindow(int windowId, WindowData Function(WindowData) updater) {
    final index = _findWindowIndex(windowId);
    if (index == -1) {
      logWarning('Window $windowId not found for update');
      return;
    }

    final currentWindow = state[index];
    final updatedWindow = updater(currentWindow);

    //no change
    if (currentWindow == updatedWindow) {
      logWarning('No change detected for window $windowId');
      return;
    }

    final newState = [...state];
    newState[index] = updatedWindow;

    emit(newState);
  }

  @override
  Future<void> close() {
    logInfo('Disposed');
    return super.close();
  }
}
