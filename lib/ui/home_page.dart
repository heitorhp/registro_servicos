import 'dart:io';
import 'package:registroservicos/helpers/contact_helpers.dart';
import 'package:registroservicos/helpers/contact_helpers.dart';
import 'package:registroservicos/ui/contact_page.dart';
import 'package:registroservicos/ui/contact_exibe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelpers helpers = ContactHelpers();

  List<Contact> contacts = List();

  //carrega a lista de contatos ao iniciar o app
  @override
  void initState() {
    super.initState();

    _getAllContacts();
  } //fim do carrega a lista de contatos ao iniciar

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'image/hpnet.png',
                  fit: BoxFit.contain,
                  height: 25,
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Controle de Serviços"))
              ],
            ),
            actions: <Widget>[
              PopupMenuButton<OrderOptions>(
                itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar de A-Z"),
                    value: OrderOptions.orderaz,
                  ),
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar de Z-A"),
                    value: OrderOptions.orderza,
                  ),
                ],
                onSelected: _orderList,
              )
            ],
          ),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showContactPage();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
          body: Stack(children: <Widget>[
            Image.asset(
              "image/logo_hpnet2.jpg",
              fit: BoxFit.cover,
              height: 500.0,
            ),
            ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return _contactCard(context, index);
                }),
          ])),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    String dadosOsQru;
    //String _operadora
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: contacts[index].imgLaudoQru != null
                            ? FileImage(File(contacts[index].imgLaudoQru))
                            : AssetImage("image/ordem_servico.png"))),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Nº OS:  " + contacts[index].osQru ?? "",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        contacts[index].operadoraQru ?? "",
                        style: TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.normal),
                      ),
                      Text(
                        contacts[index].tipoServicoQru ?? "",
                        style: TextStyle(fontSize: 10.0),
                      ),
                      Text(
                        contacts[index].seguradoQru ?? "",
                        style: TextStyle(fontSize: 10.0),
                      ),
                      Text(
                        contacts[index].enderecoQru ?? "",
                        style: TextStyle(fontSize: 10.0),
                      ),
                      Text(
                        contacts[index].obsQru ?? "",
                        style: TextStyle(fontSize: 10.0),
                      ),
                      Text(
                        contacts[index].valorQru ?? "",
                        style: TextStyle(fontSize: 10.0),
                      ),
                      Text(
                        contacts[index].dataQru ?? "",
                        style: TextStyle(fontSize: 10.0),
                      ),
                      Text(
                        contacts[index].horaQru ?? "",
                        style: TextStyle(fontSize: 10.0),
                      ),
                      Text(
                        contacts[index].tecnicoQru ?? "",
                        style: TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ) ,
              )

            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
        //_showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /* Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child:  Text("Exibir (em construção)",
                          style:  TextStyle(color: Colors.blueAccent, fontSize: 20.0),
                        ),
                        onPressed: (){
                          _showContactExibe(contact: contacts[index]);
                        },
                      ),
                    ),*/
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.green, fontSize: 20.0),
                        ),
                        onPressed: () {
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          helpers.deleteContact(contacts[index].codeQru);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
              contact: contact,
            )));
    if (recContact != null) {
      if (contact != null) {
        await helpers.updateContact(recContact);
        _getAllContacts();
      } else {
        await helpers.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _showContactExibe({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactExibe(
              contact: contact,
            )));
    if (recContact != null) {
      if (contact != null) {
        await helpers.updateContact(recContact);
        _getAllContacts();
      } else {
        await helpers.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helpers.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.dataQru.toLowerCase().compareTo(b.dataQru.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
      // ignore: missing_return
        contacts.sort((a, b) {
          return b.dataQru.toLowerCase().compareTo(a.dataQru.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
