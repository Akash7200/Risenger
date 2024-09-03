import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:risenger/const.dart';
import 'package:risenger/services/auth_service.dart';
import 'package:risenger/services/media_service.dart';
import 'package:risenger/services/navigation_service.dart';
import 'package:risenger/services/storage_service.dart';
import 'package:risenger/widgets/custom_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt getIt = GetIt.instance;

  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AuthService _authService;
  late StorageService _storageService;

  String? email, password, name;
  File? pfp;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = getIt.get<MediaService>();
    _navigationService = getIt.get<NavigationService>();
    _authService = getIt.get<AuthService>();
    _storageService = getIt.get<StorageService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          _headerText(),
          if(!isLoading) _registerForm(),
          if(!isLoading) _loginAccountLink(),
          if(isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    ));
  }

  Widget _headerText() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: const Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let\'s get started!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "Create an account to get all features",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ));
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.7,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomFormField(
              labelText: "name",
              height: MediaQuery.sizeOf(context).height * 0.15, 
              validationRegEx: NAME_VALIDATION_REGEX, 
              onSaved: (value) {
                setState(
                  () {
                  name = value;
                  },
                );
              },
            ),
            CustomFormField(
              labelText: "email",
              height: MediaQuery.sizeOf(context).height * 0.15, 
              validationRegEx: EMAIL_VALIDATION_REGEX, 
              onSaved: (value) {
                setState(
                  () {
                  email = value;
                  },
                );
              },
            ),
            CustomFormField(
              labelText: "password",
              height: MediaQuery.sizeOf(context).height * 0.15, 
              validationRegEx: PASSWORD_VALIDATION_REGEX, 
              obscureText: true,
              onSaved: (value) {
                setState(
                  () {
                  password = value;
                  },
                );
              },
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? image = await _mediaService.getImageFromGallery();
        if (image != null) {
          setState(() {
            pfp = image;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.09,
        backgroundImage: pfp != null
            ? FileImage(pfp!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }


  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: ElevatedButton(
        onPressed: () async{
          setState(() {
            isLoading = true;
          });
          try {
            if((_registerFormKey.currentState?.validate() ?? false) && pfp != null) {
              _registerFormKey.currentState?.save();
              bool result = await _authService.signup(email!, password!);
              if(result){
                String? pfpURL= await _storageService.uploadUserPfp(
                  file: pfp!,
                  uid: _authService.user!.uid,
                );
              }
            }
          }
           catch (e) {
            print(e);
          }
          setState(() {
            isLoading = false;
          });
        }, 
        child: const Text(
          "Register"
        ),
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Already have an account?'),
          GestureDetector(
            onTap: () {
              _navigationService.goBack();
            },
            child: Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
