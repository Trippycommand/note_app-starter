import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:note_app/constants/colors.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> filterdNote = [];

  @override
  void initState() {
    super.initState();
    filterdNote = sampleNotes;
  }

  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      filterdNote = sampleNotes
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void delteNote(int index) {
    setState(() {
      filterdNote.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff242526),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notes',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff3A3B3C).withOpacity(.8),
                ),
                child: IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.sort,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: onSearchTextChanged,
            style: TextStyle(fontSize: 16, color: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              hintText: "Search notes...",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              fillColor: Color.fromARGB(255, 78, 78, 78),
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.transparent)),
            ),
          ),
          Expanded(
              child: ListView.builder(
            padding: EdgeInsets.only(top: 35),
            itemCount: filterdNote.length,
            itemBuilder: (context, index) {
              return Card(
                color: getRandomColor(),
                margin: EdgeInsets.only(bottom: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditScreen(
                              note: filterdNote[index],
                            ),
                          ));
                      if (result != null) {
                        setState(() {
                          int orignalIndex =
                              sampleNotes.indexOf(filterdNote[index]);
                          sampleNotes[orignalIndex] = (Note(
                              id: sampleNotes[orignalIndex].id,
                              title: result[0],
                              content: result[1],
                              modifiedTime: DateTime.now()));
                          filterdNote[index] = Note(
                              id: filterdNote[index].id,
                              title: result[0],
                              content: result[1],
                              modifiedTime: DateTime.now());
                        });
                      }
                    },
                    title: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: '${filterdNote[index].title}\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                height: 1.5),
                            children: [
                              TextSpan(
                                  text: '${filterdNote[index].content}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      height: 1.5))
                            ])),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        ' Edited:  ${DateFormat('EEE MMM d,yyyy h:m a').format(filterdNote[index].modifiedTime)}',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final result = await confirmDialog(context);
                        if (result) {
                          delteNote(index);
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    ),
                  ),
                ),
              );
            },
          ))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const EditScreen(),
              ));
          if (result != null) {
            setState(() {
              sampleNotes.add(Note(
                  id: sampleNotes.length,
                  title: result[0],
                  content: result[1],
                  modifiedTime: DateTime.now()));
              filterdNote = sampleNotes;
            });
          }
        },
        elevation: 1,
        backgroundColor: Color.fromARGB(255, 92, 91, 91),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 52, 51, 51),
            icon: Icon(
              Icons.info,
              color: Color.fromARGB(255, 126, 124, 124),
            ),
            title: Text(
              "Are you sure you want to delete",
              style: TextStyle(color: Colors.white),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text(
                        "Yes",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(
                        "No",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ))
                ]),
          );
        });
  }
}
