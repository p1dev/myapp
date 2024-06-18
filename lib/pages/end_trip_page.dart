import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class EndTripPage extends StatefulWidget {
  final dynamic vehicle;
  final String destination;
  final String kilometraje;
  final String gasolineLevel;

  EndTripPage({
    required this.vehicle,
    required this.destination,
    required this.kilometraje,
    required this.gasolineLevel,
  });

  @override
  _EndTripPageState createState() => _EndTripPageState();
}

class _EndTripPageState extends State<EndTripPage> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startTrip();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  Future<void> _startTrip() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('trips')
        .insert({
          'vehicle_id': widget.vehicle['id'],
          'destination': widget.destination,
          'kilometraje': widget.kilometraje,
          'gasoline_level': widget.gasolineLevel,
          'user_email': supabase.auth.currentUser?.email,
          'start_time': DateTime.now().toIso8601String(),
          'status': 'in_progress',
        })
        .execute();

    if (response.error == null) {
      await supabase
          .from('vehicles')
          .update({'status': 'ocupado'})
          .eq('id', widget.vehicle['id'])
          .execute();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar el viaje: ${response.error!.message}')),
      );
    }
  }

  Future<void> _endTrip() async {
    _stopTimer();
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('trips')
        .update({
          'end_time': DateTime.now().toIso8601String(),
          'status': 'completed',
          'duration': _elapsedSeconds,
        })
        .eq('vehicle_id', widget.vehicle['id'])
        .eq('status', 'in_progress')
        .execute();

    if (response.error == null) {
      await supabase
          .from('vehicles')
          .update({'status': 'disponible'})
          .eq('id', widget.vehicle['id'])
          .execute();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Viaje finalizado correctamente')),
      );
      Navigator.popUntil(context, ModalRoute.withName('/home'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al finalizar el viaje: ${response.error!.message}')),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Viaje en Progreso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Tiempo transcurrido: ${_elapsedSeconds} segundos'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _endTrip,
              child: Text('Finalizar Viaje'),
            ) ,
          ],
        ),
      ),
    );
  }
}
