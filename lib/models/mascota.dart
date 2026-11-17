class TareaCuidado {
  String titulo;
  String categoria;
  bool completado;

  TareaCuidado({
    required this.titulo,
    required this.categoria,
    this.completado = false,
  });
}

class Mascota {
  final String id;
  final String nombre;
  final String especie; // Ej. Perro, Gato
  final int edad;
  final List<TareaCuidado> tareasDiarias;

  Mascota({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.edad,
    required this.tareasDiarias,
  });
}