import 'package:pharmacyapp/common/helper/navigator/app_navigator.dart';
import 'package:pharmacyapp/common/widgets/appbar/app_bar.dart';
import 'package:pharmacyapp/common/widgets/button/basic_app_button.dart';
import 'package:pharmacyapp/data/auth/models/admin_creation_req.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pharmacyapp/presentation/auth/pages/signinadmin.dart';

class SignupAdminPage extends StatelessWidget {
  SignupAdminPage({super.key});

  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _confirmPasswordCon =
      TextEditingController();

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
            const SizedBox(
              height: 20,
            ),
            _firstNameField(),
            const SizedBox(
              height: 20,
            ),
            _lastNameField(),
            const SizedBox(
              height: 20,
            ),
            _emailField(),
            const SizedBox(
              height: 20,
            ),
            _passwordField(context),
            const SizedBox(
              height: 20,
            ),
            _confirmPasswordField(context),
            const SizedBox(
              height: 20,
            ),
            _continueButton(context),
            const SizedBox(
              height: 20,
            ),
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
      onPressed: () {
        // Check if any field is empty
        if (_firstNameCon.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your first name')),
          );
          return; // Exit the function early
        }

        if (_lastNameCon.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your last name')),
          );
          return; // Exit the function early
        }

        if (_emailCon.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your email address')),
          );
          return; // Exit the function early
        }

        if (_passwordCon.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your password')),
          );
          return; // Exit the function early
        }

        if (_confirmPasswordCon.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please confirm your password')),
          );
          return; // Exit the function early
        }

        // Check if passwords match
        if (_passwordCon.text != _confirmPasswordCon.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
          return; // Exit the function early
        }

        // Proceed to the next page if all validations pass
        AppNavigator.push(
          context, AdminCreationReq(
              firstName: _firstNameCon.text,
              email: _emailCon.text,
              lastName: _lastNameCon.text,
              password: _passwordCon.text,
            ) as Widget,
        );
      },
      title: 'Continue',
    );
  }

  Widget _createAccount(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        const TextSpan(text: "Do you have an account? "),
        TextSpan(
            text: 'Signin',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.pushReplacement(context, const SigninAdminPage());
              },
            style: const TextStyle(fontWeight: FontWeight.bold))
      ]),
    );
  }
}