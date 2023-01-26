import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'RESIDENTE', votes: 5),
    Band(id: '2', name: 'PXANDA', votes: 1),
    Band(id: '3', name: 'GRUPO NICHE', votes: 2),
    Band(id: '4', name: 'SEBASTIAN YATRA', votes: 3)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (_, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add_box),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('$direction');
        print('${band.id}');
        //TODO: service backend
      },
      background: Container(
        padding: const EdgeInsets.only(left: 20.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green[100],
            foregroundColor: Colors.black,
            child: Text(band.name.substring(0, 2)),
          ),
          title: Text(band.name),
          trailing: Text(
            '${band.votes}',
            style: const TextStyle(fontSize: 20),
          ),
          onTap: () {
            print(band.name);
          }),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('New Band Name'),
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Band Name',
                  labelText: 'Band Name',
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    addBandNameToList(textController.text);
                  },
                  elevation: 5,
                  textColor: Colors.green,
                  child: const Text('Add'),
                )
              ],
            );
          });
    } else {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: const Text('New Band Name'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Dismiss')),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () => addBandNameToList(textController.text),
                    child: const Text('Add')),
              ],
            );
          });
    }
  }

  void addBandNameToList(String name) {
    if (name.length > 1) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
