import 'package:flutter/material.dart';
import 'end_trip_page.dart';

class StartTripPage extends StatefulWidget {
  final dynamic vehicle;

  StartTripPage({required this.vehicle});

  @override
  _StartTripPageState createState() => _StartTripPageState();
}

class _StartTripPageState extends State<StartTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _kilometrajeController = TextEditingController();
  String _gasolineLevel = '1/4';

  Future<void> _startTrip(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EndTripPage(
            vehicle: widget.vehicle,
            destination: _destinationController.text,
            kilometraje: _kilometrajeController.text,
            gasolineLevel: _gasolineLevel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Viaje'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(labelText: 'Destino'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el destino';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kilometrajeController,
                decoration: InputDecoration(labelText: 'Kilometraje'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el kilometraje';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _gasolineLevel,
                decoration: InputDecoration(labelText: 'Nivel de Gasolina'),
                items: ['1/4', '2/4', '3/4', '4/4']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _gasolineLevel = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _startTrip(context),
                child: Text('Iniciar Viaje'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
