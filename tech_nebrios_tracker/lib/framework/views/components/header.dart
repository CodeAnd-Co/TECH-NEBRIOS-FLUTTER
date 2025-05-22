import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final bool showDivider;

  const Header({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: const Color(0xFFF5F7FA),
          title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 35,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (showDivider)
          const Divider(
            color: Color.fromARGB(255, 0, 0, 0),
            thickness: 2,
            height: 20,
          ),
        if (subtitulo != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              subtitulo!,
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
      ],
    );
  }
}