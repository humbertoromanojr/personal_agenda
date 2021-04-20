import 'dart:io';

import 'package:flutter/material.dart';
import 'package:personal_agenda/helpers/contact_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact_page.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Agenda"),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text("Sort to A-Z"),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Sort to Z-A"),
                  value: OrderOptions.orderza,
                ),
              ],
            onSelected: _sortList,
          )
        ],
      ),
      backgroundColor: Colors.indigo,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Stack(
        children: <Widget>[
          //Image.asset('images/background.png',
            //fit: BoxFit.cover,
           // height: 1000.0,
          //),
          ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return _contactCard(context, index);
              }),
        ],
      )
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
        child: Card(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null
                          ? FileImage(File(contacts[index].img))
                          : AssetImage("images/user-default.png"),
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contacts[index].email ?? "",
                      style: TextStyle(
                          fontSize: 20.0, ),
                    ),
                    Text(
                      contacts[index].phone ?? "",
                      style: TextStyle(
                          fontSize: 20.0, ),
                    )
                  ],
                ),
              )
            ],
          )),
        ),
      onTap: (){
          _showOptions(context, index);
      }
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Icon(Icons.phone, size: 40.0, color: Colors.indigo,),
                        onPressed: (){
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Icon(Icons.edit, size: 40.0, color: Colors.indigo,),
                        onPressed: (){
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Icon(Icons.delete, size: 40.0, color: Colors.indigo,),
                        onPressed: (){
                          helper.deleteContact(contacts[index].id);
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
            }
        );
      }
    );
  }
  
  void _showContactPage({ Contact contact }) async {
    final recContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact))
    );

    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _sortList(OrderOptions result) {
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort((a, b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

}
