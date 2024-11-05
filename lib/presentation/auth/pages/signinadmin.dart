import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pharmacyapp/common/helper/navigator/app_navigator.dart';
import 'package:pharmacyapp/common/widgets/appbar/app_bar.dart';
import 'package:pharmacyapp/common/widgets/button/basic_app_button.dart';
import 'package:pharmacyapp/core/configs/theme/app_colors.dart';
import 'package:pharmacyapp/presentation/auth/admin/pages/admindasboard.dart';
import 'package:pharmacyapp/presentation/auth/pages/forgot_password.dart';
import 'package:pharmacyapp/presentation/auth/pages/signup_admin.dart';

class SigninAdminPage extends StatefulWidget {
  const SigninAdminPage({
    Key? key,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  }) : super(key: key);

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;

  @override
  State<SigninAdminPage> createState() => _SigninAdminPageState();
}

class _SigninAdminPageState extends State<SigninAdminPage> {
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final Logger _logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailCon.dispose();
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _signInText(),
            const SizedBox(height: 20),
            _emailField(),
            const SizedBox(height: 20),
            _passwordField(),
            const SizedBox(height: 20),
            _continueButton(),
            const SizedBox(height: 20),
            _forgotPassword(context),
            const SizedBox(height: 20),
            _createAccount(),
          ],
        ),
      ),
    );
  }

  Widget _signInText() {
    return const Text(
      'Admin Sign in',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCon,
      decoration: const InputDecoration(hintText: 'Enter Admin Email'),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _passwordCon,
      decoration: const InputDecoration(hintText: 'Enter Password'),
      obscureText: true,
    );
  }

  Future<List<String>> _fetchAdminEmails() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Admins').get();
    return querySnapshot.docs.map((doc) => doc['email'] as String).toList();
  }

  Future<bool> _signInWithEmail(String email, String password) async {
    final adminEmails = await _fetchAdminEmails();

    _logger.i('Attempting login with email: $email');

    // Check if the email is in the authorized admin list
    if (!adminEmails.contains(email)) {
      _logger.w('Unauthorized access attempt with email: $email');
      _showSnackBar('Unauthorized access');
      return false;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Login successful
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      if (e.code == 'user-not-found') {
        _showSnackBar('Email not registered');
      } else if (e.code == 'wrong-password') {
        _showSnackBar('Incorrect password');
      } else {
        _showSnackBar('An error occurred, please try again');
      }
      return false; // Login failed
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return; // Ensure the widget is still mounted
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _continueButton() {
    return BasicAppButton(
      onPressed: () async {
        final email = _emailCon.text;
        final password = _passwordCon.text;

        if (email.isNotEmpty && password.isNotEmpty) {
          final isEmailValid = RegExp(
            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
          ).hasMatch(email);

          if (!isEmailValid) {
            _showSnackBar('Please enter a valid email');
            return;
          }

          _logger.i('Attempting to sign in with email $email...');

          final success = await _signInWithEmail(email, password);

          if (mounted && success) {
            // Navigate to the admin home page after successful login
            AppNavigator.pushAndRemove(context, const AdminDashboard());
          }
        } else {
          _showSnackBar('Please enter your email and password');
        }
      },
      title: 'Continue',
    );
  }

  Widget _createAccount() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
              text: "Don't you have an account? ",
              style: TextStyle(color: Colors.black)),
          TextSpan(
            text: 'Create one',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(context, const SignupAdminPage());
              },
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        const TextSpan(
            text: "Forgot password? ", style: TextStyle(color: Colors.black)),
        TextSpan(
          text: 'Reset',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              AppNavigator.push(context, ForgotPasswordPage());
            },
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.primary),
        )
      ]),
    );
  }
}
