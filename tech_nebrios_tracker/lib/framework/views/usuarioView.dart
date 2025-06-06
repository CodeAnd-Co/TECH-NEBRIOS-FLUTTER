import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/components/header.dart';
import 'package:zuustento_tracker/framework/viewmodels/usuarioViewModel.dart';

class VistaUsuario extends StatefulWidget{
  const VistaUsuario({super.key});

  @override
  State<VistaUsuario> createState() => _VistaUsuario();
}

class _VistaUsuario extends State<VistaUsuario>{
  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Usuarioviewmodel>(context, listen: false).obtenerUsuarios();
    });
  }

  @override 
  Widget build(BuildContext context){
    return Consumer<Usuarioviewmodel>(
      builder: (context, vistaModelo, child){
        return Scaffold(
          body: vistaModelo.cargando ? const Center(child: CircularProgressIndicator(),) :
          Column(
            children: [
              const Header(
                titulo: "Usuarios",
                showDivider: true,
              ),
              vistaModelo.error ? 
                Center(
                  child: Column(
                    children: [
                      Text("Ocurrió un error al obtener los datos:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                      Text(vistaModelo.mensaje, style: TextStyle(fontSize: 20),),
                      SizedBox(height: 10,),
                    ],
                  )
                  
                )
              :
              SingleChildScrollView(//RefreshIndicator(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE3357D),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Center(
                            child: Row(
                              children: [
                                Expanded(child: Text("Nombre completo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                Expanded(child: Text("Cuenta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                Expanded(child: Text("Rol", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                Expanded(child:Text("Acciones", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
                              ]
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Column(
                        children: vistaModelo.usuarios.map((usuario){
                          final nombreCompleto = "${usuario['nombre']} ${usuario['apellido_p']} ${usuario['apellido_m']}";
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            child: Row(
                              children: [
                                Expanded(child: Text(nombreCompleto)),
                                Expanded(child: Text(usuario['user'])),
                                Expanded(child: Text(usuario['tipo_usuario'])),
                                Expanded(child: 
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.black,),
                                        onPressed: () {}, 
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {},
                                      )
                                    ],
                                  )
                                )
                              ],
                            ),
                          );
                        }
                      ).toList()
                      )
                    ],
                  ),
                ),
              ),
              
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {}, 
                      icon: const Icon(Icons.add, size: 24),
                      label: const Text("Registrar usuario"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        backgroundColor: const Color(0xFF0066FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]
          )
        );
      }
    );
  }
}