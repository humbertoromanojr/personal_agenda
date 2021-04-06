import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_agenda/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact}); // constructor

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  bool _userEdited = false;

  Contact _editContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null){
      _editContact = Contact();
    } else {
      _editContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editContact.name;
      _emailController.text = _editContact.email;
      _phoneController.text = _editContact.phone;
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.indigoAccent,
              title: Text(_editContact.name ?? "New Contact"),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(_editContact.name.isNotEmpty && _editContact.name != null){
                  Navigator.pop(context, _editContact);
                } else if(_editContact.email.isNotEmpty && _editContact.email != null){
                  Navigator.pop(context, _editContact);
                } else if(_editContact.phone.isNotEmpty && _editContact.phone != null){
                  Navigator.pop(context, _editContact);
                } else {
                  FocusScope.of(context).requestFocus(_nameFocus);
                  FocusScope.of(context).requestFocus(_emailFocus);
                  FocusScope.of(context).requestFocus(_phoneFocus);
                }
              },
              child: Icon(Icons.save),
              backgroundColor: Colors.indigo,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child:  Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editContact.img != null
                                ? FileImage(File(_editContact.img))
                                : AssetImage("images/user-default.png")),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    decoration: InputDecoration(labelText: "Name"),
                    onChanged: (text){
                      _userEdited = true;
                      setState(() {
                        _editContact.name = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    decoration: InputDecoration(labelText: "Email"),
                    onChanged: (text){
                      _userEdited = true;
                      _editContact.email = text;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    decoration: InputDecoration(labelText: "Phone"),
                    onChanged: (text){
                      _userEdited = true;
                      _editContact.phone = text;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            )
        )
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("To discard changes?"),
            content: Text("If the changes come out, they will be lost ok!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Yes"),
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
    } else {
      return Future.value(true);
    }
  }

}
