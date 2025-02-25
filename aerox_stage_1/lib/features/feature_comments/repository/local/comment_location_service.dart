import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CommentLocationService {
  static Future<String> getCity() async {
    try {
      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return "Permiso denegado";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return "Permiso denegado permanentemente";
      }

      // Obtener ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Obtener ciudad a partir de coordenadas
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? "Ciudad desconocida";
      } else {
        return "No se pudo obtener la ciudad";
      }
    } catch (e) {
      return "Error obteniendo ubicación: $e";
    }
  }
}
