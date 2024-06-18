import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'start_trip_page.dart';
import '../services/supabase_service.dart';

class AvailableVehiclesPage extends StatefulWidget {
  @override
  _AvailableVehiclesPageState createState() => _AvailableVehiclesPageState();
}

class _AvailableVehiclesPageState extends State<AvailableVehiclesPage> {
  final SupabaseService _supabaseService = SupabaseService();
  String displayName = '';

  @override
  void initState() {
    super.initState();
    _fetchDisplayName();
  }

  Future<void> _fetchDisplayName() async {
    try {
      String name = await _supabaseService.getCurrentUserDisplayName();
      setState(() {
        displayName = name;
      });
    } catch (e) {
      // Manejo de errores si es necesario
      print(e);
    }
  }

  Future<List<dynamic>> _fetchAvailableVehicles() async {
    final response = await Supabase.instance.client
        .from('vehicles')
        .select()
        .eq('status', 'disponible')
        .execute();
    if (response.error == null) {
      return response.data;
    } else {
      throw response.error!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $displayName'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchAvailableVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay vehículos disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final vehicle = snapshot.data![index];
                return ListTile(
                  title: Text(vehicle['name']),
                  subtitle: Text(vehicle['model']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartTripPage(vehicle: vehicle),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
