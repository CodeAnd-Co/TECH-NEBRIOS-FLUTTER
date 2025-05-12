import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tech_nebrios_tracker/framework/viewmodels/editar_charola_viewmodel.dart';
import './components/atoms/texto.dart';
import './components/molecules/boton_texto.dart';
import '../../utils/positive_number_formatter.dart';

class EditarCharola extends StatefulWidget {
  final int charolaId;

  const EditarCharola({super.key, required this.charolaId});

  @override
  State<EditarCharola> createState() => _EditarCharolaState();
}

class _EditarCharolaState extends State<EditarCharola> {
  late EditarCharolaViewModel viewModel;

  @override
  void initState() {
    super.initState();
    final editarCharolaUseCase = EditarCharola(
      charolaId: 1,
    ); // Inicializa el caso de uso
    viewModel = EditarCharolaViewModel(editarCharolaUseCase);
  }

  Widget _crearInfoFila(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Texto.titulo2(texto: '$label ', bold: true),
          Texto.titulo2(texto: value),
        ],
      ),
    );
  }

  Widget _crearBotonTexto(String texto, Color color, VoidCallback alPresionar) {
    return BotonTexto.simple(
      texto: Texto.titulo4(texto: texto, bold: true, color: Colors.white),
      alPresionar: alPresionar,
      colorBg: color,
    );
  }

  Widget _buildDateFieldContainer(
    String label,
    TextEditingController controller,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.all(5), // Margen alrededor del TextField
      child: SizedBox(
        width: 200, // Ancho fijo para el campo de fecha
        child: TextField(
          controller: controller,
          readOnly: true, // Evita que el usuario escriba manualmente
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today), // Ícono de calendario
          ),
          onTap: () async {
            // Mostrar el selector de fecha
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), // Fecha inicial
              firstDate: DateTime(2015), // Fecha mínima
              lastDate: DateTime.now(), // Fecha máxima
            );

            if (pickedDate != null) {
              // Formatear la fecha seleccionada
              String formattedDate =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              controller.text = formattedDate; // Actualizar el TextField
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength, // Nuevo parámetro para el límite de caracteres
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      margin: const EdgeInsets.all(5), // Margen alrededor del TextField
      child: SizedBox(
        width: 200, // Ancho fijo para los TextFields
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters:
              maxLength != null
                  ? [LengthLimitingTextInputFormatter(maxLength)]
                  : null, // Limitar caracteres si se especifica maxLength
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFieldContainer(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.all(5), // Margen alrededor del Dropdown
      child: SizedBox(
        width: 200, // Ancho fijo para el Dropdown
        child: DropdownButtonFormField<String>(
          value: selectedValue,
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
        ),
      ),
    );
  }

  String formatearFecha(String fecha) {
    try {
      final dateTime = DateTime.parse(fecha);
      if (fecha.contains('T')) {
        final dia = dateTime.day.toString().padLeft(2, '0');
        final mes = dateTime.month.toString().padLeft(2, '0');
        final anio = dateTime.year.toString();
        return '$dia/$mes/$anio';
      } else {
        return fecha;
      }
    } catch (e) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 247, 250),
          body: Center(
            child: SizedBox(
              width: 900,
              height: 900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Texto.titulo1(
                            texto: "Editar Charola",
                            bold: true,
                            tamanio: 64,
                            color: const Color.fromARGB(250, 34, 166, 58),
                          ),
                          const SizedBox(height: 20),
                          // Campo de estado
                          _buildTextFieldContainer(
                            'Estado',
                            viewModel.estadoController,
                          ),
                          const SizedBox(height: 20),
                          // Campo de fecha
                          _buildDateFieldContainer(
                            'Fecha',
                            viewModel.fechaController,
                            context,
                          ),
                          const SizedBox(height: 20),
                          // Campo de peso
                          _buildTextFieldContainer(
                            'Peso (Kg)',
                            viewModel.pesoController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [PositiveNumberFormatter()],
                          ),
                          const SizedBox(height: 20),
                          // Campo de hidratación
                          _buildTextFieldContainer(
                            'Hidratación (Kg)',
                            viewModel.hidratacionController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [PositiveNumberFormatter()],
                          ),
                          const SizedBox(height: 20),
                          // Campo de alimento
                          _buildTextFieldContainer(
                            'Alimento',
                            viewModel.alimentoController,
                          ),
                          const SizedBox(height: 30),
                          Wrap(
                            spacing: 150,
                            alignment: WrapAlignment.center,
                            children: [
                              _crearBotonTexto(
                                'Cancelar',
                                const Color.fromARGB(255, 228, 61, 61),
                                () {
                                  Navigator.of(context).pop();
                                  print('Botón de Cancelar presionado');
                                },
                              ),
                              _crearBotonTexto(
                                'Confirmar',
                                const Color.fromARGB(250, 34, 166, 58),
                                () async {
                                  await viewModel.editarCharola();
                                  print('Botón de Confirmar presionado');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
