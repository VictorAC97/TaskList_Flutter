import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];
  Map<String, dynamic> _tarefaEditada = Map();
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;

    //Criar Dados
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;

    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    print("Tarefa Salva: ${textoDigitado}");
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();

    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

  Widget criarItemLista(context, index) {
    final item = _listaTarefas[index]["titulo"];
    final chave = DateTime.now().millisecondsSinceEpoch.toString();

    return Dismissible(
      key: Key(chave),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.green,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        //deletar tarefa
        if (direction == DismissDirection.endToStart) {
          //recuperar o ultimo item excluido
          final item = _listaTarefas[index];
          //remove item da lista
          setState(() {
            _listaTarefas.removeAt(index);
            //_salvarArquivo();
          });
          //snackbar
          final snackbar = SnackBar(
            backgroundColor: Colors.purple,
            content: Text("Tarefa Removida!"),
            action: SnackBarAction(
              textColor: Colors.white,
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _listaTarefas.insert(index, item);
                });
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          _salvarArquivo();
        } else {
          //editar tarefa

          //manter a tarefa original
          final item = _listaTarefas[index];

          _controllerTarefa.text = _listaTarefas[index]["titulo"];

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Editar Tarefa"),
                content: TextField(
                  controller: _controllerTarefa,
                  decoration: InputDecoration(labelText: "Edite sua tarefa"),
                ),
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple)),
                    onPressed: () {
                      setState(() {
                        _lerArquivo();
                      });
                      Navigator.pop(context);
                      _controllerTarefa.text = "";
                    },
                    child: Text("Desfazer"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple)),
                    onPressed: () {
                      //salvar o novo nome por cima da tarefa atual
                      setState(() {
                        _listaTarefas[index]["titulo"] = _controllerTarefa.text;
                      });
                      _salvarArquivo();
                      Navigator.pop(context);
                      _controllerTarefa.text = "";
                    },
                    child: Text("Salvar"),
                  )
                ],
              );
            },
          );
        }
      },
      child: CheckboxListTile(
          activeColor: Colors.purple,
          title: Text(_listaTarefas[index]["titulo"]),
          value: _listaTarefas[index]["realizada"],
          onChanged: (newValue) {
            setState(() {
              _listaTarefas[index]["realizada"] = newValue;
            });
            _salvarArquivo();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    //_salvarArquivo();
    //print("itens: " + _listaTarefas.toString());
    //print("itens: " + DateTime.now().millisecondsSinceEpoch.toString());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Lista de Tarefas"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar Tarefa"),
                  content: TextField(
                    controller: _controllerTarefa,
                    decoration: InputDecoration(labelText: "Digite sua tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: [
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar")),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple),
                        ),
                        onPressed: () {
                          if (_controllerTarefa.text != "") {
                            _salvarTarefa();
                          }
                          Navigator.pop(context);
                        },
                        child: Text("Salvar")),
                  ],
                );
              });
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _listaTarefas.length, itemBuilder: criarItemLista),
          ),
        ],
      ),
    );
  }
}
