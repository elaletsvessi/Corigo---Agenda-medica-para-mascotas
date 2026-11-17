import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/mascota.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Usuario usuarioActual;
  final Mascota mascotaActual;

  const HomeScreen({
    super.key,
    required this.usuarioActual,
    required this.mascotaActual,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();

  void _toggleActividad(int index) {
    setState(() {
      widget.mascotaActual.tareasDiarias[index].completado = 
          !widget.mascotaActual.tareasDiarias[index].completado;
    });
  }

  void _cerrarSesion() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _mostrarDialogoAgregar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nueva tarea para ${widget.mascotaActual.nombre}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Tarea (Ej. Baño)'),
              ),
              TextField(
                controller: _categoriaController,
                decoration: const InputDecoration(labelText: 'Categoría (Ej. Higiene)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  widget.mascotaActual.tareasDiarias.add(
                    TareaCuidado(
                      titulo: _tituloController.text,
                      categoria: _categoriaController.text,
                    ),
                  );
                });
                _tituloController.clear();
                _categoriaController.clear();
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
        title: Text('Hola, ${widget.usuarioActual.nombre}'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _cerrarSesion),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Perfil dinámico de la Mascota
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.pets, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            widget.mascotaActual.nombre,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '${widget.mascotaActual.especie} • ${widget.mascotaActual.edad} años',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1.5, color: Colors.grey),
          
          // Lista de Tareas de la Mascota
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.mascotaActual.tareasDiarias.length,
              itemBuilder: (context, index) {
                final tarea = widget.mascotaActual.tareasDiarias[index];
                
                return Dismissible(
                  key: UniqueKey(), 
                  background: _buildEliminarFondo(Alignment.centerLeft, const EdgeInsets.only(left: 20)),
                  secondaryBackground: _buildEliminarFondo(Alignment.centerRight, const EdgeInsets.only(right: 20)),
                  onDismissed: (direction) {
                    setState(() {
                      widget.mascotaActual.tareasDiarias.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${tarea.titulo} eliminado')),
                    );
                  },
                  child: Card(
                    color: tarea.completado ? Colors.green.shade100 : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(
                        Icons.pets, 
                        color: tarea.completado ? Colors.green.shade700 : Colors.grey
                      ),
                      title: Text(
                        tarea.titulo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tarea.completado ? Colors.green.shade900 : Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        tarea.completado ? 'Completado por ${widget.usuarioActual.nombre}' : tarea.categoria,
                        style: TextStyle(
                          color: tarea.completado ? Colors.green.shade700 : Colors.grey.shade600,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          tarea.completado ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: tarea.completado ? Colors.green : Colors.grey,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: _mostrarDialogoAgregar,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEliminarFondo(Alignment alineacion, EdgeInsets padding) {
    return Container(
      color: Colors.red.shade400,
      margin: const EdgeInsets.only(bottom: 12),
      alignment: alineacion,
      padding: padding,
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }
}