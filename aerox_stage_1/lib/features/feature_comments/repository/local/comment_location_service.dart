import 'package:aerox_stage_1/common/utils/either_catch.dart';
import 'package:aerox_stage_1/common/utils/error/err/location_err.dart';
import 'package:aerox_stage_1/common/utils/typedef.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CommentLocationService {

  Future<EitherErr<String>> getCity() async {
    return EitherCatch.catchAsync<String, LocationErr>(() async {
      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationErr( errMsg: 'Permiso de ubicación denegado', statusCode: 23);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationErr( errMsg: "Permiso de ubicación denegado permanentemente", statusCode: 33);
      }

      // Obtener ubicación actual
      Position position = await Geolocator.getCurrentPosition(

      );

      // Obtener ciudad a partir de coordenadas
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? "Ciudad desconocida";
      } else {
        throw LocationErr( errMsg: "No se pudo obtener la ciudad", statusCode: 21);
      }
    }, (exception) {
      return LocationErr( errMsg: "Error obteniendo ubicación: ${exception.toString()}", statusCode: 12);
    });
  }
}
