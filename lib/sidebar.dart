import 'package:flutter/material.dart';

class SidebarLauncher extends StatefulWidget {
  const SidebarLauncher({super.key});

  @override
  State<SidebarLauncher> createState() => _SidebarLauncherState();
}

class _SidebarLauncherState extends State<SidebarLauncher> {
  bool _isSidebarOpen = false;
  bool _showArrow = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Sidebar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isSidebarOpen ? 0 : -250,
            top: 0,
            bottom: 0,
            width: 250,
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text("Shortcuts",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  const Divider(color: Colors.white30),
                  _buildShortcut(Icons.folder, "Files"),
                  _buildShortcut(Icons.web, "Browser"),
                  _buildShortcut(Icons.settings, "Settings"),
                  _buildShortcut(Icons.exit_to_app, "Exit"),
                ],
              ),
            ),
          ),

          // Arrow button
          Positioned(
            left: _isSidebarOpen ? 220 : 0,
            top: MediaQuery.of(context).size.height / 2 - 20,
            child: MouseRegion(
              onEnter: (_) => setState(() => _showArrow = true),
              onExit: (_) => setState(() => _showArrow = _isSidebarOpen),
              child: GestureDetector(
                onTap: _toggleSidebar,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showArrow ? 1.0 : 0.0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _isSidebarOpen ? Icons.chevron_left : Icons.chevron_right,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcut(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}
