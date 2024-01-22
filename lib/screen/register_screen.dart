import 'package:declarative_navigation/model/user.dart';
import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const RegisterScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                ),
                const SizedBox(height: 8),
                context.watch<AuthProvider>().isLoadingRegister
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.purple,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            final User user = User(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            final authRead = context.read<AuthProvider>();

                            final result = await authRead.saveUser(user);
                            if (result) widget.onRegister();
                          }
                        },
                        child: const Text('REGISTER'),
                      ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => widget.onLogin(),
                  child: const Text('LOGIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
