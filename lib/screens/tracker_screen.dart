import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/mascota.dart';

class TrackerScreen extends StatefulWidget {
  final Mascota mascotaActual;

  const TrackerScreen({super.key, required this.mascotaActual});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  late Stream<StepCount> _stepCountStream;
  String _pasos = '0';
  late SharedPreferences _prefs;

  late List _actividades;

  @override
  void initState() {
    super.initState();
    // Inicializamos las actividades a partir de las tareas de la mascota
    _actividades = widget.mascotaActual.tareasDiarias.map((tarea) => {
      'nombre': tarea.titulo,
      'completado': false,
    }).toList();

    // Si la mascota no tiene tareas, agregamos unas por defecto de paseo
    if (_actividades.isEmpty) {
      _actividades = [
        {'nombre': 'Paseo en el parque (Meta: 3km)', 'completado': false},
        {'nombre': 'Juego de pelota (15 min)', 'completado': false},
      ];
    }

    _cargarDatosGuardados();
    _solicitarPermisos();
  }

  // Persistencia: Cargar estado al abrir la app
  Future<void> _cargarDatosGuardados() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < _actividades.length; i++) {
        // Usamos el ID de la mascota para que cada mascota tenga su propio registro de paseos
        _actividades[i]['completado'] = _prefs.getBool('actividad_${widget.mascotaActual.id}_$i') ?? false;
      }
    });
  }

  // Solicitar permiso físico al usuario para el sensor
  Future<void> _solicitarPermisos() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _iniciarPodometro();
    } else {
      setState(() => _pasos = 'Sin permiso');
    }
  }

  // Conectar con el sensor de hardware del teléfono
  void _iniciarPodometro() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      (StepCount event) {
        setState(() {
          _pasos = event.steps.toString();
        });
      },
      onError: (error) {
        setState(() => _pasos = 'No disponible');
      },
    );
  }

  // Persistencia: Guardar estado al tocar un check
  void _toggleActividad(int index) {
    setState(() {
      _actividades[index]['completado'] = !_actividades[index]['completado'];
      _prefs.setBool('actividad_${widget.mascotaActual.id}_$index', _actividades[index]['completado']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FF),
      appBar: AppBar(
        title: Text('Paseos con ${widget.mascotaActual.nombre}'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Tarjeta Superior: Contador de Pasos Activo (Hardware)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pets, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Text(
                        'Pasos de ${widget.mascotaActual.nombre} hoy',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _pasos,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Lista de Actividades con estado guardado (Persistencia)
            Expanded(
              child: ListView.builder(
                itemCount: _actividades.length,
                itemBuilder: (context, index) {
                  final completado = _actividades[index]['completado'];
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: completado ? const Color(0xFFD4EED8) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        _actividades[index]['nombre'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        completado ? '¡Completado!' : 'Pendiente',
                        style: TextStyle(
                          color: completado ? Colors.green[700] : Colors.grey,
                        ),
                      ),
                      trailing: Icon(
                        completado ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: completado ? Colors.green : Colors.grey,
                        size: 30,
                      ),
                      onTap: () => _toggleActividad(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}