//RF5 Registrar charola https://codeandco-wiki.netlify.app/docs/proyectos/larvas/documentacion/requisitos/RF5
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/charolaViewModel.dart';
import '../views/components/header.dart';
import '../../data/models/charolaModel.dart' as modelo;

class RegistrarCharolaView extends StatefulWidget {
  final bool postOnSave;
  const RegistrarCharolaView({super.key, this.postOnSave = true});

  @override
  _RegistrarCharolaView createState() => _RegistrarCharolaView();
}

class _RegistrarCharolaView extends State<RegistrarCharolaView> {
  @override
  void initState() {
    super.initState();
    // Al iniciar, ponemos la fecha de hoy en el campo
    final vm = Provider.of<CharolaViewModel>(context, listen: false);
    final today = DateTime.now();
    final dd = today.day.toString().padLeft(2, '0');
    final mm = today.month.toString().padLeft(2, '0');
    vm.fechaController.text = '$dd/$mm/${today.year}';
    vm.fechaController.text = '${today.day}/${today.month}/${today.year}';
    vm.cargarHidratacion();
    vm.cargarAlimentos();

    // Prellenar campos
    vm.densidadLarvaController.text = '900';
    vm.hidratacionCicloController.text = '200';

    // Cargar hidratación y seleccionar Zanahoria cuando termine
    vm.cargarHidratacion().then((_) {
      final posibles = vm.hidrataciones
      .where((h) => h.nombreHidratacion.toLowerCase() == 'zanahoria')
      .toList();

      if (posibles.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            vm.selectedHidratacion = posibles.first;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CharolaViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.cargarAlimentos();
      vm.cargarHidratacion();
    });

    return WillPopScope(
      onWillPop: () async {
        vm.resetForm();
        return true;
      },
      child: Scaffold(
        body: Form(
          key: vm.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header(
                  titulo: 'Registrar charola',
                  subtitulo: 'Ingresa una charola nueva',
                  showDivider: true,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 4.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildTextFormField(
                        label: 'Nombre *',
                        controller: vm.nombreController,
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nombre obligatorio'
                                    : null,
                        maxLength: 20,
                      ),
                      _buildTextFormField(
                        label: 'Densidad de Larva (g) *',
                        controller: vm.densidadLarvaController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Ingresa densidad'
                                    : null,
                        maxLength: 8,
                      ),
                      _buildDateFormField(
                        label: 'Fecha (dd/mm/yyyy) *',
                        controller: vm.fechaController,
                        context: context,
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Selecciona fecha'
                                    : null,
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: 200,
                        child: DropdownButtonFormField<String>(
                          hint:
                              vm.alimentos.isEmpty
                                  ? const Text(
                                    'No hay alimentos disponibles',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  )
                                  : const Text('Selecciona alimento'),
                          decoration: const InputDecoration(
                            labelText: 'Alimentación *',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                          items:
                              vm.alimentos
                                  .map(
                                    (a) => DropdownMenuItem(
                                      value: a.nombreAlimento,
                                      child: Text(a.nombreAlimento),
                                    ),
                                  )
                                  .toList(),
                          value: vm.selectedAlimentacion?.nombreAlimento,
                          onChanged:
                              vm.alimentos.isEmpty
                                  ? null
                                  : (value) {
                                    vm.selectedAlimentacion = vm.alimentos
                                        .firstWhere(
                                          (a) => a.nombreAlimento == value,
                                        );
                                  },
                          validator:
                              (v) => v == null ? 'Selecciona alimento' : null,
                        ),
                      ),

                      _buildTextFormField(
                        label: 'Cantidad de alimento (g) *',
                        controller: vm.comidaCicloController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Ingresa cantidad'
                                    : null,
                        maxLength: 8,
                      ),
                      const SizedBox(), // Espacio para alinear con el dropdown
                      Container(
                        margin: const EdgeInsets.all(5),
                        width: 200,
                        child: DropdownButtonFormField<String>(
                          hint:
                              vm.hidrataciones.isEmpty
                                  ? const Text(
                                    'No hay hidratación disponible',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  )
                                  : const Text('Selecciona hidratación'),
                          decoration: const InputDecoration(
                            labelText: 'Hidratación *',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                          items:
                              vm.hidrataciones
                                  .map(
                                    (h) => DropdownMenuItem(
                                      value: h.nombreHidratacion,
                                      child: Text(h.nombreHidratacion),
                                    ),
                                  )
                                  .toList(),
                          value: vm.selectedHidratacion?.nombreHidratacion,
                          onChanged:
                              vm.hidrataciones.isEmpty
                                  ? null
                                  : (value) {
                                    vm.selectedHidratacion = vm.hidrataciones
                                        .firstWhere(
                                          (h) => h.nombreHidratacion == value,
                                        );
                                  },
                          validator:
                              (v) =>
                                  v == null ? 'Selecciona hidratación' : null,
                        ),
                      ),
                      _buildTextFormField(
                        label: 'Cantidad de hidratación (g) *',
                        controller: vm.hidratacionCicloController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Ingresa cantidad'
                                    : null,
                        maxLength: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                vm.cargandoRegistro
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: () async {
                        if (vm.formKey.currentState!.validate()) {
                          if (widget.postOnSave) {
                            try {
                              final nuevaTarjeta = await vm.registrarCharola();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Charola creada exitosamente.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              vm.resetForm();
                              await vm.cargarCharolas();
                              Navigator.pop(context, nuevaTarjeta);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            final parts = vm.fechaController.text.split('/');
                            final day = int.parse(parts[0]);
                            final month = int.parse(parts[1]);
                            final year = int.parse(parts[2]);
                            final fecha = DateTime(year, month, day);
                            final nuevaCharola = modelo.CharolaRegistro(
                              nombreCharola: vm.nombreController.text,
                              fechaCreacion: fecha,
                              fechaActualizacion: fecha,
                              densidadLarva: double.parse(
                                vm.densidadLarvaController.text,
                              ),
                              comidas: [
                                modelo.ComidaAsignada(
                                  comidaId: vm.selectedAlimentacion!.idAlimento,
                                  cantidadOtorgada: double.parse(
                                    vm.comidaCicloController.text,
                                  ),
                                ),
                              ],
                              hidrataciones: [
                                modelo.HidratacionAsignada(
                                  hidratacionId:
                                      vm.selectedHidratacion!.idHidratacion,
                                  cantidadOtorgada: double.parse(
                                    vm.hidratacionCicloController.text,
                                  ),
                                ),
                              ],
                            );
                            vm.resetForm();
                            Navigator.pop(context, nuevaCharola);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        minimumSize: const Size(200, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Registrar',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: SizedBox(
        width: 200,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildDateFormField({
    required String label,
    required TextEditingController controller,
    required BuildContext context,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: SizedBox(
        width: 200,
        child: TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: validator,
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              locale: const Locale('es', 'ES'),
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              cancelText: 'Cancelar',
              confirmText: 'Aceptar',
            );
            if (pickedDate != null) {
              final dd = pickedDate.day.toString().padLeft(2, '0');
              final mm = pickedDate.month.toString().padLeft(2, '0');
              controller.text = '$dd/$mm/${pickedDate.year}';
            }
          },
        ),
      ),
    );
  }

  Widget _buildDropdownFormField<T>({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: SizedBox(
        width: 200,
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
}
