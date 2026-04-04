import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  final bool isMale;
  final Color bgColor;
  final Color primaryColor;
  final VoidCallback onBack;
  final Function(String user, String email, String pass, bool isLogin) onAuth;

  const AuthScreen({
    super.key,
    required this.isMale,
    required this.bgColor,
    required this.primaryColor,
    required this.onBack,
    required this.onAuth,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginView = false;
  bool obscure = true;
  final userCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Text(
              "SecretSpace",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5E3C),
              ),
            ),
            Image.asset(
              widget.isMale
                  ? 'assets/images/star.png'
                  : 'assets/images/ribbon.png',
              height: 80,
            ),
            Text(
              isLoginView ? "Log in!" : "Create a fun account!",
              style: TextStyle(
                fontSize: 22,
                color: widget.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLoginView
                      ? "Don't have an account? "
                      : "Already have an account? ",
                ),
                GestureDetector(
                  onTap: () => setState(() => isLoginView = !isLoginView),
                  child: Text(
                    isLoginView ? "Sign Up" : "Login",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!isLoginView)
              CustomTextField(
                controller: userCtrl,
                icon: Icons.person_outline,
                hint: "Username",
              ),
            CustomTextField(
              controller: emailCtrl,
              icon: Icons.email_outlined,
              hint: "Email",
            ),
            CustomTextField(
              controller: passCtrl,
              icon: Icons.lock_outline,
              hint: "Password",
              obscure: true,
              showPassword: !obscure,
              onToggleVisibility: () => setState(() => obscure = !obscure),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => widget.onAuth(
                userCtrl.text,
                emailCtrl.text,
                passCtrl.text,
                isLoginView,
              ),
              child: Text(
                isLoginView ? "Log In" : "Register",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
