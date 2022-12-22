import 'package:flutter/material.dart';
import 'package:mening_dokonim/providers/auth.dart';
import 'package:mening_dokonim/services/http_exeption.dart';
import 'package:provider/provider.dart';

enum AuthMode { Register, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;
  GlobalKey<FormState> _fromKey = GlobalKey();
  final _passwordController = TextEditingController();
  var _isLoading = false;
  Map<String, String> _authDate = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Xatolik."),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Okay"),
              ),
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (_fromKey.currentState!.validate()) {
      _fromKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        if (_authMode == AuthMode.Login) {
          //login
          await Provider.of<Auth>(context, listen: false).login(
            _authDate['email']!,
            _authDate['password']!,
          );
        } else {
          // register
          await Provider.of<Auth>(context, listen: false).signup(
            _authDate['email']!,
            _authDate['password']!,
          );
        }
      } on HttpException catch (error) {
        var errorMessage = "Xatolik sodir bo'ldi";

        if (error.message.contains("EMAIL_EXISTS")) {
          errorMessage = "Email band.";
        } else if (error.message.contains('INVALID_EMAIL')) {
          errorMessage = "To'g'ri email kiriting";
        } else if (error.message.contains('WEAK_PASSWORD')) {
          errorMessage = "Juda osson parol. ";
        } else if (error.message.contains('EMAIL_NOT_FOUND')) {
          errorMessage = "Bu Email bilan foydalanuvchi topilmadi";
        } else if (error.message.contains("INVALID_PASSWORD")) {
          errorMessage = "Paro'l nato'g'ri";
        }
        _showErrorDialog(errorMessage);
      } catch (e) {
        var errorMessage =
            "Kechirasiz hatolik sodir bo'ldi. Qaytadan urinib ko'ring";
        _showErrorDialog(errorMessage);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _fromKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Email manzil",
                  ),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Iltimos, email manzil kiriting";
                    } else if (!email.contains('@')) {
                      return "Iltimos, to'g'rim email kiriting";
                    }
                  },
                  onSaved: (email) {
                    _authDate['email'] = email!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Parol",
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Iltimos, parolni kiriting";
                    } else if (password.length < 6) {
                      return 'Parol judaham osson';
                    }
                  },
                  onSaved: (password) {
                    _authDate['password'] = password!;
                  },
                ),
                if (_authMode == AuthMode.Register)
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Parolni tasdiqlang",
                        ),
                        obscureText: true,
                        validator: (confirmPassword) {
                          if (_passwordController.text != confirmPassword) {
                            return 'Parollar bir biriga mos kelmadi';
                          }
                        },
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 60,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: Text(_authMode == AuthMode.Login
                            ? 'KIRISH'
                            : 'RO\'YHATDAN O\'TISH'),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 17),
                            minimumSize: const Size(double.infinity, 50)),
                      ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.Login
                        ? 'Ro\'yhatdan o\'tish'
                        : "Kirish",
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        decoration: TextDecoration.underline),
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
