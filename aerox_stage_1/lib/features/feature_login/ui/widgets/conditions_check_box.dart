import '../login_barrel.dart';

class ConditionsCheckBox extends StatefulWidget {
  const ConditionsCheckBox({
    super.key,
  });

  @override
  State<ConditionsCheckBox> createState() => _ConditionsCheckBoxState();
}

class _ConditionsCheckBoxState extends State<ConditionsCheckBox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme(
          data: ThemeData(
            //primarySwatch: Colors.blue,
            unselectedWidgetColor: Colors.white, // Your color
          ),
          child: Checkbox(
            checkColor: Colors.black, // Color of the check
            activeColor: Colors.white, // Color of the checkbox when checked
            value: isChecked,
            onChanged: (newValue) {
              setState(() {
                isChecked = newValue!;
              });
            }
          ),
        ),
        //const SizedBox(width: 8.0), // Add some space between the checkbox and the text
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans( // Cambiar el tipo de letra del hint text
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
              ), // Default text color
              children: [
                TextSpan(
                  text: 'By signing up you agree to Aerox\'s ',
                  style: GoogleFonts.plusJakartaSans( // Cambiar el tipo de letra del hint text
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ), 
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: GoogleFonts.plusJakartaSans( // Cambiar el tipo de letra del hint text
                    textStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: TextDecoration.underline
                  ), 
                  //recognizer: TapGestureRecognizer()..onTap = _launchPrivacyPolicyURL,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}