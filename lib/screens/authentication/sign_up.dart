import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_node/services/auth_method.dart';
import 'package:flutter_app_node/utils/utility.dart';
import 'package:flutter_app_node/widgets/loading.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onToggle;
  const SignUpScreen({
    Key? key,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textNameController = TextEditingController();
  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textPhoneController = TextEditingController();
  final TextEditingController _textPasswordController = TextEditingController();
  final TextEditingController _textConfirmPasswordController =
      TextEditingController();

  final AuthResource authResource = AuthResource();
  String name = '';
  String email = '';
  dynamic phoneNumber;
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _textNameController.dispose();
    _textEmailController.dispose();
    _textPhoneController.dispose();
    _textPasswordController.dispose();
    _textConfirmPasswordController.dispose();
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
                        Row(
                          children: [
                            GestureDetector(
                              onTap: widget.onToggle,
                              child: const Icon(
                                Icons.west,
                                size: 30,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "Create Account",
                          style: kTextTitle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Create a new account", style: kDescription),
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
                                  controller: _textNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Name',
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  onChanged: (values) =>
                                      setState(() => name = values),
                                  validator: (values) =>
                                      values!.isEmpty ? "Enter name" : null,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
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
                                  controller: _textPhoneController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Phone Number',
                                    prefixIcon: Icon(Icons.call),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  onChanged: (values) =>
                                      setState(() => phoneNumber = values),
                                  validator: (values) =>
                                      values!.isEmpty ? "Enter phone" : null,
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
                                TextFormField(
                                    obscureText: true,
                                    controller: _textConfirmPasswordController,
                                    decoration: const InputDecoration(
                                      hintText: 'Confirm Password',
                                      prefixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    onChanged: (values) => setState(
                                        () => confirmPassword = values),
                                    validator: (values) {
                                      if (values!.isEmpty) {
                                        return "Enter the confirm password";
                                      }
                                      if (confirmPassword != password) {
                                        return "Confirm password does not matched";
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => isLoading = true);
                                      final dynamic res =
                                          await authResource.authSignUp(
                                        context: context,
                                        name: name,
                                        email: email,
                                        phoneNumber: int.parse(phoneNumber),
                                        password: password,
                                        confirmPassword: confirmPassword,
                                      );
                                      if (res != null) {
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
                                      "Create account".toUpperCase(),
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
                                        "Already have an account?",
                                        style: TextStyle(fontFamily: "Barlow"),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: widget.onToggle,
                                        child: const Text(
                                          "Login",
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
