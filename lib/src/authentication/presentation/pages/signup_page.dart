// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:go_router/go_router.dart';
import 'package:house_rental/core/size/sizes.dart';
import 'package:house_rental/core/spacing/whitspacing.dart';
import 'package:house_rental/core/widgets/bottom_sheet.dart';
import 'package:house_rental/locator.dart';
import 'package:house_rental/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:house_rental/src/authentication/presentation/widgets/default_textfield.dart';
import 'package:house_rental/src/home/presentation/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  final String phoneNumber;
  const SignupPage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final authBloc = locator<AuthenticationBloc>();
  final auth = FirebaseAuth.instance;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Signup"),
        ),
        bottomSheet: bottomSheetButton(
          context: context,
          label: "Signup",
          onPressed: () {
            var bites=utf8.encode(passwordController.text);
            var password=sha512.convert(bites);
            final users = {
              "first_name": firstNameController.text,
              "last_name": lastNameController.text,
              "email": emailController.text,
              "phone_number": widget.phoneNumber,
              "id": "",
              "password":password.toString(),
              "token": auth.currentUser?.uid ?? "",
            };
            debugPrint(auth.currentUser?.refreshToken);
            authBloc.add(
              SignupEvent(users: users),
            );
          },
        ),
        body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is GenericError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
              
              if (state is SignupLoaded) {
                //GoRouter.of(context).go(location)
                GoRouter.of(context).pushReplacementNamed("homePage");
              
              }
            },
            builder: (context, state) {
              if (state is SignupLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Sizes().height(context, 0.02)),
                  child: Column(
                    children: [
                      //firstName
                      DefaultTextfield(
                        controller: firstNameController,
                        label: "First Name",
                        hintText: "Enter your first name",
                      ),

                      //last Name
                      DefaultTextfield(
                        controller: lastNameController,
                        label: "Last Name",
                        hintText: "Enter your last name",
                      ),

                      //email
                      DefaultTextfield(
                        controller: emailController,
                        label: "Email",
                        hintText: "Enter your email",
                      ),

                      //email
                      DefaultTextfield(
                        controller: passwordController,
                        label: "Password",
                        hintText: "Enter your password",
                      ),


                      Space().height(context, 0.02),
                    ],
                  ),
                ),
              );
            }));
  }
}
