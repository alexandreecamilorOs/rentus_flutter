import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';

class LocationService {
  static final _dio = Dio();

  /// Request permissions and get current position
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Geocode an address string to coordinates using Nominatim (Web-compatible)
  static Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': address,
          'format': 'json',
          'limit': 1,
        },
        options: Options(
          headers: {
            'User-Agent': 'RentusFlutter/1.0',
          },
        ),
      );

      if (response.data is List && (response.data as List).isNotEmpty) {
        final first = (response.data as List).first;
        return LatLng(
          double.parse(first['lat']),
          double.parse(first['lon']),
        );
      }
    } catch (e) {
      print('Error geocoding address with Nominatim: $e');
    }
    return null;
  }

  /// Reverse geocode coordinates to an address using Nominatim
  static Future<String?> getAddressFromCoordinates(LatLng point) async {
    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': point.latitude,
          'lon': point.longitude,
          'format': 'json',
        },
        options: Options(
          headers: {
            'User-Agent': 'RentusFlutter/1.0',
          },
        ),
      );

      if (response.data != null && response.data['display_name'] != null) {
        return response.data['display_name'];
      }
    } catch (e) {
      print('Error reverse geocoding with Nominatim: $e');
    }
    return null;
  }
}
