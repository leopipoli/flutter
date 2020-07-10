import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynurse/model/agenda.dart';

import 'model/medicos.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Nurse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.greenAccent[300],
      ),
      home: new Login(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Home(),
        '/Login': (BuildContext context) => new Login(),
        '/Noticias': (BuildContext context) => new Noticias(),
        '/Sobre': (BuildContext context) => new Sobre(),
        '/Perfil': (BuildContext context) => new Perfil(),
        '/Acompanhamento': (BuildContext context) => new Acompanhamento(),
        '/Medicos': (BuildContext context) => new ListaMedicos(),
        '/AlterarAgenda': (BuildContext context) => new AlterarAgenda(),
        '/ConsultarAgenda': (BuildContext context) => new ConsultarAgenda()
      },
    );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 1],
                colors: [
                  Color(0xff19e194),
                  Color(0xff87ceeb),
                ],
              ),
            ),
            accountName: Text("Mickey Mouse"),
            accountEmail: Text("mickey@clinic.com"),
            currentAccountPicture: CircleAvatar(
                radius: 30.0, child: Image.asset("assets/mickey.png")),
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: Text('Notícias'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Noticias()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_ind),
            title: Text('Perfil'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Perfil()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text('Acompanhamento'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Acompanhamento()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.recent_actors),
            title: Text('Sobre'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Sobre()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text('Lista de Médicos'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListaMedicos()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Novidade: Consultar Agenda'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ConsultarAgenda()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Novidade: Agendamentos Online'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AlterarAgenda()),
              );
            },
          ),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: showAlertDialog(context)),
                );
              }),
        ],
      ),
    );
  }
}

class AlterarAgenda extends StatefulWidget {
  @override
  _AlterarAgendaState createState() => _AlterarAgendaState();
}

class _AlterarAgendaState extends State<AlterarAgenda> {
  //controles para os campos de texto
  TextEditingController txtDia = TextEditingController();
  TextEditingController txtMes = TextEditingController();
  TextEditingController txtMedico = TextEditingController();

  //instância do Firebase
  var db = Firestore.instance;

  //retornar dados do documento a partir do idDocument
  void getDocumento(String idDocumento) async {
    //Recuperar o documento no Firestore
    DocumentSnapshot doc =
        await db.collection("agenda").document(idDocumento).get();

    setState(() {
      txtDia.text = doc.data["dia"].toString();
      txtMes.text = doc.data["mes"];
      txtMedico.text = doc.data["medico"];
    });
  }

  @override
  Widget build(BuildContext context) {
//
    // RECUPERAR o ID do Documento
    //
    final String idDocumento = ModalRoute.of(context).settings.arguments;

    if (idDocumento != null) {
      if (txtDia.text == "" && txtMes.text == "" && txtMedico.text == "") {
        getDocumento(idDocumento);
      }
    }

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Editar Consulta'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color(0xff19e194),
                Color(0xff87ceeb),
              ])),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            //CAMPO DIA
            TextField(
              controller: txtDia,
              style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Dia",
              ),
            ),
            SizedBox(
              height: 20,
            ),

            //CAMPO MES
            TextField(
              controller: txtMes,
              style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Mês",
              ),
            ),
            SizedBox(
              height: 30,
            ),

            //CAMPO MEDICO
            TextField(
              controller: txtMedico,
              style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                labelText: "Médico",
              ),
            ),
            SizedBox(
              height: 30,
            ),

            //BOTÕES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: RaisedButton(
                    color: Colors.green[500],
                    child: Text("salvar",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () {
                      //
                      // Inserir ou Atualizar
                      //
                      if (idDocumento == null) {
                        inserir(
                            context,
                            Agenda(idDocumento, int.parse(txtDia.text),
                                txtMes.text, txtMedico.text));
                      } else {
                        atualizar(
                            context,
                            Agenda(idDocumento, int.parse(txtDia.text),
                                txtMes.text, txtMedico.text));
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 120,
                  child: RaisedButton(
                    color: Colors.red[500],
                    child: Text("cancelar",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //
  // ATUALIZAR
  //
  void atualizar(BuildContext context, Agenda agenda) async {
    await db
        .collection("agenda")
        .document(agenda.id)
        .updateData({"dia": agenda.dia, "mes": agenda.mes});
    Navigator.pop(context);
  }

  //
  // INSERIR
  //
  void inserir(BuildContext context, Agenda agenda) async {
    await db
        .collection("agenda")
        .add({"dia": agenda.dia, "mes": agenda.mes, "medico": agenda.medico});
    Navigator.pop(context);
  }
}

class ListaMedicos extends StatefulWidget {
  @override
  _ListaMedicosState createState() => _ListaMedicosState();
}

class _ListaMedicosState extends State<ListaMedicos> {
  //Conexão Fluter+Firebase
  final db = Firestore.instance;
  final String colecao = "medicos";

  //Lista dinâmica para manipulação dos dados
  List<Medicos> lista = List();

  //Stream para "ouvir" o Firebase
  StreamSubscription<QuerySnapshot> listen;

  @override
  void initState() {
    super.initState();

    //cancelar o listen, caso a coleção esteja vazia.
    listen?.cancel();

    //retornar dados da coleção e inserir na lista dinâmica
    listen = db.collection(colecao).snapshots().listen((res) {
      setState(() {
        lista = res.documents
            .map((doc) => Medicos.fromMap(doc.data, doc.documentID))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    listen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Médicos Disponíveis'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color(0xff19e194),
                Color(0xff87ceeb),
              ])),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          //fonte de dados
          stream: db.collection(colecao).snapshots(),

          //exibição dos dados
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                List<DocumentSnapshot> docs = snapshot.data.documents;
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          lista[index].nome,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(lista[index].especialidade,
                            style: TextStyle(fontSize: 16)),
                      );
                    });
            }
          }),
    );
  }
}

class ConsultarAgenda extends StatefulWidget {
  @override
  _ConsultarAgendaState createState() => _ConsultarAgendaState();
}

class _ConsultarAgendaState extends State<ConsultarAgenda> {
  //Conexão Fluter+Firebase
  final db = Firestore.instance;
  final String colecao = "agenda";

  //Lista dinâmica para manipulação dos dados
  List<Agenda> lista = List();

  //Stream para "ouvir" o Firebase
  StreamSubscription<QuerySnapshot> listen;

  @override
  void initState() {
    super.initState();

    //cancelar o listen, caso a coleção esteja vazia.
    listen?.cancel();

    //retornar dados da coleção e inserir na lista dinâmica
    listen = db.collection(colecao).snapshots().listen((res) {
      setState(() {
        lista = res.documents
            .map((doc) => Agenda.fromMap(doc.data, doc.documentID))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    listen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Editar Agenda'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color(0xff19e194),
                Color(0xff87ceeb),
              ])),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(

          //fonte de dados
          stream: db.collection(colecao).snapshots(),

          //exibição dos dados
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                List<DocumentSnapshot> docs = snapshot.data.documents;
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          lista[index].dia.toStringAsFixed(2),
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(lista[index].mes,
                            style: TextStyle(fontSize: 16)),
                        leading: Text(lista[index].medico,
                            style: TextStyle(fontSize: 16)),
                        trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              db
                                  .collection(colecao)
                                  .document(lista[index].id)
                                  .delete();
                            }),
                        onTap: () {
                          Navigator.pushNamed(context, "/AlterarAgenda",
                              arguments: lista[index].id);
                        },
                      );
                    });
            }
          }),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/AlterarAgenda", arguments: null);
        },
      ),
      backgroundColor: Colors.brown[50],
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('My Nurse'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color(0xff19e194),
                Color(0xff87ceeb),
              ])),
        ),
      ),
      body: Container(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset('assets/lembrete.png', width: 100, height: 100),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Lembrete de Remédio: \n\n paracetamol \n\n 22:30',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset('assets/ceia.png', width: 100, height: 100),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Lembrete de Ceia: \n\n Verifique a dieta \n\n 22:00',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset('assets/new_exam.png', width: 100, height: 100),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Novos Resultados de Exame: \n\n Verifique \n\n 14/06/2020',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class Noticias extends StatefulWidget {
  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notícias"),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Color(0xff19e194),
                  Color(0xff87ceeb),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Image.asset('assets/tipo-sanguineo.png'),
                SizedBox(
                  height: 20,
                ),
                Text('Conheça a dieta do Tipo Sanguíneo'),
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/h1n1.png',
                          width: 150,
                          height: 150,
                        ),
                        Text('H1N1'),
                      ],
                    ),
                    SizedBox(width: 40),
                    Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/covid.png',
                          width: 150,
                          height: 150,
                        ),
                        Text('Covid 19'),
                      ],
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Color(0xff19e194),
                  Color(0xff87ceeb),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Image.asset('assets/mickey.png'),
                Text(
                  'Nome Completo: Mickey Mouse \n\n Tipo Sanguíneo: A+ \n\n Doença Crônica: Não \n\n Tipo Físico: Ectomorfo \n\n Plano Contratado: Checkup anual + nutricionista',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            )),
      ),
    );
  }
}

class Acompanhamento extends StatefulWidget {
  @override
  _AcompanhamentoState createState() => _AcompanhamentoState();
}

class _AcompanhamentoState extends State<Acompanhamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acompanhamento"),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Color(0xff19e194),
                  Color(0xff87ceeb),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Image.asset('assets/alimentar.png'),
                Text(
                  'Planejamento alimentar',
                  style: (TextStyle(fontWeight: FontWeight.bold)),
                ),
                Image.asset('assets/exames.png'),
                Text(
                  'Últimos Exames',
                  style: (TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            )),
      ),
    );
  }
}

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre"),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Color(0xff19e194),
                  Color(0xff87ceeb),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/programador.png',
                  width: 300,
                  height: 300,
                ),
                Text('Leonardo Pipoli - Desenvolvedor do Projeto',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Sobre o Projeto: '),
                Text(
                    'O presente projeto se trata de um aplicativo de acompanhamento médico. Nele é possível verificar novas notícias sobre diversas pesquisas e conhecimentos relacionados à saúde. Saber resultados de exames, verificar ficha médica e até mesmo acompanhar algumas enfermidades crônicas, com aconselhamento à distância.',
                    style: TextStyle())
              ],
            )),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final FirebaseAuth mAuth = FirebaseAuth.instance;

class _LoginState extends State<Login> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("assets/logo.png"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              // autofocus: true,
              keyboardType: TextInputType.emailAddress,
              onChanged: (input) => _email = input,
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              // autofocus: true,
              keyboardType: TextInputType.text,
              onChanged: (input) => _password = input,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  "Recuperar Senha",
                  textAlign: TextAlign.right,
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [
                    Color(0xff19e194),
                    Color(0xff87ceeb),
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    onPressed: loginUser,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: SizedBox(
                      child: Image.asset("assets/login-icon.png"),
                      height: 28,
                      width: 28,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Color(0xFF3C5A99),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Login com Facebook",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    onPressed: loginUser,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: SizedBox(
                      child: Image.asset("assets/fb-icon.png"),
                      height: 28,
                      width: 28,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> loginUser() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }
}

showAlertDialog(BuildContext context) {
  Widget cancelaButton = RaisedButton(
      color: Colors.green,
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop(context);
      });
  Widget continuaButton = RaisedButton(
    color: Colors.red,
    child: Text("Continar"),
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    },
  );
  //configura o AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Você irá sair da conta e dados não salvos serão apagados."),
    content: Text("Deseja continuar?"),
    actions: [
      cancelaButton,
      continuaButton,
    ],
  );
  //exibe o diálogo
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
