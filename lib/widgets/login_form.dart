import 'package:flutter/material.dart';
import '../services/authentication_service.dart';
import '../screens/home_page.dart'; // Import the HomeScreen
import '../models/user.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;
  bool _isLoginMode = true; // Toggle between login and signup

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      try {
        CustomUser? user = _isLoginMode
            ? await AuthenticationService.login(email, password)
            : await AuthenticationService.signUp(email, password);

        if (user != null) {
          print(
              "Authentication and user fetch successful, navigating to home page...");
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          print("Authentication successful but user data is null.");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Authentication successful but failed to fetch user data.')));
        }
      } catch (e) {
        print("Error during authentication or user data fetch: $e");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Form validation failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLoginMode ? 'Welcome Back!' : 'Create Account',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006747)),
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty || !value.contains('@'))
                          ? 'Please enter a valid email'
                          : null,
                  onSaved: (value) => email = value!,
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a password'
                      : null,
                  onSaved: (value) => password = value!,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006747),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(_isLoginMode ? 'Login' : 'Sign Up',
                          style: TextStyle(
                              fontSize: 18, color: Color(0xFFFFDF00))),
                ),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode;
                    });
                  },
                  child: Text(
                    _isLoginMode
                        ? 'Create new account'
                        : 'Have an account? Log in',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
