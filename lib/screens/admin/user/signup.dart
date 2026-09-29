
import 'package:flutter/material.dart';
import 'package:picsapp/provider/logic.dart';
import 'package:picsapp/widgets/authtextfield.dart';
import 'package:picsapp/widgets/socialbutton.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final SignUpProvider signUpLogic = SignUpProvider();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  void createAccount() {
    String? nameError =
        signUpLogic.validateName(nameController.text);

    String? emailError =
        signUpLogic.validateEmail(emailController.text);

    String? passwordError =
        signUpLogic.validatePassword(passwordController.text);

    String? confirmPasswordError =
        signUpLogic.validateConfirmPassword(
      passwordController.text,
      confirmPasswordController.text,
    );

    if (nameError != null) {
      showMessage(nameError);
      return;
    }

    if (emailError != null) {
      showMessage(emailError);
      return;
    }

    if (passwordError != null) {
      showMessage(passwordError);
      return;
    }

    if (confirmPasswordError != null) {
      showMessage(confirmPasswordError);
      return;
    }

    showMessage('All details are valid');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff060A14),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 35,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ================= LOGO =================

              Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff6C63FF),
                      Color(0xff405DE6),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.landscape_rounded,
                  size: 55,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 22),

              // ================= APP NAME =================

              const Text(
                'P I C E S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),

              const SizedBox(height: 12),

              // ================= DESCRIPTION =================

              const Text(
                'Join our community and start sharing your favorite moments',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffB8BDCE),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              // ================= NAME =================

              AuthTextField(
                controller: nameController,
                hintText: 'Name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 15),

              // ================= EMAIL =================

              AuthTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 15),

              // ================= PASSWORD =================

              AuthTextField(
                controller: passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ================= CONFIRM PASSWORD =================

              AuthTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: obscureConfirmPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword =
                          !obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white70,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ================= CREATE ACCOUNT =================

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: createAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6255F5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ================= OR =================

              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xff30364A),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Color(0xff8F94A7),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xff30364A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ================= GOOGLE =================

              SocialButton(
                icon: Icons.g_mobiledata,
                text: 'Continue with Google',
                onPressed: () {},
              ),

              const SizedBox(height: 12),

              // ================= APPLE =================

              SocialButton(
                icon: Icons.apple,
                text: 'Continue with Apple',
                onPressed: () {},
              ),

              const SizedBox(height: 12),

              // ================= FACEBOOK =================

              SocialButton(
                icon: Icons.facebook,
                text: 'Continue with Facebook',
                onPressed: () {},
              ),

              const SizedBox(height: 28),

              // ================= SIGN IN =================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Color(0xffB8BDCE),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        color: Color(0xff7468FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
