import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:picsapp/provider/logic.dart';
import 'package:picsapp/widgets/authtextfield.dart';
import 'package:picsapp/widgets/socialbutton.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    // 1. Read the provider
    final signInLogic = context.read<SignInProvider>();

    // 2. Validate
    String? emailError = signInLogic.validateEmail(emailController.text);
    String? passwordError = signInLogic.validatePassword(
      passwordController.text,
    );

    if (emailError != null) return showMessage(emailError);
    if (passwordError != null) return showMessage(passwordError);

    // 3. Call Firebase
    final error = await signInLogic.signIn(
      email: emailController.text,
      password: passwordController.text,
    );

    if (error != null) {
      showMessage(error);
    } else {
      showMessage('Login successful!');
      // TODO: Navigate to your Home Screen here
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<SignInProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xff060A14),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                  ),
                ),
                child: const Icon(
                  Icons.landscape,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'P I C E S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign in to explore amazing images',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 40),
              AuthTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => obscurePassword = !obscurePassword),
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white60,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => showMessage('Forgot password clicked'),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xff8B7CFF),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6255F5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: const Color(0xff30364A)),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Container(height: 1, color: const Color(0xff30364A)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SocialButton(
                icon: Icons.g_mobiledata,
                text: 'Continue with Google',
                onPressed: () => showMessage('Google clicked'),
              ),
              const SizedBox(height: 12),
              SocialButton(
                icon: Icons.apple,
                text: 'Continue with Apple',
                onPressed: () => showMessage('Apple clicked'),
              ),
              const SizedBox(height: 12),
              SocialButton(
                icon: Icons.facebook,
                text: 'Continue with Facebook',
                onPressed: () => showMessage('Facebook clicked'),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      ' Sign Up',
                      style: TextStyle(
                        color: Color(0xff8B7CFF),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Guest Mode",
                  style: TextStyle(
                    color: Color(0xff8B7CFF),
                    fontSize: 14,
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
}
