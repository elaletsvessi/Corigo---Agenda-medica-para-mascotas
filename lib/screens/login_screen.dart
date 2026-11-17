import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/usuario.dart';
import '../models/mascota.dart';
import 'home_screen.dart';
import 'registro_screen.dart';
import 'main_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Las listas ahora empiezan vacías, se llenarán con los datos guardados
  List<Usuario> _usuariosFamilia = [];
  List<Mascota> _misMascotas = [];
  
  Usuario? _usuarioSeleccionado;
  Mascota? _mascotaSeleccionada;
  
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosGuardados(); // Carga la información de SQLite/Prefs al iniciar
  }

  // --- LÓGICA DE PERSISTENCIA ---
  Future<void> _cargarDatosGuardados() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Leer Usuarios
    final String? usuariosGuardados = prefs.getString('usuarios_familia');
    if (usuariosGuardados != null) {
      final List<dynamic> jsonList = jsonDecode(usuariosGuardados);
      _usuariosFamilia = jsonList.map((json) => Usuario(
        id: json['id'], 
        nombre: json['nombre']
      )).toList();
    } else {
      // Datos por defecto si no hay nada guardado
      _usuariosFamilia = [Usuario(id: 'u1', nombre: 'Alejandro')];
    }

    // Leer Mascotas (Simplificado para el login)
    final String? mascotasGuardadas = prefs.getString('mascotas_familia');
    if (mascotasGuardadas != null) {
      final List<dynamic> jsonList = jsonDecode(mascotasGuardadas);
      _misMascotas = jsonList.map((json) => Mascota(
        id: json['id'],
        nombre: json['nombre'],
        especie: json['especie'],
        edad: json['edad'],
        tareasDiarias: [], // Las tareas se manejan en el home
      )).toList();
    } else {
      // Mascota por defecto si no hay nada
      _misMascotas = [Mascota(
        id: 'm1', nombre: 'Corina <3', especie: 'Perrita', edad: 2, tareasDiarias: []
      )];
    }

    setState(() {
      _usuarioSeleccionado = _usuariosFamilia.first;
      _mascotaSeleccionada = _misMascotas.first;
      _cargando = false;
    });
  }

  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convertir y guardar Usuarios
    final List usuariosJson = _usuariosFamilia.map((u) => {
      'id': u.id,
      'nombre': u.nombre,
    }).toList();
    await prefs.setString('usuarios_familia', jsonEncode(usuariosJson));

    // Convertir y guardar Mascotas
    final List mascotasJson = _misMascotas.map((m) => {
      'id': m.id,
      'nombre': m.nombre,
      'especie': m.especie,
      'edad': m.edad,
    }).toList();
    await prefs.setString('mascotas_familia', jsonEncode(mascotasJson));
  }
  // -----------------------------

  void _entrarAlPanel() {
  if (_usuarioSeleccionado == null || _mascotaSeleccionada == null) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => MainLayout( // ¡Aquí cambiamos HomeScreen por MainLayout!
        usuarioActual: _usuarioSeleccionado!,
        mascotaActual: _mascotaSeleccionada!,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.pets, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pet Care Family',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 40),

              // Selector de Usuario
              const Align(alignment: Alignment.centerLeft, child: Text('¿Quién eres?')),
              const SizedBox(height: 8),
              _buildDropdown<Usuario>(
                items: _usuariosFamilia,
                value: _usuarioSeleccionado!,
                icon: Icons.person,
                getLabel: (u) => u.nombre,
                onChanged: (val) => setState(() => _usuarioSeleccionado = val!),
              ),
              const SizedBox(height: 24),

              // Selector de Mascota
              const Align(alignment: Alignment.centerLeft, child: Text('¿A quién vas a cuidar hoy?')),
              const SizedBox(height: 8),
              _buildDropdown<Mascota>(
                items: _misMascotas,
                value: _mascotaSeleccionada!,
                icon: Icons.pets,
                getLabel: (m) => m.nombre,
                onChanged: (val) => setState(() => _mascotaSeleccionada = val!),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _entrarAlPanel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Entrar al Panel', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Botón para dar de alta nuevos usuarios y mascotas
              TextButton(
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistroScreen()),
                  );

                  if (resultado != null) {
                    setState(() {
                      _usuariosFamilia.add(resultado['usuario']);
                      _misMascotas.add(resultado['mascota']);
                      
                      _usuarioSeleccionado = resultado['usuario'];
                      _mascotaSeleccionada = resultado['mascota'];
                    });

                    // ¡Llamamos a guardarDatos() para que persistan!
                    await _guardarDatos();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${resultado['mascota'].nombre} registrado con éxito!')),
                    );
                  }
                },
                child: const Text(
                  '¿Nueva mascota? Regístrala aquí',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required List<T> items,
    required T value,
    required IconData icon,
    required String Function(T) getLabel,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.shade100),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          icon: Icon(icon, color: Colors.blueAccent),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(getLabel(item), style: const TextStyle(fontSize: 18)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}