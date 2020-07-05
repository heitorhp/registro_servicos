import 'dart:io';

import 'package:registroservicos/helpers/contact_helpers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class ContactPage extends StatefulWidget {

  final Contact contact;

  const ContactPage({Key key, this.contact}) : super(key: key);
  //ContactPage(this.contact);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _osQruController = TextEditingController();
  final _operadoraQruController = TextEditingController();
  final _seguradoQruController = TextEditingController();
  final _tipoServicoQruController = TextEditingController();
  final _enderecoQruController = TextEditingController();
  final _obsQruController = TextEditingController();
  final _valorQruController = TextEditingController();
  final _dataQruController = TextEditingController();
  final _horaQruController = TextEditingController();
  final _tecnicoQruController = TextEditingController();
  //imgLaudoQru;

  //final _nameFocus = FocusNode();
  final _osQruFocus = FocusNode();

  bool _userEdited = false;
  Contact _editedContact;

  var maskFormatter = new MaskTextInputFormatter(mask: "##/##/####", filter: { "#": RegExp(r"[0-9]")});

  @override
  void initState() {
    super.initState();
    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _osQruController.text = _editedContact.osQru;
      _operadoraQruController.text = _editedContact.operadoraQru;
      _seguradoQruController.text = _editedContact.seguradoQru;
      _tipoServicoQruController.text = _editedContact.tipoServicoQru;
      _enderecoQruController.text = _editedContact.enderecoQru;
      _obsQruController.text = _editedContact.obsQru;
      _valorQruController.text = _editedContact.valorQru;
      _dataQruController.text = _editedContact.dataQru;
      _horaQruController.text = _editedContact.horaQru;
      _tecnicoQruController.text = _editedContact.tecnicoQru;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(_editedContact.osQru ?? "Novo Cadastro de Serviço"),
          centerTitle: true,
        ),
        floatingActionButton:  FloatingActionButton(
          onPressed: (){//testar se os campus foram preenchidos (Dalta imlementar os outros campos)
            if(_editedContact.osQru != null && _editedContact.osQru.isNotEmpty){
              Navigator.pop(context, _editedContact);
            }else{
              FocusScope.of(context).requestFocus(_osQruFocus);
              //Navigator.pop(context, _editedContact);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 340.0,
                  height: 440.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: _editedContact.imgLaudoQru != null ?
                          FileImage(File(_editedContact.imgLaudoQru)) :
                          AssetImage("image/ordem_servico.png")
                      )
                  ),
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                    if(file == null) return;
                    setState(() {
                      _editedContact.imgLaudoQru = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _osQruController,
                focusNode: _osQruFocus,
                decoration: InputDecoration(labelText: "Nº OS: ",
                    hintText: "Informe a Ordem de Serviço",
                    icon: Icon(Icons.assignment,)),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.osQru = text;
                  });
                },
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _operadoraQruController ,
                decoration: InputDecoration(labelText: "Seguradora: "),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.operadoraQru = text;
                },
                //keyboardType: TextInputType.emailAddress, (usado para tratar o campo como email)
              ),
              TextField(
                controller: _tipoServicoQruController ,
                decoration: InputDecoration(labelText: "Serviço: "),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.tipoServicoQru = text;
                },
                //keyboardType: TextInputType.emailAddress, (usado para tratar o campo como email)
              ),
              TextField(
                controller: _seguradoQruController,
                decoration: InputDecoration(labelText: "Segurado(a): "),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.seguradoQru = text;
                },
                //keyboardType: TextInputType.phone, (Usado para tratar o campo como telefone)
              ),
              TextField(
                controller: _enderecoQruController,
                decoration: InputDecoration(labelText: "Endereço: "),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.enderecoQru = text;
                },
              ),
              TextField(
                controller: _obsQruController,
                decoration: InputDecoration(labelText: "Observações: "),
                // textAlign: _obsQruController != null ? TextAlign.justify: TextAlign.left,
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.obsQru = text;
                },
              ),
              TextField(
                  controller: _valorQruController,
                  decoration: InputDecoration(labelText: "Valor: "),
                  onChanged: (text){
                    _userEdited = true;
                    _editedContact.valorQru = text;
                  },
                  keyboardType: TextInputType.number
              ),
              TextField(
                inputFormatters: [maskFormatter],
                controller: _dataQruController,
                decoration: InputDecoration(labelText: "Data: "),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.dataQru = text;
                },
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _horaQruController,
                decoration: InputDecoration(labelText: "Hora: "),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.horaQru = text;
                },
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _tecnicoQruController,
                decoration: InputDecoration(labelText: "Técnico: "),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.tecnicoQru = text;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);
                    //Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
      return Future.value(false);
    } else{
      return Future.value(true);
    }
  }

}
