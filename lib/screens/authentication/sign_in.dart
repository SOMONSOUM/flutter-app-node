import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_node/services/auth_method.dart';
import 'package:flutter_app_node/utils/utility.dart';
import 'package:flutter_app_node/widgets/loading.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onToggle;
  const SignInScreen({
    Key? key,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textPasswordController = TextEditingController();

  final AuthResource authResource = AuthResource();
  String email = '';
  String password = '';
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _textEmailController.dispose();
    _textPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingSpinkit()
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 90,
                            bottom: 10,
                          ),
                          child: const Icon(
                            Icons.account_circle,
                            color: Color.fromARGB(255, 204, 204, 204),
                            size: 110,
                          ),
                        ),
                        const Text(
                          "Welcome Back",
                          style: kTextTitle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Sign to continue", style: kDescription),
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _textEmailController,
                                  decoration: const InputDecoration(
                                    hintText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  onChanged: (values) =>
                                      setState(() => email = values),
                                  validator: (values) {
                                    if (values!.isEmpty) {
                                      return "Enter email";
                                    }
                                    if (!EmailValidator.validate(values)) {
                                      return "Email invalid";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  controller: _textPasswordController,
                                  decoration: const InputDecoration(
                                    hintText: 'Password',
                                    prefixIcon: Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  onChanged: (values) =>
                                      setState(() => password = values),
                                  validator: (values) =>
                                      values!.isEmpty ? "Enter password" : null,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => isLoading = true);
                                      final dynamic result =
                                          await authResource.authSignIn(
                                        context: context,
                                        email: email,
                                        password: password,
                                      );
                                      if (result != null) {
                                        setState(() => isLoading = false);
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 15),
                                    padding: const EdgeInsets.all(17),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "Login".toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't have an account yet?",
                                        style: TextStyle(fontFamily: "Barlow"),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: widget.onToggle,
                                        child: const Text(
                                          "Create new account",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontFamily: "Barlow",
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
