import 'package:flutter/material.dart';

import 'dart:math';

enum AuthMode {SignUp, Login }

class AuthPage extends StatelessWidget {
  const AuthPage({ Key? key }) : super(key: key);

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi/180).translate(-10);
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0,1]
              )
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      transform: Matrix4.rotationZ(-8 * pi/180)..translate(-10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black12,
                            offset: Offset(0,2),
                          )
                        ]
                      ),
                      child: Text('Мой магазин', style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                      ),),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 1 : 2,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({ Key? key }) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': ''
  };
  late bool _isLoading = false;
  final _passwordController = TextEditingController();

  void _submit () {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {

    } else {

    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode () {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        height: _authMode ==AuthMode.SignUp ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 320 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Электронная почта:'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Неправильно введенная электронная почта !';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['e-mail'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Пароль:'),
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Слишком легкий пароль, пароль должен содержать не менее 5 символов';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.SignUp) 
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp,
                    decoration: InputDecoration(
                      labelText: 'Подтвердите пароль',
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.SignUp ? 
                      (value) {
                        if (value != _passwordController.text) {
                          return 'Пароль не совпадает !';
                        }
                      } : null,
                  ),
                const SizedBox(height: 20,),
                if (_isLoading) 
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(_authMode == AuthMode.Login ? 'Войти' : 'Регистрация'),
                    onPressed: _submit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                      textStyle: MaterialStateProperty.all(TextStyle(
                        color:  Colors.indigo,
                      )),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 35, vertical: 12),),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),  
                      ),
                    ),
                    )
                  ),
                  SizedBox(height: 15,),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text('${_authMode == AuthMode.Login ? 'Регистрация' : 'Войти'}'),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30, vertical: 4),)
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

