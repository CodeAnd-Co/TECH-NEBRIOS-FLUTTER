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

    // Inicializar controladores con valores por defecto
    viewModel = EditarCharolaViewModel(
      EditarCharola(charolaId: widget.charolaId),
    );

    // Inicializar dropdowns con valores por defecto
    viewModel.hidratacionItems = ["Zanahoria", "Manzana", "Agua"];

    viewModel.alimentoItems = ["Salvado", "Avena", "Maíz"];
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
              width: 600,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color.fromARGB(255, 240, 240, 240),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título de la charola
                      Texto.titulo1(
                        texto: "C-111", // Nombre de la charola
                        bold: true,
                        tamanio: 48,
                        color: const Color.fromARGB(250, 34, 166, 58),
                      ),
                      const SizedBox(height: 20),

                      // Campo de estado
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Texto.titulo2(texto: "Estado:"),
                          Expanded(
                            child: _buildTextFieldContainer(
                              '',
                              viewModel.estadoController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Campo de fecha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Texto.titulo2(texto: "Fecha:"),
                          Expanded(
                            child: _buildDateFieldContainer(
                              '',
                              viewModel.fechaController,
                              context,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Campo de peso
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Texto.titulo2(texto: "Peso:"),
                          Expanded(
                            child: _buildTextFieldContainer(
                              '',
                              viewModel.pesoController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [PositiveNumberFormatter()],
                            ),
                          ),
                          Texto.titulo2(texto: "g"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Campo de hidratación
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Texto.titulo2(texto: "Hidratación:"),
                          Expanded(
                            child: _buildDropdownFieldContainer(
                              'Opcion',
                              viewModel.hidratacionItems,
                              viewModel.selectedHidratacion,
                              (value) {
                                viewModel.selectedHidratacion = value;
                                viewModel.notifyListeners();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextFieldContainer(
                              'Cantidad',
                              viewModel.hidratacionCantidadController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [PositiveNumberFormatter()],
                            ),
                          ),
                          Texto.titulo2(texto: "g"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Campo de alimento
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Texto.titulo2(texto: "Alimento:"),
                          Expanded(
                            child: _buildDropdownFieldContainer(
                              'Opcion',
                              viewModel.alimentoItems,
                              viewModel.selectedAlimento,
                              (value) {
                                viewModel.selectedAlimento = value;
                                viewModel.notifyListeners();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextFieldContainer(
                              'Cantidad',
                              viewModel.alimentoCantidadController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [PositiveNumberFormatter()],
                            ),
                          ),
                          Texto.titulo2(texto: "g"),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ),
          ),
        );
      },
    );
  }
}
