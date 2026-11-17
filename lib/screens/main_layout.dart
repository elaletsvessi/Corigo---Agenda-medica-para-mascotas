import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/mascota.dart';
import 'home_screen.dart';
import 'tracker_screen.dart'; 

class MainLayout extends StatefulWidget {
  final Usuario usuarioActual;
  final Mascota mascotaActual;

  const MainLayout({
    super.key,
    required this.usuarioActual,
    required this.mascotaActual,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _indiceSeleccionado = 0;

  // Lista de pantallas a las que podemos navegar
  late final List<Widget> _pantallas;

 @override
  void initState() {
    super.initState();
    _pantallas = [
      HomeScreen(
        usuarioActual: widget.usuarioActual,
        mascotaActual: widget.mascotaActual,
      ),
      // ¡Aquí reemplazamos el placeholder por el TrackerScreen!
      TrackerScreen(
        mascotaActual: widget.mascotaActual,
      ),
      const Center(child: Text('Cámara y Detalles en construcción 📸', style: TextStyle(fontSize: 20))),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_indiceSeleccionado], // Muestra la pantalla correspondiente
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Panel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Paseos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Cámara',
          ),
        ],
        currentIndex: _indiceSeleccionado,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}