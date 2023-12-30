import 'package:agriplant/components/my_button.dart';
import 'package:agriplant/components/my_textfield.dart';
import 'package:agriplant/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final contactNumberController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    ageController.dispose();
    addressController.dispose();
    contactNumberController.dispose();

    super.dispose();
  }

//sign user up
  void signUp() async {
    // Check if password and confirm password match
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password do not match. Try Again!'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Stop the registration process if passwords don't match
    }
    final authService = Provider.of<AuthService>(context, listen: false);

    // Passwords match, proceed with user registration
    try {
      await authService.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
         fullNameController.text.trim(),
          addressController.text.trim(),
          int.parse(ageController.text.trim()),
          int.parse(contactNumberController.text.trim()),
          );

      }catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Let's create!
                Text(
                  "Let's create!",
                  style: GoogleFonts.bebasNeue(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),

                const SizedBox(height: 10),

                // fullname textfield
                MyTextField(
                  controller: fullNameController,
                  hintText: 'Full name',
                  obscureText: false,
                  prefixIcon: IconlyLight.profile,
                ),

                const SizedBox(height: 10),

                // age textfield
                MyTextField(
                  controller: ageController,
                  hintText: 'Age',
                  obscureText: false,
                  prefixIcon: IconlyLight.calendar,
                ),

                const SizedBox(height: 10),

                // address textfield
                MyTextField(
                  controller: addressController,
                  hintText: 'Address',
                  obscureText: false,
                  prefixIcon: IconlyLight.location,
                ),

                const SizedBox(height: 10),

                // contact number textfield
                MyTextField(
                  controller: contactNumberController,
                  hintText: 'Contact number',
                  obscureText: false,
                  prefixIcon: IconlyLight.call,
                ),

                const SizedBox(height: 10),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  prefixIcon: IconlyLight.message,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  prefixIcon: IconlyLight.lock,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  prefixIcon: IconlyLight.lock,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: signUp,
                  text: 'Create account',
                ),

                const SizedBox(height: 100),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
