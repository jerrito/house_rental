import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_rental/core/size/sizes.dart';
import 'package:house_rental/core/spacing/whitspacing.dart';
import 'package:house_rental/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:house_rental/src/authentication/presentation/pages/phone_number_page.dart';
import 'package:house_rental/src/authentication/presentation/widgets/default_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

buildLogoutBottomSheet(
  BuildContext context,
  AuthenticationBloc authBloc,
  String id,
  String uid,
  String phoneNumber,
  String firstName,
  String lastName,
  String email,
) {
  return showModalBottomSheet(
      context: context,
      builder: ((context) {
        return Container(
            height: 200,
            padding: EdgeInsets.all(Sizes().width(context, 0.04)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Space().height(context, 0.02),
                const Text("Log out of your account"),
                Space().height(context, 0.04),
                BlocConsumer(
                    bloc: authBloc,
                    listener: (context, state) async {
                      const uidKey = "UIDKey";
                      const phoneNumber = "phoneNumber";
                      final preferences = await SharedPreferences.getInstance();
                      if (state is UpdateUserError) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage)));
                      }

                      if (state is UpdateUserLoaded) {
                        // context.pop();
                        // context.goNamed("signin");

                        preferences.setString(uidKey, uid);
                        preferences.setString(phoneNumber, phoneNumber);

                        if (!context.mounted) return;
                        GoRouter.of(context).goNamed("signin");
                      }
                    },
                    builder: (context, state) {
                      if (state is UpdateUserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return DefaultButton(
                          label: "Log out",
                          onPressed: () {
                            Map<String, dynamic> params = {
                              "id": id,
                              "uid": null,
                              "first_name": firstName,
                              "last_name": lastName,
                              "email": email,
                              "phone_number": phoneNumber,
                            };
                            authBloc.add(UpdateUserEvent(params: params));
                          });
                    }),
                Space().height(context, 0.02),
                DefaultButton(
                    label: "Cancel",
                    onPressed: () {
                      context.pop();
                    })
              ],
            ));
      }));
}
