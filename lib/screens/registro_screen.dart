import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/mascota.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para el Dueño
  final _nombreUsuarioController = TextEditingController();

  // Controladores para la Mascota
  final _nombreMascotaController = TextEditingController();
  final _especieController = TextEditingController();
  final _edadController = TextEditingController();

  void _registrar() {
    if (_formKey.currentState!.validate()) {
      // Creamos los nuevos objetos con los datos del formulario
      final nuevoUsuario = Usuario(
        id: DateTime.now().toString(), // ID simulado
        nombre: _nombreUsuarioController.text,
      );

      final nuevaMascota = Mascota(
        id: DateTime.now().toString(), // ID simulado
        nombre: _nombreMascotaController.text,
        especie: _especieController.text,
        edad: int.parse(_edadController.text),
        tareasDiarias: [], // Inicia sin tareas
      );

      // Regresamos a la pantalla anterior enviando los datos nuevos
      Navigator.pop(context, {'usuario': nuevoUsuario, 'mascota': nuevaMascota});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Registro de Familia'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Datos del Dueño', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreUsuarioController,
                decoration: InputDecoration(
                  labelText: 'Tu Nombre',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa tu nombre' : null,
              ),
              
              const SizedBox(height: 32),
              const Text('Datos de la Mascota', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreMascotaController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la mascota (Ej. Corina)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.pets),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa el nombre de tu mascota' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _especieController,
                decoration: InputDecoration(
                  labelText: 'Especie (Ej. Perro, Gato)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.category),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa la especie' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Edad (Años)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.cake),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.isEmpty ? 'Ingresa la edad' : null,
              ),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _registrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Registrar y Continuar', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}