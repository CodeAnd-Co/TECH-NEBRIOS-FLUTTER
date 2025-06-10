/// RF13 Registrar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF13
/// RF19 Editar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF19
/// RF14 Eliminar usuario https://codeandco-wiki.netlify.app/docs/next/proyectos/larvas/documentacion/requisitos/RF14

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/components/header.dart';
import 'package:zuustento_tracker/framework/viewmodels/usuarioViewModel.dart';
import 'package:zuustento_tracker/framework/views/components/FormFields.dart';

class VistaUsuario extends StatefulWidget {
  const VistaUsuario({super.key});

  @override
  State<VistaUsuario> createState() => _VistaUsuario();
}

class _VistaUsuario extends State<VistaUsuario> {
  final formKey3 = GlobalKey<FormState>();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UsuarioViewModel>(context, listen: false).obtenerUsuarios();
      Provider.of<UsuarioViewModel>(context, listen: false).esAdministrador();
    });
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<UsuarioViewModel>(
      builder: (context, vistaModelo, child) {
        return Scaffold(
          body: vistaModelo.cargando
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const Header(
                      titulo: "Usuarios",
                      showDivider: true,
                    ),
                    vistaModelo.error
                        ? Center(
                            child: Column(
                              children: [
                                const Text(
                                  "Ocurrió un error al obtener los datos:",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  vistaModelo.mensaje,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
                        : Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                             child: Container(
                              height: screenHeight * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3357D),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Text("Nombre completo",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            const Expanded(
                                              child: Text("Cuenta",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            const Expanded(
                                              child: Text("Rol",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            vistaModelo.esAdmin
                                                ? const Expanded(
                                                    child: Text("Acciones",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  Expanded(
                                    child: Scrollbar(
                                      controller: _scrollController,
                                      thumbVisibility: true,
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      child: Column(
                                        children: vistaModelo.usuarios
                                            .map((usuario) {
                                          final nombreCompleto =
                                              "${usuario['nombre']} ${usuario['apellido_p']} ${usuario['apellido_m']}";
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child:
                                                        Text(nombreCompleto)),
                                                Expanded(
                                                    child:
                                                        Text(usuario['user'])),
                                                Expanded(
                                                    child: Text(
                                                        usuario['tipo_usuario'])),
                                                vistaModelo.esAdmin && vistaModelo.idActual != usuario['usuarioId']
                                                    ? Expanded(
                                                        child: Row(
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .black),
                                                              onPressed: () {
                                                                mostrarPopUpEditarUsuario(
                                                                  context: context, 
                                                                  usuarioId: usuario['usuarioId'],
                                                                  nombre: usuario['nombre'],
                                                                  apellidoM: usuario['apellido_m'],
                                                                  apellidoP: usuario['apellido_p'],
                                                                  usuario: usuario['user']
                                                                );
                                                              },
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red),
                                                              onPressed: () {
                                                                  mostrarPopUpEliminarUsuario(context: context, usuarioId: usuario['usuarioId']);
                                                                },
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : 
                                                    vistaModelo.esAdmin && vistaModelo.idActual == usuario['usuarioId'] ?  Expanded(child: Text("")):
                                                    const SizedBox.shrink(),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    vistaModelo.esAdmin
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    mostrarPopUpRegistrarUsuario(
                                        context: context);
                                  },
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
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(height: 30),
                    const SizedBox(height: 10),
                  ],
                ),
        );
      },
    );
  }

  void mostrarPopUpRegistrarUsuario({
    required BuildContext context,
  }) {
    final usuarioViewModel =
        Provider.of<UsuarioViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ChangeNotifierProvider.value(
          value: usuarioViewModel,
          child: Consumer<UsuarioViewModel>(
            builder: (context, usuarioViewModel, _) {
              return AlertDialog(
                title: const Text(
                  'Registrar Usuario',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey3,
                    child: Column(
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 30),
                        CustomTextFormField(
                          label: "Nombre *",
                          controller: usuarioViewModel.nombreController,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Nombre obligatorio' : null,
                          maxLength: 20,
                          width: 400,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          label: "Apellido paterno *",
                          controller: usuarioViewModel.apellidoPController,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Apellido paterno obligatorio'
                              : null,
                          maxLength: 20,
                          width: 400,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          label: "Apellido materno",
                          controller: usuarioViewModel.apellidoMController,
                          maxLength: 20,
                          width: 400,
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          label: "Nombre de usuario *",
                          controller: usuarioViewModel.usuarioController,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Nombre de usuario obligatorio'
                              : null,
                          maxLength: 20,
                          width: 400,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          label: "Contraseña *",
                          controller: usuarioViewModel.contrasenaController,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Contraseña obligatoria'
                              : null,
                          maxLength: 20,
                          width: 400,
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
                        usuarioViewModel.cargandoRegistro
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
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      usuarioViewModel.resetForm();
                                      Navigator.of(dialogContext).pop();
                                    },
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
                                    child: const Text(
                                      'Registrar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (formKey3.currentState!.validate()) {
                                        await usuarioViewModel.registrarUsuario();
                                        usuarioViewModel.resetForm();
                                        Navigator.of(dialogContext).pop();
                                        
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                usuarioViewModel.mensaje),
                                            backgroundColor:
                                                usuarioViewModel.error
                                                    ? Colors.red
                                                    : Colors.green,
                                          ),
                                        );
                                        usuarioViewModel.obtenerUsuarios();
                                      }
                                    },
                                  ),
                                ],
                              )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  void mostrarPopUpEditarUsuario({
    required BuildContext context,
    required int usuarioId,
    required String nombre,
    required String apellidoM,
    required String apellidoP,
    required String usuario
  }) {
    final usuarioViewModel =
        Provider.of<UsuarioViewModel>(context, listen: false);
    usuarioViewModel.nombreController.text = nombre;
    usuarioViewModel.apellidoMController.text = apellidoM;
    usuarioViewModel.apellidoPController.text = apellidoP;
    usuarioViewModel.usuarioController.text = usuario;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return ChangeNotifierProvider.value(
          value: usuarioViewModel,
          child: Consumer<UsuarioViewModel>(
            builder: (context, usuarioViewModel, _) {
              return AlertDialog(
                title: const Text(
                  'Editar Usuario',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey3,
                    child: Column(
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 30),
                        CustomTextFormField(
                          label: "Nombre *",
                          controller: usuarioViewModel.nombreController,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Nombre obligatorio' : null,
                          maxLength: 20,
                          width: 400,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          label: "Apellido paterno *",
                          controller: usuarioViewModel.apellidoPController,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Apellido paterno obligatorio'
                              : null,
                          maxLength: 20,
                          width: 400,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          label: "Apellido materno",
                          controller: usuarioViewModel.apellidoMController,
                          maxLength: 20,
                          width: 400,
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          label: "Nombre de usuario *",
                          controller: usuarioViewModel.usuarioController,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Nombre de usuario obligatorio'
                              : null,
                          maxLength: 20,
                          width: 400,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          label: "Contraseña *",
                          controller: usuarioViewModel.contrasenaController,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Contraseña obligatoria'
                              : null,
                          maxLength: 20,
                          width: 400,
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
                        usuarioViewModel.cargandoRegistro
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
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      usuarioViewModel.resetForm();
                                      Navigator.of(dialogContext).pop();
                                    },
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
                                    child: const Text(
                                      'Editar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (formKey3.currentState!.validate()) {
                                        await usuarioViewModel.editarUsuario(usuarioId);
                                        usuarioViewModel.resetForm();
                                        Navigator.of(dialogContext).pop();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                usuarioViewModel.mensaje),
                                            backgroundColor:
                                                usuarioViewModel.error
                                                    ? Colors.red
                                                    : Colors.green,
                                          ),
                                        );

                                        usuarioViewModel.obtenerUsuarios();
                                      }
                                    },
                                  ),
                                ],
                              )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  void mostrarPopUpEliminarUsuario({
    required BuildContext context,
    required int usuarioId,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Consumer<UsuarioViewModel>(
          builder: (context, usuarioViewModel, _) {
            return AlertDialog(
              title: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Eliminar Usuario',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/images/alert-icon.png',
                        height: 60,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "¿Estás seguro de querer continuar con esta acción?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "(Una vez eliminado, no se puede recuperar.)",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 30),
                      usuarioViewModel.cargandoRegistro
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'Eliminar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () async {
                              await usuarioViewModel.eliminarUsuario(usuarioId);
                              Navigator.of(dialogContext).pop();
                              
                              ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                    usuarioViewModel.mensaje),
                                backgroundColor:
                                    usuarioViewModel.error
                                        ? Colors.red
                                        : Colors.green,
                              ),
                            );

                            usuarioViewModel.obtenerUsuarios();
                          }
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

}
