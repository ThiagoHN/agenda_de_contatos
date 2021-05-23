import 'package:agenda_de_contatos/provider/usuarios_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static const routeName = 'Tela_principal';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> globalKey = GlobalKey();
  final TextEditingController controleSenha = TextEditingController();
  final TextEditingController controleConfirmaSenha = TextEditingController();
  var formmap = {'nome': '', 'email': '', 'senha': '', 'confirmarsenha': ''};

  bool esta_logando = true;
  bool carregando = false;

  _logar() async {
    if (globalKey.currentState.validate()) {
      globalKey.currentState.save();
      bool resultado = false;
      setState(() {
        carregando = true;
      });

      if (esta_logando) {
        resultado = await Provider.of<UsuarioProvider>(context, listen: false)
            .logar(formmap['email'], formmap['senha']);

        if (!resultado) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Os dados estão inválidos')));
        }
      } else {
        resultado = await Provider.of<UsuarioProvider>(context, listen: false)
            .registrar(formmap['nome'], formmap['email'], formmap['senha']);

        if (!resultado) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Deu ruim menor')));
        }
      }

      setState(() {
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.green[700],
                Colors.blue[500],
              ],
            )),
          ),
          Center(
            child: Card(
              elevation: 4,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: [
                        Text(
                          'Agenda de Contatos',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (!esta_logando)
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nome'),
                            onSaved: (value) {
                              formmap['nome'] = value.trim();
                            },
                          ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Email'),
                          onSaved: (value) {
                            formmap['email'] = value.trim();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Campo obrigatório, por favor insira seu email!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: true,
                          controller: controleSenha,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Senha'),
                          onSaved: (value) {
                            formmap['senha'] = value.trim();
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Campo obrigatório, por favor insira sua senha!';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        if (!esta_logando)
                          TextFormField(
                            obscureText: true,
                            controller: controleConfirmaSenha,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Confirmar senha'),
                            onSaved: (value) {
                              formmap['confirmarsenha'] = value.trim();
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Campo obrigatório, por favor insira sua senha!';
                              if (value != controleSenha.text)
                                return 'As duas senhas não são iguais, por favor insira sua senha!';
                              return null;
                            },
                          ),
                        const SizedBox(height: 20),
                        Container(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: _logar,
                              child: carregando
                                  ? CircularProgressIndicator()
                                  : Text(
                                      esta_logando ? 'Acessar' : 'Cadastrar')),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () => setState(() {
                                    esta_logando = !esta_logando;
                                  }),
                              child:
                                  Text(esta_logando ? 'Registrar' : 'Voltar')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
