// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:multivendor_ecommerce_riverbod/controllers/authcontroller.dart';
// import 'package:multivendor_ecommerce_riverbod/views/screens/authanticationscreen/register_screen.dart';

// class Loginscreen extends StatefulWidget {
//   @override
//   State<Loginscreen> createState() => _LoginscreenState();
// }

// class _LoginscreenState extends State<Loginscreen> {
//   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

//   final Authcontroller _authcontroller = Authcontroller();

//   late String email;

//   late String password;

//   bool isloading = false;

//   loginuser() async {
//     setState(() {
//       isloading = true;
//     });
//     await _authcontroller
//         .sigininuser(context: context, email: email, password: password, ref: null)
//         .whenComplete(() {
//           setState(() {
//             isloading = false;
//           });
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white.withOpacity(0.9),
//         body: Center(
//           child: SingleChildScrollView(
//             child: Form(
//               key: _formkey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "login your account",
//                     style: TextStyle(
//                       color: Color(0xFF0d120E),
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.2,
//                       fontSize: 23,
//                     ),
//                   ),
//                   const Text(
//                     'to explor the world exclusives',
//                     style: TextStyle(
//                       color: Color(0xFF0d120E),
//                       fontSize: 14,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                   Image.asset(
//                     'assets/images/Illustration.png',
//                     width: 200,
//                     height: 200,
//                   ),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       'Email',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.2,
//                       ),
//                     ),
//                   ),
//                   TextFormField(
//                     onChanged: (value) {
//                       email = value;
//                     },
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'enter your full email';
//                       } else {
//                         return null;
//                       }
//                     },
//                     decoration: InputDecoration(
//                       fillColor: Colors.white,
//                       filled: true,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(9),
//                       ),
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       labelText: 'enter your email',
//                       labelStyle: TextStyle(fontSize: 14, letterSpacing: 0.1),
//                       prefixIcon: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Image.asset(
//                           'assets/icons/email.png',
//                           width: 20,
//                           height: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextFormField(
//                     onChanged: (value) {
//                       password = value;
//                     },
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'enter your full password';
//                       } else {
//                         return null;
//                       }
//                     },
//                     keyboardType: TextInputType.number,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       fillColor: Colors.white,
//                       filled: true,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(9),
//                       ),
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       labelText: 'enter your password',
//                       labelStyle: TextStyle(fontSize: 14, letterSpacing: 0.1),
//                       prefixIcon: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Image.asset(
//                           'assets/icons/password.png',
//                           width: 20,
//                           height: 20,
//                         ),
//                       ),
//                       suffixIcon: Icon(Icons.visibility),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   InkWell(
//                     onTap: () async {
//                       if (_formkey.currentState!.validate()) {
//                         loginuser();
//                       }
//                     },
//                     child: Container(
//                       width: 319,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         gradient: LinearGradient(
//                           colors: [Color(0xFF102DE1), Color(0xCC0D6EFF)],
//                         ),
//                       ),
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: 279,
//                             top: 19,
//                             child: Opacity(
//                               opacity: 0.5,
//                               child: Container(
//                                 width: 60,
//                                 height: 60,
//                                 clipBehavior: Clip.antiAlias,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 12,
//                                     color: Color(0xFF103DE5),
//                                   ),
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 260,
//                             top: 29,
//                             child: Opacity(
//                               opacity: 0.5,
//                               child: Container(
//                                 width: 10,
//                                 height: 10,
//                                 clipBehavior: Clip.antiAlias,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     width: 3,
//                                     color: Color(0xFF2141E5),
//                                   ),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 311,
//                             top: 36,

//                             child: Opacity(
//                               opacity: 0.3,
//                               child: Container(
//                                 width: 5,
//                                 height: 5,
//                                 clipBehavior: Clip.antiAlias,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(3),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 281,
//                             top: -10,
//                             child: Opacity(
//                               opacity: 0.3,
//                               child: Container(
//                                 width: 20,
//                                 height: 20,
//                                 clipBehavior: Clip.antiAlias,

//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Center(
//                             child:
//                                 isloading
//                                     ? CircularProgressIndicator(
//                                       color: Colors.white,
//                                     )
//                                     : Text(
//                                       'Sign in',

//                                       style: TextStyle(
//                                         letterSpacing: 0.3,
//                                         fontSize: 18,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,

//                     children: [
//                       Text(
//                         'Need an Account ?',
//                         style: TextStyle(
//                           color: Colors.black.withOpacity(0.5),
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) {
//                                 return Registerscreen();
//                               },
//                             ),
//                           );
//                         },
//                         child: Text(
//                           'SIGN UP',
//                           style: TextStyle(fontSize: 20, color: Colors.blue),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/authcontroller.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/authanticationscreen/register_screen.dart';

class Loginscreen extends ConsumerStatefulWidget {
  const Loginscreen({super.key});

  @override
  ConsumerState<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends ConsumerState<Loginscreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final Authcontroller _authcontroller = Authcontroller();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isloading = false;

  Future<void> loginuser() async {
    setState(() => isloading = true);

    await _authcontroller
        .sigininuser(
          context: context,
          ref: ref,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        )
        .whenComplete(() => setState(() => isloading = false));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login to your account",
                      style: TextStyle(
                        color: Color(0xFF0d120E),
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'To explore the world exclusives',
                      style: TextStyle(color: Color(0xFF0d120E), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/Illustration.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _emailController,
                      validator:
                          (value) => value!.isEmpty ? 'Enter your email' : null,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        labelText: 'Enter your email',
                        labelStyle: TextStyle(fontSize: 14),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/icons/email.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Enter your password' : null,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        labelText: 'Enter your password',
                        labelStyle: TextStyle(fontSize: 14),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/icons/password.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        suffixIcon: Icon(Icons.visibility),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          loginuser();
                        }
                      },
                      child: Container(
                        width: 319,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF102DE1), Color(0xCC0D6EFF)],
                          ),
                        ),
                        child: Stack(
                          children: [
                            const Positioned(
                              left: 279,
                              top: 19,
                              child: Opacity(
                                opacity: 0.5,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xFF103DE5),
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 260,
                              top: 29,
                              child: Opacity(
                                opacity: 0.5,
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Color(0xFF2141E5),
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 311,
                              top: 36,
                              child: Opacity(
                                opacity: 0.3,
                                child: CircleAvatar(
                                  radius: 2.5,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                            const Positioned(
                              left: 281,
                              top: -10,
                              child: Opacity(
                                opacity: 0.3,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                            Center(
                              child:
                                  isloading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          letterSpacing: 0.3,
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Need an Account?',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registerscreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
