import 'package:flutter/material.dart';
import 'package:flutter_capstone/core/init/utils/shared_preferences.dart';
import 'package:flutter_capstone/screens/login/login_screen.dart';
import 'package:flutter_capstone/screens/login/widget/text_or_widget.dart';
import 'package:flutter_capstone/style/text_style.dart';
import 'package:flutter_capstone/screens/sign_up/sign_up_screen.dart';
import 'package:flutter_capstone/services/signup/signup_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../signup_view_model.dart';

class FormSignup extends StatefulWidget {
  const FormSignup({super.key});

  @override
  State<FormSignup> createState() => _FormSignupState();
}

class _FormSignupState extends State<FormSignup> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SignupViewModel signupViewModel = Provider.of<SignupViewModel>(context);
    bool getObsecureText = signupViewModel.getObsecureText;

    return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            //form name
            TextFormField(
              controller: signupViewModel.getUsername,
              validator: (value) {
                if (value != null && value.length < 5) {
                  return 'Enter min. 4 characters';
                }
                return null; //form is valid
              },
              decoration: InputDecoration(
                labelText: 'Nama',
                hintStyle: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                hintText: 'Input Full Name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            // Form Login
            //========================================================
            // Input Email
            //========================================================
            TextFormField(
              controller: signupViewModel.getEmail,
              validator: (email) {
                // 5 install package email_validator
                if (email != null && !EmailValidator.validate(email)) {
                  return 'Enter a valid email';
                }
                return null; //form is valid
              },
              decoration: InputDecoration(
                labelText: 'Email',
                hintStyle: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                hintText: 'Input Email',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25.0),
            // Input Password
            //========================================================
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: signupViewModel.getPassword,
              validator: (value) {
                if (value != null && value.length < 5) {
                  return 'Enter min. 5 characters';
                }
                return null; //form is valid
              },
              decoration: InputDecoration(
                labelText: 'Password',
                hintStyle: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    getObsecureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    signupViewModel
                        .setTogglePasswordVisibility(!getObsecureText);
                  },
                ),
                hintText: 'Input Password',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),

            //confirmpassword
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: signupViewModel.getconfirmPasswordController,
              validator: (value) {
                if (value != null && value.length < 5) {
                  return 'Enter min. 5 characters';
                } else if (value != signupViewModel.getPassword.text) {
                  return 'Password didn\'t match';
                }
                return null; //form is valid
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintStyle: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    getObsecureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    signupViewModel
                        .setTogglePasswordVisibility(!getObsecureText);
                  },
                ),
                hintText: 'Input Password Again',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),

            // CheckBox remember me
            //========================================================
            Row(
              children: <Widget>[
                SizedBox(
                  width: 24,
                  child: Checkbox(
                      value: signupViewModel.getChecked,
                      onChanged: (bool? val) {
                        signupViewModel.setChecked = val!;
                      }),
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  'I Agree with Terms and Condition',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),

            // Button Login
            //========================================================
            FractionallySizedBox(
              widthFactor: 1.0,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF005DB9)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(100), // Bentuk border
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      var res = await SignUpService().postSignup(
                        email: signupViewModel.getEmail.text,
                        password: signupViewModel.getPassword.text,
                        username: signupViewModel.getPassword.text,
                      );
                      if (res['meta']['is_error'] == false) {
                        // ignore: use_build_context_synchronously
                        return showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: FractionallySizedBox(
                                  heightFactor: 0.4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 127.5,
                                        height: 130,
                                        child:
                                            Image.asset('assets/retro_mac.png'),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 8)),
                                      Text(
                                        'Akunmu berhasil dibuat!',
                                        style: setTextStyle(
                                                NeutralColor().neutral17)
                                            .copyWith(
                                                fontSize: 16,
                                                fontWeight: semiBold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 6, bottom: 16),
                                        child: Text(
                                          'Selamat akun kamu berhasil dibuat! Silahkan\nlogin untuk masuk ke Office Buddy!',
                                          textAlign: TextAlign.center,
                                          style: setTextStyle(
                                                  NeutralColor().neutral17)
                                              .copyWith(
                                            fontSize: 12,
                                            fontWeight: regular,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/login',
                                                (route) => false);
                                          },
                                          style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    PrimaryColor().primary),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100), // Bentuk border
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            'Login',
                                            style: setTextStyle(
                                                    PrimaryColor().onPrimary)
                                                .copyWith(
                                              fontSize: 14,
                                              fontWeight: semiBold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    } else {
                      null;
                    }
                  }
                  // ? () async {

                  //     var res = await SignUpService().postSignup(
                  //       email: signupViewModel.getEmail.text,
                  //       password: signupViewModel.getPassword.text,
                  //       username: signupViewModel.getPassword.text,
                  //     );
                  //     if (res['meta']['is_error'] == false) {
                  //       // ignore: use_build_context_synchronously
                  //       return showModalBottomSheet(
                  //           context: context,
                  //           isScrollControlled: true,
                  //           builder: (context) {
                  //             return Padding(
                  //               padding: const EdgeInsets.all(16),
                  //               child: FractionallySizedBox(
                  //                 heightFactor: 0.4,
                  //                 child: Column(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.center,
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.center,
                  //                   children: [
                  //                     SizedBox(
                  //                       width: 127.5,
                  //                       height: 130,
                  //                       child: Image.asset(
                  //                           'assets/retro_mac.png'),
                  //                     ),
                  //                     const Padding(
                  //                         padding: EdgeInsets.only(top: 8)),
                  //                     Text(
                  //                       'Akunmu berhasil dibuat!',
                  //                       style: setTextStyle(
                  //                               NeutralColor().neutral17)
                  //                           .copyWith(
                  //                               fontSize: 16,
                  //                               fontWeight: semiBold),
                  //                     ),
                  //                     Padding(
                  //                       padding: const EdgeInsets.only(
                  //                           top: 6, bottom: 16),
                  //                       child: Text(
                  //                         'Selamat akun kamu berhasil dibuat! Silahkan\nlogin untuk masuk ke Office Buddy!',
                  //                         textAlign: TextAlign.center,
                  //                         style: setTextStyle(
                  //                                 NeutralColor().neutral17)
                  //                             .copyWith(
                  //                           fontSize: 12,
                  //                           fontWeight: regular,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       width: double.infinity,
                  //                       height: 50,
                  //                       child: ElevatedButton(
                  //                         onPressed: () {
                  //                           Navigator
                  //                               .pushNamedAndRemoveUntil(
                  //                                   context,
                  //                                   '/login',
                  //                                   (route) => false);
                  //                         },
                  //                         style: ButtonStyle(
                  //                           elevation:
                  //                               MaterialStateProperty.all(
                  //                                   0),
                  //                           backgroundColor:
                  //                               MaterialStateProperty.all(
                  //                                   PrimaryColor().primary),
                  //                           shape:
                  //                               MaterialStateProperty.all<
                  //                                   RoundedRectangleBorder>(
                  //                             RoundedRectangleBorder(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(
                  //                                       100), // Bentuk border
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         child: Text(
                  //                           'Login',
                  //                           style: setTextStyle(
                  //                                   PrimaryColor()
                  //                                       .onPrimary)
                  //                               .copyWith(
                  //                             fontSize: 14,
                  //                             fontWeight: semiBold,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //             );
                  //           });
                  //     } else {
                  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //           content: Text(
                  //         '${res['meta']['message']}',
                  //         style: setTextStyle(SourceColor().white),
                  //       )));
                  //     }
                  //   }
                  // : null,
                  ,
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.roboto(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            // Style untuk text OR
            //========================================================
            const TextOr(),

            // Button Login
            //========================================================
            const SizedBox(height: 10.0),
            FractionallySizedBox(
              widthFactor: 1.0,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFF292A2D)),
                        borderRadius:
                            BorderRadius.circular(100), // Bentuk border
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/img/google.svg'),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Continue With Google',
                        style:
                            GoogleFonts.roboto(color: const Color(0xFF292A2D)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
