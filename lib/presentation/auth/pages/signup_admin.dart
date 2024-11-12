import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacyapp/common/helper/navigator/app_navigator.dart';
import 'package:pharmacyapp/common/widgets/appbar/app_bar.dart';
import 'package:pharmacyapp/common/widgets/button/basic_app_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';
import 'package:pharmacyapp/presentation/auth/pages/signinadmin.dart';

class SignupAdminPage extends StatefulWidget {
  const SignupAdminPage({super.key});

  @override
  SignupAdminPageState createState() => SignupAdminPageState();
}

class SignupAdminPageState extends State<SignupAdminPage> {
  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _confirmPasswordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _siginText(),
            const SizedBox(height: 20),
            _firstNameField(),
            const SizedBox(height: 20),
            _lastNameField(),
            const SizedBox(height: 20),
            _emailField(),
            const SizedBox(height: 20),
            _passwordField(context),
            const SizedBox(height: 20),
            _confirmPasswordField(context),
            const SizedBox(height: 20),
            _continueButton(context),
            const SizedBox(height: 20),
            _createAccount(context)
          ],
        ),
      ),
    );
  }

  Widget _siginText() {
    return const Text(
      'Create Account',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _firstNameField() {
    return TextField(
      controller: _firstNameCon,
      decoration: const InputDecoration(hintText: 'Firstname'),
    );
  }

  Widget _lastNameField() {
    return TextField(
      controller: _lastNameCon,
      decoration: const InputDecoration(hintText: 'Lastname'),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCon,
      decoration: const InputDecoration(hintText: 'Email Address'),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _passwordCon,
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Password'),
    );
  }

  Widget _confirmPasswordField(BuildContext context) {
    return TextField(
      controller: _confirmPasswordCon,
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Confirm Password'),
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () async {
        // Input validation checks
        if (_firstNameCon.text.isEmpty ||
            _lastNameCon.text.isEmpty ||
            _emailCon.text.isEmpty ||
            _passwordCon.text.isEmpty ||
            _confirmPasswordCon.text.isEmpty) {
          _showMessage('Please fill in all fields');
          return;
        }
        if (_passwordCon.text != _confirmPasswordCon.text) {
          _showMessage('Passwords do not match');
          return;
        }

        try {
          // Firebase registration
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailCon.text,
            password: _passwordCon.text,
          );

          // Log the uid to check if it's generated
          if (userCredential.user != null) {
            String adminId = userCredential.user!.uid; // Capture adminId

            // Store user information in Firestore
            await FirebaseFirestore.instance
                .collection('Admins')
                .doc(adminId) // Use adminId as the document ID
                .set({
              'adminId': adminId, // Store the adminId explicitly
              'firstName': _firstNameCon.text,
              'lastName': _lastNameCon.text,
              'email': _emailCon.text,
              'createdAt':
                  FieldValue.serverTimestamp(), // Timestamp for admin creation
            });

            // Navigate to SigninAdminPage on successful registration
            _navigateToSignin();
          } else {
            _showMessage('User creation failed, please try again.');
          }
        } on FirebaseAuthException catch (e) {
          String errorMessage = 'Registration failed';
          if (e.code == 'weak-password') {
            errorMessage = 'The password provided is too weak.';
          } else if (e.code == 'email-already-in-use') {
            errorMessage = 'An account already exists for that email.';
          }
          _showMessage(errorMessage);
        } catch (e) {
          _showMessage('An error occurred, please try again');
        }
      },
      title: 'Continue',
    );
  }

  // Helper method to show a snackbar message
  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // Helper method to navigate to SigninAdminPage
  void _navigateToSignin() {
    if (mounted) {
      AppNavigator.push(context, const SigninAdminPage());
    }
  }

  Widget _createAccount(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        const TextSpan(
            text: "Do you have an account? ",
            style: TextStyle(color: Colors.black)),
        TextSpan(
          text: 'Signin',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              AppNavigator.pushReplacement(context, const SigninAdminPage());
            },
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ]),
    );
  }
}
