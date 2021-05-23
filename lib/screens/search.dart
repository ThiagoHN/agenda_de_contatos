import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/provider/contatos_provider.dart';
import 'package:agenda_de_contatos/screens/criadorcontato.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CurrentPage { sugestao, resultado }

class Search extends SearchDelegate<Contato> {
  CurrentPage paginaAtual = CurrentPage.sugestao;
  Contato contatoSelecionado;

  @override
  String get searchFieldLabel => 'Pesquisar';

  @override
  List<Widget> buildActions(BuildContext context) {
    return paginaAtual == CurrentPage.sugestao
        ? [
            IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  query = '';
                })
          ]
        : [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          if (paginaAtual == CurrentPage.sugestao)
            Navigator.of(context).pop();
          else {
            paginaAtual = CurrentPage.sugestao;
            showSuggestions(context);
          }
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (contatoSelecionado == null)
      return Center(child: Text('Nenhum resultado encontrado'));
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Column(
        children: [
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
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute<void>(
                                  builder: (context) => CriadorContato(
                                        c: contatoSelecionado,
                                      ))),
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
                          paginaAtual = CurrentPage.sugestao;
                          showSuggestions(context);
                        },
                        child: CircleAvatar(child: Icon(Icons.delete)),
                      ),
                      Text('Deletar')
                    ],
                  ),
                ]),
          )
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<ContatosProvider>(
      builder: (ctx, contatos, _) {
        List<Contato> contatosFiltrados = [];
        if (query.isNotEmpty)
          contatosFiltrados = contatos.items
              .where((element) => element.nome.startsWith(query))
              .toList();
        else
          contatosFiltrados = contatos.items;
        if (contatosFiltrados.length > 0)
          contatoSelecionado = contatosFiltrados[0];
        return ListView.builder(
          itemCount: contatosFiltrados.length,
          itemBuilder: (ctx, index) => ListTile(
            leading: CircleAvatar(),
            title: Text(contatosFiltrados[index].nome),
            subtitle: Text(contatosFiltrados[index].telefone),
            trailing: GestureDetector(
                onTap: () async {
                  await Provider.of<ContatosProvider>(context, listen: false)
                      .remove(contatosFiltrados[index]);
                },
                child: Icon(Icons.delete)),
            onTap: () {
              contatoSelecionado = contatosFiltrados[index];
              paginaAtual = CurrentPage.resultado;
              showResults(context);
            },
          ),
        );
      },
    );
  }
}
