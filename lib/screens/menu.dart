import 'package:agenda_de_contatos/provider/contatos_provider.dart';
import 'package:agenda_de_contatos/screens/criadorconta.dart';
import 'package:agenda_de_contatos/provider/usuarios_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  static const routeName = 'menu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => CriadorContato()))),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                  child: DrawerHeader(
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      child: Text('Controlador \n Contas'))),
              ListTile(
                leading: Text('Sair'),
                trailing: Icon(Icons.exit_to_app),
                onTap: () async {
                  Provider.of<UsuarioProvider>(context, listen: false)
                      .logout();
                },
              )
            ],
          ),
        ),
        body: FutureBuilder(
          future:
              Provider.of<ContatosProvider>(context, listen: false).getDados(),
          builder: (ctx, result) => result.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<ContatosProvider>(
                  builder: (ctx, contas, _) => ListView.builder(
                    itemCount: contas.items.length,
                    itemBuilder: (ctx, index) => ListTile(
                      leading: CircleAvatar(),
                      title: Text(contas.items[index].nome),
                      subtitle: Text(contas.items[index].telefone),
                      trailing: GestureDetector(
                          onTap: () async {
                            await Provider.of<ContatosProvider>(context,
                                    listen: false)
                                .remove(contas.items[index]);
                          },
                          child: Icon(Icons.delete)),
                      onTap: () =>
                          Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (context) => CriadorContato(
                                    c: contas.items[index],
                                  ))),
                    ),
                  ),
                ),
        ));
  }
}