import '../login_barrel.dart';

class UserDataTextField extends StatelessWidget {
  const UserDataTextField({
    super.key,
    required this.text,
    required this.controller,
    this.obscureText = false,
    this.validator,
  });

  final String text;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
      children: [
        Text(
          text, // ✅ Texto arriba del campo
          style: GoogleFonts.plusJakartaSans(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8), // Espaciado entre el texto y el campo
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent, // Fondo transparente
            borderRadius: BorderRadius.circular(15), // Bordes redondeados
            border: Border.all(color: Colors.white, width: 2.0), // Borde blanco
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: GoogleFonts.plusJakartaSans(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Espaciado interno
              border: InputBorder.none, // Elimina el borde por defecto
            ),
          ),
        ),
      ],
    );
  }
}
