import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx/views/widgets/botao_customizado.dart';
import 'package:olx/views/widgets/input_customizado.dart';

class ScreenLogin extends StatefulWidget {
  @override
  _ScreenLoginState createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {

  bool _cadastrar = false;
  TextEditingController _controllerEmail = TextEditingController( text: "lindem@gmx.com");
  TextEditingController _controllerSenha = TextEditingController( text: "123456");
  String _mensagemErro = "";

  _cadastrarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((User){
      //redirecionar tela Principal
      Navigator.pushReplacementNamed(context, "/");
    });

  }

  _iniciar ()async{

  }

  _logarUsuario(Usuario usuario){
     FirebaseAuth auth = FirebaseAuth.instance;
     auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((user){
       Navigator.pushReplacementNamed(context, "/");
     });





      //redirecionar tela Principal


  }

  _validarCampos(){
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.length> 6 && email.contains("@") && email.contains(".")){
      if(senha.isNotEmpty && senha.length>5){
        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;


        if(_cadastrar){
          //Cadastrar
          _cadastrarUsuario(usuario);
        }
        else{
          //logar
          _logarUsuario(usuario);
        }
      }
      else{
        setState(() {
          _mensagemErro = "Senha com ao menos 6 caracteres";
        });
      }

    }
    else{
      setState(() {
        _mensagemErro = "Email inválido";
      });
    }

  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iniciar ();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset("images/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                InputCustomizado(
                    controller: _controllerEmail,
                    hint: "Email",
                    autofocus: true,
                    type: TextInputType.emailAddress,
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15,bottom: 10),
                  child:  InputCustomizado(
                    controller: _controllerSenha,
                    hint: "Senha",
                    obscure: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Logar"),
                    Switch(
                        value: _cadastrar,
                        onChanged: (bool valor){
                          setState(() {
                            _cadastrar = valor;
                          });
                        },
                    ),
                    Text("Cadastrar"),
                  ],
                ),
                BotaoCustomizado(texto: _cadastrar? "Cadastrar" : "Logar",
                    onPressed: _validarCampos,
                ),

                FlatButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, "/");
                    },
                    child: Text("Ir para anúncios")
                ),



                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
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
