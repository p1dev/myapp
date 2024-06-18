import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<PostgrestResponse> getAvailableVehicles() async {
    return await _client.from('vehicles').select().eq('status', 'disponible').execute();
  }

  Future<PostgrestResponse> updateVehicleStatus(int vehicleId, String status) async {
    return await _client.from('vehicles').update({'status': status}).eq('id', vehicleId).execute();
  }

  Future<PostgrestResponse> startTrip(int vehicleId, String userEmail, String destination, String kilometraje, String gasolineLevel) async {
    return await _client.from('trips').insert({
      'vehicle_id': vehicleId,
      'user_email': userEmail,
      'destination': destination,
      'kilometraje': kilometraje,
      'gasoline_level': gasolineLevel,
      'start_time': DateTime.now().toIso8601String(),
      'status': 'in_progress',
    }).execute();
  }

    Future<String> getCurrentUserDisplayName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:4084696984.
      return user.userMetadata['first_name'] ?? 'Usuario';
    } else {
      throw Exception('Usuario no autenticado');
    }
  }

  Future<PostgrestResponse> endTrip(int vehicleId, int duration) async {
    return await _client.from('trips').update({
      'end_time': DateTime.now().toIso8601String(),
      'status': 'completed',
      'duration': duration,
    }).eq('vehicle_id', vehicleId).eq('status', 'in_progress').execute();
  }
}
