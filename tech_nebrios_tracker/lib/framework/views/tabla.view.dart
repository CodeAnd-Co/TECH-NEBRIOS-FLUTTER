import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

class VistaTablaCharolas extends StatelessWidget {
  const VistaTablaCharolas({super.key});

  @override
  Widget build(BuildContext){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obtener Datos'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 35,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: Center(
          child: Table(
            border: TableBorder.all(),
            children: [
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Charola'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Fecha de creación'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Ultima actualización'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Peso'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Comida x Ciclo'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Hidratación x Ciclo'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Estado'),
                ),

                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Densidad de larva'),
                ),
                
              ],
            ),
            ]
          ),
          
        )
    );
  }
}