// ignore_for_file: unused_field, unused_element
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:windows_widgets/core/extensions/string_extensions.dart';

/* 
  For logging:
    1- if cubit with no data impl (business logic) -> use 'info' at the end mixed with 'warning' logs
    2- if cubit wit data impl (data layer calls) -> use 'info' at the start mixed with 'warning' logs, in data use 'success' at the end mixed with 'error' logs
    3- if cubit with data impl felt too much, remove logs from cubit
    4- if in a widget -> use 'info'

  Notes:
    - prefer to use LogLayerMixin for better tracing
    - prefer to pass method name in cubits 'info' calls
    - prefer to type out 'warning' logs in all layers
    - prefer to type out 'success' logs in all layers
    - don't over log
    - 'debug' logs should be removed as you develop
    - 'blue' -> info, 'yellow' -> warning, 'green' -> success, 'cyan' -> network, 'red' -> error
*/

/// Logs the caller class name (classes across the app should use this mixin)
mixin LogLayerMixin {
  Function get _log => _Log.logMixin;
  Function get _debug => _Log.debug;
  Function get _info => _Log.info;
  Function get _warning => _Log.warning;
  Function get _error => _Log.error;
  Function get _success => _Log.success;
  Function get _network => _Log.network;
  String get _type => runtimeType.toString().splitCamelCase();

  /// For development
  void logDebug(Object? message, [List<Object?>? params]) => kDebugMode ? _log(_debug, message, _type, params) : null;

  /// For normal logging, eg: Current username: Felix
  void logInfo(Object? message, [List<Object?>? params]) => kDebugMode ? _log(_info, message, _type, params) : null;

  /// For anything that requires attention but not critical, eg: API returned 404 on an image (placeholder is used)
  void logWarning(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_warning, message, _type, params) : null;

  /// For errors/failures, mostly used inside a 'catch' or by a Failure object
  void logError(Object? message, [List<Object?>? params]) => kDebugMode ? _log(_error, message, _type, params) : null;

  /// For anything that should be the output
  void logSuccess(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_success, message, _type, params) : null;

  /// For calls over the network
  void logNetwork(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_network, message, _type, params) : null;
}

/// Logs the level name, for static or non-injectable utility classes
mixin LogStaticMixin {
  static Function get _log => _Log.logMixin;
  static Function get _debug => _Log.debug;
  static Function get _info => _Log.info;
  static Function get _warning => _Log.warning;
  static Function get _error => _Log.error;
  static Function get _success => _Log.success;
  static Function get _network => _Log.network;

  /// For development
  static void logDebug(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_debug, message, 'DEBUG', params) : null;

  /// For normal logging, eg: Current username: Felix
  static void logInfo(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_info, message, 'INFO', params) : null;

  /// For anything that requires attention but not critical, eg: API returned 404 on an image (placeholder is used)
  static void logWarning(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_warning, message, 'WARN', params) : null;

  /// For errors/failures, mostly used inside a 'catch' or by a Failure object
  static void logError(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_error, message, 'ERROR', params) : null;

  /// For anything that should be the output
  static void logSuccess(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_success, message, 'SUCCESS', params) : null;

  /// For calls over the network
  static void logNetwork(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_network, message, 'NETWORK', params) : null;
}

/// Logs the level name, for non-static utility classes, or if you dont want to log the class name
mixin LogMixin {
  Function get _log => _Log.logMixin;
  Function get _debug => _Log.debug;
  Function get _info => _Log.info;
  Function get _warning => _Log.warning;
  Function get _error => _Log.error;
  Function get _success => _Log.success;
  Function get _network => _Log.network;

  /// For development
  void logDebug(Object? message, [List<Object?>? params]) => kDebugMode ? _log(_debug, message, 'DEBUG', params) : null;

  /// For normal logging, eg: Current username: Felix
  void logInfo(Object? message, [List<Object?>? params]) => kDebugMode ? _log(_info, message, 'INFO', params) : null;

  /// For anything that requires attention but not critical, eg: API returned 404 on an image (placeholder is used)
  void logWarning(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_warning, message, 'WARN', params) : null;

  /// For errors/failures, mostly used inside a 'catch' or by a Failure object
  void logError(Object? message, [List<Object?>? params]) => kDebugMode ? _log(_error, message, 'ERROR', params) : null;

  /// For anything that should be the output
  void logSuccess(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_success, message, 'SUCCESS', params) : null;

  /// For calls over the network
  void logNetwork(Object? message, [List<Object?>? params]) =>
      kDebugMode ? _log(_network, message, 'NETWORK', params) : null;
}

class _Log {
  static void debug(Object? message, String type) => _logBase(type, _LogLevel.debug, message, _LogLevel.debug.color);

  static void info(Object? message, String type) => _logBase(type, _LogLevel.info, message, _LogLevel.info.color);

  static void warning(Object? message, String type) =>
      _logBase(type, _LogLevel.warning, message, _LogLevel.warning.color);

  static void error(Object? message, String type) => _logBase(type, _LogLevel.error, message, _LogLevel.error.color);

  static void success(Object? message, String type) =>
      _logBase(type, _LogLevel.success, message, _LogLevel.success.color);

  static void network(Object? message, String type) =>
      _logBase(type, _LogLevel.network, message, _LogLevel.network.color);

  //used by the mixins to invoke the above methods (debug,info, ...)
  static void logMixin(
    void Function(Object?, String) logFunction,
    Object? message,
    String type, [
    List<Object?>? params,
  ]) {
    var newMessage = message;

    if (message is Function) {
      final methodName = _getMethodName(message.toString());
      final paramsText = (params != null && params.isNotEmpty) ? ', with $params' : '';
      newMessage = '$methodName called$paramsText';
    } else {
      final paramsText = (params != null && params.isNotEmpty) ? ', with $params' : '';
      newMessage = '$message$paramsText';
    }

    logFunction(newMessage, type);
  }

  //configuration methods

  /// Set minimum log level (logs below this level will be ignored)
  static void setMinLevel(_LogLevel level) => _minLevel = level;

  /// Enable or disable timestamps
  static void setTimeDisplay(bool enabled) => _showTime = enabled;

  /// Enable or disable milliseconds in timestamps
  static void setMillisecondsDisplay(bool enabled) => _showMilliseconds = enabled;

  /// Set maximum depth for object serialization
  static void setMaxObjectDepth(int depth) => _maxObjectDepth = depth.clamp(1, 10);

  /// Clear configuration and reset to defaults
  static void resetConfiguration() {
    _showTime = true;
    _minLevel = _LogLevel.debug;
    _showMilliseconds = false;
    _maxObjectDepth = 3;
  }

  //---private helper methods---

  //configuration options
  static bool _showTime = true;
  static _LogLevel _minLevel = _LogLevel.debug;
  static bool _showMilliseconds = false;
  static int _maxObjectDepth = 3;

  //text formatting
  static const _bold = '\x1B[0m'; //\x1B[1m (disabled temporarily to test fonts)
  static const _dim = '\x1B[2m';
  static const _italic = '\x1B[3m';
  static const _underline = '\x1B[4m';
  static const _blink = '\x1b[5m';
  static const _fastBlink = '\x1b[6m';
  static const _reset = '\x1B[0m';

  //standard colors
  static const _black = '\x1B[30m';
  static const _red = '\x1B[31m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _blue = '\x1B[34m';
  static const _magenta = '\x1B[35m';
  static const _cyan = '\x1B[36m';
  static const _white = '\x1B[37m';

  //background colors
  static const _bgBlack = '\x1B[40m';
  static const _bgRed = '\x1B[41m';
  static const _bgGreen = '\x1B[42m';
  static const _bgYellow = '\x1B[43m';
  static const _bgBlue = '\x1B[44m';
  static const _bgMagenta = '\x1B[45m';
  static const _bgCyan = '\x1B[46m';
  static const _bgWhite = '\x1B[47m';

  //log level hierarchy for filtering
  static const Map<_LogLevel, int> _levelPriority = {
    _LogLevel.debug: 0,
    _LogLevel.info: 1,
    _LogLevel.network: 1,
    _LogLevel.success: 2,
    _LogLevel.warning: 3,
    _LogLevel.error: 4,
  };

  static final _functionCache = <String, String>{};

  static DateTime lastLog = DateTime.now();
  static int separatorPeriod = 10;

  static void _logBase(String level, _LogLevel logLevel, Object? message, String color) {
    //if level should be displayed
    if ((_levelPriority[logLevel] ?? 0) < (_levelPriority[_minLevel] ?? 0)) {
      return;
    }

    //time
    final timeFormat = _showMilliseconds ? 'HH:mm:ss.SSS' : 'HH:mm:ss';
    final now = DateTime.now();
    final nowFormat = DateFormat(timeFormat).format(lastLog);
    final time = _showTime ? '$_yellow[$_reset $_bold$color$nowFormat$_reset $_yellow]$_reset ' : '';

    //layer
    final levelLine = ' $_bold$color${level.toUpperCase()}$_reset ';

    final formattedMessage = _stringify(message, color, logLevel.icon, _maxObjectDepth);

    final logLine = '$time${logLevel == _LogLevel.error ? _blink : ''}$formattedMessage'.trim();

    if (now.difference(lastLog).inSeconds >= separatorPeriod) {
      debugPrint(
        '$_bold$_black――――――――――――――――――――――――――――――――――――――――「 ✦ New Logs ✦ 」――――――――――――――――――――――――――――――――――――――――',
      );
    }

    lastLog = now;
    developer.log(logLine, name: levelLine);
  }

  static String _getMethodName(String method) {
    if (_functionCache.containsKey(method)) {
      return _functionCache[method]!;
    }

    String result = 'unknown';

    final patterns = [
      RegExp(r"from Function '(\w+)'"),
      RegExp(r"'(\w+)'"),
      RegExp(r"Closure: \(\) => \w+\.(\w+)"),
      RegExp(r"(\w+)\s*\("),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(method);
      if (match?.group(1) != null) {
        result = match!.group(1)!;
        break;
      }
    }

    _functionCache[method] = result;
    return result;
  }

  static String _stringify(Object? message, String color, String icon, int depth) {
    if (message == null) return 'null';

    //prevent infinite recursion
    if (depth > _maxObjectDepth) {
      return '$color[Object too deep]$_reset';
    }

    if ((message is Map || message is List || message is Set) && !_isFlatCollection(message)) {
      return _formatComplexObject(message, color, depth);
    }

    final messageStr = message.toString();
    return '$color$icon $messageStr$_reset';
  }

  static String _formatComplexObject(Object? message, String color, int depth) {
    const encoder = JsonEncoder.withIndent('  ');
    try {
      final jsonStr = encoder.convert(message);

      //apply color to each line while preserving structure
      final lines = jsonStr.split('\n');
      final coloredLines = lines
          .map((line) {
            if (line.trim().isEmpty) return line;
            return '$color$line$_reset';
          })
          .join('\n');

      return '\n$coloredLines';
    } catch (e) {
      final fallback = message.toString();
      return '$color$fallback$_reset';
    }
  }

  static bool _isFlatCollection(Object? data) {
    if (data == null) return true;

    if (data is Map) {
      if (data.isEmpty) return true;
      //check if all values are primitive types
      return data.values.every(_isPrimitive) && data.length <= 5;
    }

    if (data is List) {
      if (data.isEmpty) return true;
      return data.every(_isPrimitive) && data.length <= 5;
    }

    if (data is Set) {
      if (data.isEmpty) return true;
      return data.every(_isPrimitive) && data.length <= 5;
    }

    return false;
  }

  static bool _isPrimitive(dynamic value) {
    return value == null || value is String || value is num || value is bool;
  }
}

enum _LogLevel { debug, info, warning, success, network, error }

extension _LogLevelExtension on _LogLevel {
  String get icon {
    switch (this) {
      case _LogLevel.info:
        return 'ⓘ';
      case _LogLevel.warning:
        return '⚠︎';
      case _LogLevel.success:
        return '✓';
      case _LogLevel.network:
        return '⇄';
      case _LogLevel.error:
        return '✖';
      default:
        return '🛠';
    }
  }

  String get color {
    switch (this) {
      case _LogLevel.info:
        return _Log._blue;
      case _LogLevel.warning:
        return _Log._yellow;
      case _LogLevel.success:
        return _Log._green;
      case _LogLevel.network:
        return _Log._cyan;
      case _LogLevel.error:
        return _Log._red;
      default:
        return _Log._magenta;
    }
  }
}
