import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/provider/contatos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CriadorContato extends StatefulWidget {
  final Contato c;

  CriadorContato({this.c});

  @override
  _CriadorContato createState() => _CriadorContato();
}

class _CriadorContato extends State<CriadorContato> {
  final GlobalKey<FormState> globalKey = GlobalKey();

  String nome = '';
  String email = '';
  String endereco = '';
  String cep = '';
  String telefone = '';
  bool atualizar = false;

  void initState() {
    super.initState();
    if (widget.c != null) {
      nome = widget.c.nome;
      email = widget.c.email;
      endereco = widget.c.endereco;
      cep = widget.c.cep;
      telefone = widget.c.telefone;
      atualizar = true;
    }
  }

  criarContato() async {
    if (!globalKey.currentState.validate()) return false;
    globalKey.currentState.save();

    if (!atualizar)
      await Provider.of<ContatosProvider>(context, listen: false)
          .add(nome, email, endereco, cep, telefone);
    else {
      widget.c.nome = nome;
      widget.c.email = email;
      widget.c.endereco = endereco;
      widget.c.cep = cep;
      widget.c.telefone = telefone;

      await Provider.of<ContatosProvider>(context, listen: false)
          .update(widget.c);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(atualizar ? 'Modificar contato' : 'Inserir contato'),
      ),
      body: Form(
          key: globalKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: nome,
                    decoration: InputDecoration(
                        labelText: 'Nome',
                        icon: Icon(Icons.person),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      nome = value;
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: email,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: endereco,
                    decoration: InputDecoration(
                        labelText: 'Endereço',
                        icon: Icon(Icons.location_city),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      endereco = value;
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: cep,
                    decoration: InputDecoration(
                        labelText: 'CEP',
                        icon: Icon(Icons.add_location),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    onSaved: (value) {
                      cep = value;
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: telefone,
                    decoration: InputDecoration(
                        labelText: 'Telefone',
                        icon: Icon(Icons.phone_android),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      telefone = value;
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: criarContato, child: Text('Confirmar'))
                ],
              ),
            ),
          )),
    );
  }
}
