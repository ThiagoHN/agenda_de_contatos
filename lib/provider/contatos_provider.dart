import 'package:agenda_de_contatos/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ContatosProvider with ChangeNotifier {
  FirebaseFirestore storage = FirebaseFirestore.instance;
  List<Contato> _items = [];
  final mainCollection = 'usuarios';
  final subCollection = 'contatos';

  String idUsuario;

  ContatosProvider();
  ContatosProvider.logado(this.idUsuario);

  List<Contato> get items {
    return [..._items];
  }

  Contato find(String id) =>
      _items.firstWhere((element) => element.idContact == id);

  Future<void> getDados() async {
    final allContacts = await storage
        .collection(mainCollection)
        .doc(idUsuario)
        .collection(subCollection)
        .get();
    final userContacts = allContacts.docs;
    if (userContacts.length == 0) return;
    _items = userContacts.map((e) {
      final contactData = e.data();
      return Contato(e.id, contactData['nome'], contactData['email'],
          contactData['endereco'], contactData['cep'], contactData['telefone']);
    }).toList();
    notifyListeners();
  }

  Future<void> add(String nome, String email, String endereco, String cep,
      String telefone) async {
    final contatoID = DateTime.now().toIso8601String();
    await storage
        .collection(mainCollection)
        .doc(idUsuario)
        .collection(subCollection)
        .doc(contatoID)
        .set({
      'nome': nome,
      'email': email,
      'endereco': endereco,
      'cep': cep,
      'telefone': telefone
    });

    Contato novaConta =
        Contato(contatoID, nome, email, endereco, cep, telefone);
    _items.add(novaConta);
    notifyListeners();
  }

  Future<void> remove(Contato contatoSelecionado) async {
    _items.remove(contatoSelecionado);
    await storage
        .collection(mainCollection)
        .doc(idUsuario)
        .collection(subCollection)
        .doc(contatoSelecionado.idContact)
        .delete();
    notifyListeners();
  }

  Future<void> update(Contato contatoSelecionado) async {
    final contaIndex = _items.indexWhere(
        (element) => element.idContact == contatoSelecionado.idContact);
    if (contaIndex == -1) return false;
    _items[contaIndex] = contatoSelecionado;
    await storage
        .collection(mainCollection)
        .doc(idUsuario)
        .collection(subCollection)
        .doc(contatoSelecionado.idContact)
        .update({
      'nome': contatoSelecionado.nome,
      'email': contatoSelecionado.email,
      'endereco': contatoSelecionado.endereco,
      'cep': contatoSelecionado.cep,
      'telefone': contatoSelecionado.telefone
    });
    notifyListeners();
  }
}
