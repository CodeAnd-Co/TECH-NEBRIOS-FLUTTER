import 'package:flutter/material.dart'; // Agrega otras vistas aquí si las tienes

class MainSidebarScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainSidebarScreen({Key? key, required this.onLogout}) : super(key: key);

  @override
  State<MainSidebarScreen> createState() => _MainSidebarScreenState();
}

class _MainSidebarScreenState extends State<MainSidebarScreen> {
  int _currentIndex = 0;

  final List<Widget> _views = [
    Placeholder(), // Charolas
    Placeholder(), // Tamizar
    Placeholder(), // Frass
    Placeholder(), // Alimentación
    Placeholder(), // Descargar Excel
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 85,
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/zuustento_logo.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 30),
                _buildNavItem(icon: Icons.inventory_2, label: 'Charolas', index: 0),
                _buildNavItem(icon: Icons.sensors, label: 'Tamizar', index: 1),
                _buildNavItem(icon: Icons.bug_report, label: 'Frass', index: 2),
                _buildNavItem(icon: Icons.edit_note, label: 'Alimentación', index: 3),
                _buildNavItem(icon: Icons.download, label: 'Excel', index: 4),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: widget.onLogout,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Vista activa
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _views,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(isSelected ? 1 : 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
