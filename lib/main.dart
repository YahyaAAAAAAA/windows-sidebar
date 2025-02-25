import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/utils/windows/window_animation_utils.dart';
import 'package:windows_widgets/utils/windows/windows_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Window.initialize();
  await windowManager.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      alwaysOnTop: true,
      size: const Size(200, 100),
    ),
    () async {
      await windowManager.focus();
      await windowManager.setSkipTaskbar(false);
      //  await windowManager.setAsFrameless();

      //get the current window title
      String windowTitle = await windowManager.getTitle();

      //get the Flutter app window handle using the actual title
      int hwnd = WindowsUtils.getFlutterWindowHandle(windowTitle);

      if (hwnd == 0) {
        print("❌ Failed to get Flutter window handle");
        return;
      }

      print("✅ Flutter window handle: $hwnd");

      //make the window clickable
      WindowsUtils.setWindowClickable(hwnd);

      //apply transparent effect
      await Window.setEffect(effect: WindowEffect.transparent);

      await WindowsUtils.moveWindowToRightEdge();

      runApp(MyApp(windowHandle: hwnd));
    },
  );
}

class MyApp extends StatefulWidget {
  final int windowHandle;

  const MyApp({
    super.key,
    required this.windowHandle,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin, WindowListener {
  AnimationController? _controller;
  Animation<Offset>? _animation;
  CurvedAnimation? _curvedAnimation;
  Offset _originalPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(kAlwaysCompleteAnimation);

    windowManager.addListener(this);
    _getInitialPosition();
  }

  @override
  void dispose() {
    _controller?.dispose();
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _getInitialPosition() async {
    final position = await windowManager.getPosition();
    setState(() {
      _originalPosition =
          Offset(position.dx.toDouble(), position.dy.toDouble());
    });
  }

  Future<void> _animateWindow(Offset targetOffset) async {
    final currentPosition = await windowManager.getPosition();

    _curvedAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );

    _animation = Tween<Offset>(
      begin:
          Offset(currentPosition.dx.toDouble(), currentPosition.dy.toDouble()),
      end: targetOffset,
    ).animate(_curvedAnimation!)
      ..addListener(() async {
        await windowManager.setPosition(_animation!.value);
      });

    _controller!.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Stack(
          children: [
            MouseRegion(
              onEnter: (_) => _animateWindow(
                _originalPosition + Offset(-50, 0),
              ),
              onExit: (_) => _animateWindow(
                _originalPosition,
              ),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Text(
                    "Click",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
