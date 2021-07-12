import 'package:flutter/material.dart';
import 'package:note_book_app/models/note.dart';
import 'package:note_book_app/pages/editnote.dart';
import 'package:note_book_app/service/db.dart';
import 'package:note_book_app/widgets/loading.dart';

class NoteBook extends StatefulWidget {
  const NoteBook({Key? key}) : super(key: key);

  @override
  _NoteBookState createState() => _NoteBookState();
}

class _NoteBookState extends State<NoteBook> {
  late List<Note> notes;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text(
          "All notes",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.black12,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[900],
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          setState(
            () {
              loading = true;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditNote(
                            note: new Note(),
                          ))).then((value) => refresh());
            },
          );
        },
      ),
      body: loading
          ? Loading()
          : ListView.builder(
              padding: EdgeInsets.all(5.0),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                Note note = notes[index];
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(note.title,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    subtitle: Text(note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(
                        () {
                          loading = true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditNote(
                                        note: note,
                                      ))).then((value) => refresh());
                        },
                      );
                    },
                  ),
                );
              }),
    );
  }

  Future<void> refresh() async {
    notes = await DB().getNotes();
    setState(() => loading = false);
  }
}
