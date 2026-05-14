import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/features/auth/presentation/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(ResetAuthStateEvent());
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
      );
      return;
    }
    context.read<AuthBloc>().add(LoginEvent(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Chào mừng bạn trở lại',
                style: TextStyle(
                  color: Color(0xFF1877F2),
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email hoặc số điện thoại',
                        filled: true,
                        fillColor: const Color(0xFFF5F6F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: passwordController,
                      obscureText: isPasswordHidden,
                      decoration: InputDecoration(
                        hintText: 'Mật khẩu',
                        filled: true,
                        fillColor: const Color(0xFFF5F6F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                          icon: Icon(
                            isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (_, state) {
                        if (state.status != AppStatus.error) {
                          return SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              state.error ??
                                  'Đăng nhập thất bại. Vui lòng nhập đúng tài khoản hoặc mật khẩu',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ],
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<AuthBloc>(),
                                child: ForgotPasswordScreen(),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Color(0xFF1877F2),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1877F2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chưa có tài khoản?',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<AuthBloc>(),
                                  child: RegisterScreen(),
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF42B72A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 2)),
                        const SizedBox(width: 10),
                        Text('Hoặc', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 10),
                        Expanded(child: Divider(thickness: 2)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Icon(
                          function: () {
                            context.read<AuthBloc>().add(GoogleLoginEvent());
                          },
                          icon: Image.asset('assets/icons/auth/google.png', width: 40, height: 40,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Expense Tracker App',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
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

class _Icon extends StatelessWidget {
  const _Icon({required this.function, required this.icon});

  final VoidCallback function;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Center(
        child: IconButton(onPressed: function, icon: icon),
      ),
    );
  }
}
