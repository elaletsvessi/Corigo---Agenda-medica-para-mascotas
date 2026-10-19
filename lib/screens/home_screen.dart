import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista de actividades de cuidado para Corina
  final List<Map<String, dynamic>> _actividades = [
    {'titulo': 'Paseo de la mañana', 'subtitulo': 'Parque Tangamanga', 'completado': false},
    {'titulo': 'Porción de croquetas', 'subtitulo': 'Alimentación', 'completado': false},
    {'titulo': 'Dosis de medicina', 'subtitulo': 'Desparasitante', 'completado': false},
    {'titulo': 'Cepillado de pelo', 'subtitulo': 'Higiene', 'completado': false},
  ];

  // Controladores para capturar el texto del nuevo pendiente
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _subtituloController = TextEditingController();

  void _toggleActividad(int index) {
    setState(() {
      _actividades[index]['completado'] = !_actividades[index]['completado'];
    });
  }

  // Función para abrir el cuadro de diálogo y agregar pendiente
  void _mostrarDialogoAgregar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar pendiente para Corina'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: '¿Qué necesita Corina?'),
              ),
              TextField(
                controller: _subtituloController,
                decoration: const InputDecoration(labelText: 'Categoría o Detalles'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
              onPressed: () {
                // Agregar a la lista y actualizar la pantalla
                setState(() {
                  _actividades.add({
                    'titulo': _tituloController.text,
                    'subtitulo': _subtituloController.text,
                    'completado': false,
                  });
                });
                _tituloController.clear();
                _subtituloController.clear();
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Perfil de Corina'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Sección de Perfil
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.pets, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            'Corina <3',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1.5, color: Colors.grey),
          const SizedBox(height: 16),
          
          // Fila de Estadísticas Rápidas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('Edad', '2 años'),
              _buildStatCard('Peso', '8kg'),
              _buildStatCard('Racha', '5 Días'),
            ],
          ),
          const SizedBox(height: 20),

          // Lista de Actividades (Con Dismissible para borrar deslizando)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _actividades.length,
              itemBuilder: (context, index) {
                final act = _actividades[index];
                final bool completado = act['completado'];

                // Envolvemos la tarjeta en Dismissible para poder deslizarla
                return Dismissible(
                  key: UniqueKey(), // Llave única necesaria para borrar
                  // Fondo que se muestra al deslizar
                  background: Container(
                    color: Colors.red.shade400,
                    margin: const EdgeInsets.only(bottom: 12),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red.shade400,
                    margin: const EdgeInsets.only(bottom: 12),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  onDismissed: (direction) {
                    // Borramos el elemento de la lista
                    setState(() {
                      _actividades.removeAt(index);
                    });
                    
                    // Mensaje rápido (SnackBar) de confirmación
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${act['titulo']} eliminado')),
                    );
                  },
                  child: Card(
                    color: completado ? Colors.green.shade100 : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(
                        Icons.pets, 
                        color: completado ? Colors.green.shade700 : Colors.grey
                      ),
                      title: Text(
                        act['titulo'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: completado ? Colors.green.shade900 : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        completado ? '¡Completado!' : act['subtitulo'],
                        style: TextStyle(
                          color: completado ? Colors.green.shade700 : Colors.grey.shade600,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          completado ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: completado ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => _toggleActividad(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      // Configuración del botón flotante centrado
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: _mostrarDialogoAgregar,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget auxiliar para las tarjetas de estadísticas
  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}