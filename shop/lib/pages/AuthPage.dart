import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/exceptions.dart';
import 'package:shop/providers/auth.dart';



enum AuthMode {SignUp, Login }

class AuthPage extends StatelessWidget {


  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 34),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
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
                      child: const Text('Мой магазин', style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                      ),),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
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

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': ''
  };
  late bool _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<Size> _heightAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _heightAnimation = Tween<Size>(begin: const Size(double.infinity,260), end: const Size(double.infinity, 320)).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _controller.addListener(() {setState(() {});});
    _opacityAnimation = Tween<double>(begin: 0, end:  1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic));
    _offsetAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: const Offset(0, 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showDialogError (String message) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Внимание'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => {
            Navigator.of(ctx).pop(),
          }, 
          child: const Text('Ok'),
          ),
      ],
    ));
  }

  Future<void> _submit () async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).signIn(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(_authData['email'], _authData['password']);
      }
      
    } on HttpException catch (error) {
      var messageError = 'Ошибка авторизации';
      if (error.toString().contains('EMAIL_EXISTS')) {
        messageError = 'Такой адрес электронный почты уже существует!';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        messageError = 'Вы ввели не верный адрес электронной почты';
      } else {

      //...
      // _showDialogError(messageError);
      }
      _showDialogError(messageError);
    }
    catch (error) {
      const messageError = 'Сейчас невозможно авторизироваться в системе. Повторите попытку позднее !';
      _showDialogError(messageError);
      print(messageError);
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
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
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
        constraints: BoxConstraints(
          //minHeight: _authMode == AuthMode.SignUp ? 320 : 260,
          minHeight: _heightAnimation.value.height,
        ),
        width: deviceSize.width * 0.75,
        height: _heightAnimation.value.height,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Электронная почта:'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Неправильно введенная электронная почта !';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Пароль:'),
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Пароль должен содержать не менее 5 символов';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                // if (_authMode == AuthMode.SignUp) 

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    constraints: BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 60 : 0, maxHeight: _authMode == AuthMode.SignUp ? 120 : 0),
                    curve: Curves.fastOutSlowIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.SignUp,
                          decoration: const InputDecoration(
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
                      ),
                    ),
                  ),
                const SizedBox(height: 10,),
                if (_isLoading) 
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(_authMode == AuthMode.Login ? 'Войти' : 'Регистрация'),
                    onPressed: _submit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(
                          color:  Colors.indigo,
                        )
                      ),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 35, vertical: 12),),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),  
                      ),
                    ),
                    )
                  ),
                  const SizedBox(height: 5,),
                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(_authMode == AuthMode.Login ? 'Регистрация' : 'Войти'),
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