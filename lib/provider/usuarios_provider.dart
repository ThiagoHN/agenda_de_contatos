import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UsuarioProvider with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _nome;
  String _email;
  String _id;
  bool logado = false;
  final collectionName = 'usuarios';

  bool get estaLogado => logado;

  String get id {
    if (_id == null) return '-1';
    return _id;
  }

  Map<String, String> get usuarioSelecionado {
    return {'id': _id, 'nome': _nome, 'email': _email};
  }

  Future<bool> logar(String email, String senha) async {
    UserCredential credentials =
        await auth.signInWithEmailAndPassword(email: email, password: senha);
    final user = credentials.user;
    if (user == null) return false;
    final userData = await fetchUserData(user.uid);
    final data = userData.data() as Map<String, dynamic>;

    _nome = data['nome'];
    _email = data['email'];
    _id = user.uid;

    logado = true;
    notifyListeners();
    return true;
  }

  Future<bool> registrar(String nome, String email, String senha) async {
    UserCredential credentials = await auth.createUserWithEmailAndPassword(
        email: email, password: senha);
    final user = credentials.user;
    if (user.uid == null) return false;

    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(user.uid)
        .set({'nome': nome, 'email': email});

    _nome = nome;
    _email = email;
    _id = user.uid;

    logado = true;
    notifyListeners();
    return true;
  }

  Future<bool> loginAutomatico() async {
    final user = auth.currentUser;
    if (user == null) return false;

    if (!logado) {
      final userData = await fetchUserData(user.uid);
      final data = userData.data() as Map<String, dynamic>;

      _nome = data['nome'];
      _email = data['email'];
      _id = user.uid;
    }

    logado = true;
    notifyListeners();
    return true;
  }

  Future<DocumentSnapshot> fetchUserData(String id) async {
    return await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .get();
  }

  void logout() {
    _nome = '';
    _email = '';
    _id = '';
    logado = false;
    auth.signOut();
    notifyListeners();
  }
}
