import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master_validator/master_validator.dart';
import 'package:music_player/screens/tabs/tabs.dart';
import 'package:music_player/widgets/background_gradient.dart';
import 'package:music_player/widgets/input.dart';
import 'package:music_player/widgets/space.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  int authStep = 0;
  bool newAccount = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xff0E0E0E),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        primaryColor: authStep == 0 ? Colors.black : null,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: authStep == 1
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          authStep = 0;
                        });
                      },
                    )
                  : null,
            ),
            Expanded(
              child: PageTransitionSwitcher(
                reverse: authStep == 0,
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return SharedAxisTransition(
                    fillColor: Colors.transparent,
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    child: child,
                  );
                },
                child: authStep == 0
                    ? AuthStepOne(
                        emailController: emailController,
                        onContinue: (isNewAccount) {
                          setState(() {
                            newAccount = isNewAccount;
                            authStep = 1;
                          });
                        },
                      )
                    : AuthStepTwo(
                        newAccount: newAccount,
                        emailController: emailController,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthStepOne extends StatefulWidget {
  final void Function(bool isNewAccount) onContinue;
  final TextEditingController emailController;
  const AuthStepOne(
      {super.key, required this.onContinue, required this.emailController});

  @override
  State<AuthStepOne> createState() => _AuthStepOneState();
}

class _AuthStepOneState extends State<AuthStepOne> {
  GlobalKey<FormState> form1Key = GlobalKey<FormState>();
  bool _loading = false;

  void authStepOneHandler() {
    if (form1Key.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      checkEmail();
    }
  }

  Future<void> checkEmail() async {
    bool isNewAccount = false;
    // check if email exists in the database
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: widget.emailController.text)
        .get();
    if (snapshot.docs.isNotEmpty) {
      isNewAccount = false;
    } else {
      isNewAccount = true;
    }
    setState(() {
      _loading = false;
    });
    widget.onContinue(isNewAccount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        const Text(
          "Welcome to Musicx",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          "Get your music on the go!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(.5),
          ),
        ),
        Space.v(50),
        Form(
          key: form1Key,
          child: Input(
            label: "Enter your email",
            keyboardType: TextInputType.emailAddress,
            controller: widget.emailController,
            validator: Validators.Required(
              errorMessage: "Please enter a valid email",
              next: Validators.Email(
                errorMessage: "Please enter a valid email",
              ),
            ),
          ),
        ),
        Space.v(20),
        Space.v(100),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: authStepOneHandler,
          child: _loading
              ? Transform.scale(
                  scale: .5,
                  child: const CircularProgressIndicator(),
                )
              : const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        const Spacer(),
      ],
    );
  }
}

class AuthStepTwo extends StatefulWidget {
  final bool newAccount;
  final TextEditingController emailController;
  const AuthStepTwo(
      {super.key, this.newAccount = false, required this.emailController});

  @override
  State<AuthStepTwo> createState() => _AuthStepTwoState();
}

class _AuthStepTwoState extends State<AuthStepTwo> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  GlobalKey<FormState> form2Key = GlobalKey<FormState>();
  bool loading = false;

  void authStepTwoHandler() {
    if (form2Key.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      // create account
      if (widget.newAccount) {
        createAccount();
      } else {
        login();
      }
    }
  }

  void createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "email": widget.emailController.text.trim(),
        "username": usernameController.text.trim(),
      });
      Navigator.of(context).pushReplacementNamed(TabScreen.routeName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        loading = false;
      });
    }
  }

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacementNamed(TabScreen.routeName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text(
          "Welcome to Musicx",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          widget.newAccount ? "Create a new account" : "Welcome back!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(.5),
          ),
          textAlign: TextAlign.center,
        ),
        Space.v(50),
        Form(
          key: form2Key,
          child: Column(
            children: [
              Input(
                label: widget.newAccount
                    ? "Create new password"
                    : "Enter your password",
                obscureText: true,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: Validators.Required(
                  errorMessage: "Please enter a valid password",
                  next: Validators.MinLength(
                    length: 6,
                    errorMessage: "Password must be at least 6 characters",
                  ),
                ),
              ),
              Space.v(20),
              if (widget.newAccount) ...[
                Input(
                  label: "Username",
                  keyboardType: TextInputType.text,
                  controller: usernameController,
                  validator: Validators.Required(
                      errorMessage: "Please enter a valid username"),
                ),
                Space.v(20),
              ],
            ],
          ),
        ),
        Space.v(100),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: authStepTwoHandler,
            child: loading
                ? Transform.scale(
                    scale: .5,
                    child: const CircularProgressIndicator(),
                  )
                : Text(
                    widget.newAccount ? "Create Account" : "Login",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
