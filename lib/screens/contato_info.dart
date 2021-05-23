import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/provider/contatos_provider.dart';
import 'package:agenda_de_contatos/screens/criadorcontato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContatoInfo extends StatelessWidget {
  static const routeName = 'ContatoInfo';
  Contato contatoSelecionado;

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    Contato contatoSelecionado =
        Provider.of<ContatosProvider>(context, listen: false).find(id);
    return Scaffold(
          appBar: AppBar(),
          body: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Column(children: [
            CircleAvatar(child: Text(contatoSelecionado.nome[0])),
            Text(contatoSelecionado.nome),
            Text(contatoSelecionado.email),
            Text(contatoSelecionado.endereco),
            Text(contatoSelecionado.cep),
            Text(contatoSelecionado.telefone),
            Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                            onTap: () async {
                              await Navigator.of(context)
                                .push(MaterialPageRoute<void>(
                                    builder: (context) => CriadorContato(
                                          c: contatoSelecionado,
                                        )));
                                        contatoSelecionado = Provider.of<ContatosProvider>(context, listen: false).find(contatoSelecionado.idContact);
                            },
                            child: CircleAvatar(child: Icon(Icons.person_add))),
                        Text('Atualizar'),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await Provider.of<ContatosProvider>(context,
                                    listen: false)
                                .remove(contatoSelecionado);
                                Navigator.of(context).pop(context);
                          },
                          child: CircleAvatar(child: Icon(Icons.delete)),
                        ),
                        Text('Deletar')
                      ],
                    ),
                  ]),
            )
          ])),
    );
  }
}
