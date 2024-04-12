import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/business_logic/auth/auth_cubit.dart';
import 'package:my_chat_app/presentation/pages/home_page.dart';
import 'package:my_chat_app/presentation/widgets/my_text_form_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedIn) {
          // navigate to home page
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 72,
                ),
                // name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    controller: _nameController,
                    hintText: 'Name',
                    validator: (String? value) => value == null || value == ''
                        ? "Your name cannot be empty"
                        : null,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                // phone
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    controller: _phoneController,
                    hintText: 'Phone',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (String? value) => value == null || value == ''
                        ? "Your phone number cannot be empty"
                        : null,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // submit button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        onPressed: () {
                          bool? isValid = _formKey.currentState?.validate();

                          if (isValid == true) {
                            print("Logging in...");

                            final Map<String, String> userMap = {
                              "name": _nameController.text,
                              "phone": _phoneController.text
                            };

                            context.read<AuthCubit>().login(userMap);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text("Login"),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
