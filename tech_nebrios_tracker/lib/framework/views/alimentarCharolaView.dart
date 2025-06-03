import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/alimentacionViewModel.dart';
import '../../framework/viewmodels/charolaViewModel.dart';

void mostrarDialogoAlimentar(
  BuildContext context,
  int charolaId,
  CharolaViewModel charolaViewModel,
) async {
  final comidaCharolaVM = Provider.of<AlimentacionViewModel>(
    context,
    listen: false,
  );

  await comidaCharolaVM.cargarAlimentos();

  int? comidaIdSeleccionada;
  final TextEditingController cantidadController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogcontext) {
      return ChangeNotifierProvider.value(
        value: comidaCharolaVM,
        child: Consumer<AlimentacionViewModel>(
          builder: (context, value, _) {
            final listaIds =
                comidaCharolaVM.alimentos.map((a) => a.idAlimento).toList();

            int? valorActual;
            if (comidaIdSeleccionada != null &&
                listaIds.contains(comidaIdSeleccionada)) {
              valorActual = comidaIdSeleccionada;
            } else {
              valorActual = null;
            }

            return AlertDialog(
              title: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Registrar alimentación',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: comidaCharolaVM.formKey,
                  child: Column(
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              child: DropdownButtonFormField<int>(
                                hint:
                                    comidaCharolaVM.alimentos.isEmpty
                                        ? const Text(
                                          'No hay alimentos disponibles',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                        )
                                        : const Text('Selecciona alimento'),
                                decoration: const InputDecoration(
                                  labelText: 'Tipo de alimento *',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                                items:
                                    comidaCharolaVM.alimentos
                                        .map(
                                          (alimento) => DropdownMenuItem<int>(
                                            value: alimento.idAlimento,
                                            child: Text(
                                              alimento.nombreAlimento,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                value: valorActual,
                                onChanged:
                                    comidaCharolaVM.alimentos.isEmpty
                                        ? null
                                        : (value) {
                                          comidaIdSeleccionada = value;
                                        },
                                validator:
                                    (v) =>
                                        v == null
                                            ? 'Selecciona alimento'
                                            : null,
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.all(5),
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
                                  labelText:
                                      'Cantidad (g) *', 
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  counterText: '',
                                ),
                                validator:
                                    (v) =>
                                        v == null || v.isEmpty
                                            ? 'Ingresa cantidad'
                                            : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      comidaCharolaVM.isLoading
                          ? const CircularProgressIndicator()
                          : Row(
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
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
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
                                  if (comidaCharolaVM.formKey.currentState!
                                      .validate()) {
                                    final cantidad = int.parse(
                                      cantidadController.text,
                                    );

                                    await comidaCharolaVM.registrarAlimentacion(
                                      charolaId: charolaId,
                                      comidaId: comidaIdSeleccionada!,
                                      cantidadOtorgada: cantidad,
                                      fechaOtorgada:
                                          DateTime.now().toIso8601String(),
                                    );

                                    Navigator.of(context).pop();

                                    if (comidaCharolaVM.error != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error: ${comidaCharolaVM.error}',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Alimentación registrada con éxito',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                    await charolaViewModel.cargarCharola(
                                      charolaId,
                                    );
                                  }
                                },
                                child: const Text(
                                  'Alimentar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
