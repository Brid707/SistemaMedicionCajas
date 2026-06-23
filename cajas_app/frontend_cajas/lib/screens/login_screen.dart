import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/app_text_styles.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_dark_button.dart';
import '../widgets/app_dark_input.dart';
import '../widgets/app_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool ocultarPassword = true;

  @override
  void dispose() {
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> iniciarSesion() async {
    final correo = correoController.text.trim();
    final password = passwordController.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      mostrarMensaje('Completa correo y contraseña');
      return;
    }

    final auth = context.read<AuthProvider>();

    final ok = await auth.login(correo: correo, password: password);

    if (!mounted) return;

    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      mostrarMensaje(auth.error ?? 'No se pudo iniciar sesión');
    }
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              titulo: '¡Bienvenido!',
              subtitulo: 'SISTEMA MEDICION DE\nCAJAS',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 42,
                  vertical: 34,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Iniciar sesión',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: 30),
                    AppDarkInput(
                      controller: correoController,
                      label: 'Correo',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    AppDarkInput(
                      controller: passwordController,
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      obscureText: ocultarPassword,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            ocultarPassword = !ocultarPassword;
                          });
                        },
                        icon: Icon(
                          ocultarPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    auth.cargando
                        ? const Center(child: CircularProgressIndicator())
                        : AppDarkButton(
                            text: 'ENTRAR',
                            onPressed: iniciarSesion,
                            height: 52,
                          ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Crear una cuenta',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
