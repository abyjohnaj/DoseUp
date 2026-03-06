import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String role = "user";

  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 15),

            DropdownButton<String>(
              value: role,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "user", child: Text("User")),
                DropdownMenuItem(value: "pharmacist", child: Text("Pharmacist")),
                DropdownMenuItem(value: "pharmacy", child: Text("Pharmacy")),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () async {

                await auth.signUp(
                  name: nameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  role: role,
                );

                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}