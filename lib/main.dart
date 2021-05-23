import 'package:agenda_de_contatos/provider/contatos_provider.dart';
import 'package:agenda_de_contatos/provider/usuarios_provider.dart';
import 'package:agenda_de_contatos/screens/contato_info.dart';
import 'package:agenda_de_contatos/screens/login.dart';
import 'package:agenda_de_contatos/screens/menu.dart';
import 'package:agenda_de_contatos/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UsuarioProvider()),
        ChangeNotifierProxyProvider<UsuarioProvider, ContatosProvider>(
            create: (ctx) => ContatosProvider(),
            update: (ctx, usuarios, contas) =>
                ContatosProvider.logado(usuarios.id)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: Consumer<UsuarioProvider>(
            builder: (ctx, usuarios, _) => usuarios.estaLogado
                ? Menu()
                : FutureBuilder(
                    future: usuarios.loginAutomatico(),
                    builder: (ctx, resultado) =>
                        resultado.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : Login())),
        routes: {
          Login.routeName: (ctx) => Login(),
          Menu.routeName: (ctx) => Menu(),
          ContatoInfo.routeName: (ctx) => ContatoInfo(),
        },
      ),
    );
  }
}
