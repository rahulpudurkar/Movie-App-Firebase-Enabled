import 'package:flutter/material.dart';
import 'package:movielist/controller/signUpController.dart';
import 'package:movielist/view/userProfileEdit.dart';

class signInView extends StatelessWidget {
  final signUpController controller = signUpController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.deepPurple, 
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Create Your Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildTextFormField(
                controller: controller.emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
              SizedBox(height: 16.0),
              _buildTextFormField(
                controller: controller.passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () async {
                  bool signUpSuccess = await controller.signUp(context);
                  if (signUpSuccess) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfileEdit()));
                  }
                },
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), 
                  ),

                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context), 
                child: Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      obscureText: obscureText,
      style: TextStyle(fontSize: 16),
    );
  }
}