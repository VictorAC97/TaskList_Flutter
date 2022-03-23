import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("Lista de Tarefas"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        /*
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Adicionar"),
          backgroundColor: Colors.purple,
          icon: Icon(Icons.add),
          //shape:
          //BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {},
        ),*/
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.menu),
              )
            ],
          ),
          shape: CircularNotchedRectangle(),
        ));
  }
}
