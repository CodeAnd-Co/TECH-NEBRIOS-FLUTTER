// RF42 Registrar la hidratación de la charola - Documentación: https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF42

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/hidratacionViewModel.dart';
import '../../framework/viewmodels/charolaViewModel.dart';


  void mostrarDialogoHidratar(BuildContext context, int charolaId, CharolaViewModel charolaViewModel) async {
    final hidratacionCharolaVM = Provider.of<HidratacionViewModel>(
      context,
      listen: false,
    );

    await hidratacionCharolaVM.cargarHidratacion();

    int? hidratacionIdSeleccionada;
    final TextEditingController cantidadController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogcontext) {
        return ChangeNotifierProvider.value(
          value: hidratacionCharolaVM,
          child: Consumer<HidratacionViewModel>(
            builder: (context, value, _){
              return AlertDialog(
                title: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Registrar hidratación',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ]
              ),
                content: SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Form(
                      key: hidratacionCharolaVM.formKey,
                      child: Column(
                        children: [
                          const Divider(height: 1),
                          const SizedBox(height: 30),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 250,
                                child: DropdownButtonFormField<int>(
                                  isExpanded: true,
                                  value: hidratacionIdSeleccionada,
                                  items:
                                      hidratacionCharolaVM.listaHidratacion.map((hidratacion) {
                                        return DropdownMenuItem<int>(
                                          value: hidratacion.idHidratacion,
                                          child: Text(hidratacion.nombreHidratacion),
                                          
                                        );
                                      }).toList(),
                                    
                                  onChanged: (value) {
                                    hidratacionIdSeleccionada = value;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Tipo de hidratación*',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (v) => v == null ? 'Selecciona hidratación' : null,
                                ),
                              ),
                              const SizedBox(width: 22),
                              SizedBox(
                                width: 250,
                                child: TextFormField(
                                  controller: cantidadController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Cantidad otorgada (g)*',
                                  ),
                                  validator:  (v) => v == null || v.isEmpty ? 'Ingresa cantidad' : null,
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    )
                  )
                ),
                actions: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        hidratacionCharolaVM.isLoading ? CircularProgressIndicator() :
                        Row(
                          children: [
                            TextButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancelar',style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: const Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () async {
                                if (hidratacionCharolaVM.formKey.currentState!.validate()) {
                                final cantidad = int.parse(cantidadController.text);

                                await hidratacionCharolaVM.registrarHidratacion(
                                  charolaId: charolaId,
                                  hidratacionId: hidratacionIdSeleccionada!,
                                  cantidadOtorgada: cantidad,
                                  fechaOtorgada: DateTime.now().toIso8601String(),
                                );

                                Navigator.of(context).pop();

                                if (hidratacionCharolaVM.error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: ${hidratacionCharolaVM.error}'),
                                      backgroundColor:  Colors.red,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Hidratación registrada con éxito'),
                                      backgroundColor:  Colors.green,
                                    ),
                                  );
                                }
                                await charolaViewModel.cargarCharola(charolaId);
                                }
                              },
                              child: Text('Hidratar',style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ],
                        )
                      ]
                    )
                  )
                ],
              );
            }
          )
        );
      }
    );
  }
