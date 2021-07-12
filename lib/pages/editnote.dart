import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:note_book_app/models/note.dart';
import 'package:note_book_app/service/db.dart';
import 'package:note_book_app/widgets/loading.dart';

class EditNote extends StatefulWidget {
  // const EditNote({Key? key}) : super(key: key);

  late final Note note;
  EditNote({required this.note});

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final TextEditingController title = TextEditingController();
  final TextEditingController content = TextEditingController();
  bool loading = false;
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    title.text = "title";
    content.text = "content";
    if (widget.note.id != null) {
      editMode = true;
      title.text = widget.note.title;
      content.text = widget.note.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(editMode ? "Edit" : "New"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => loading = true);
              save();
            },
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
          if (editMode)
            IconButton(
                onPressed: () {
                  setState(() {
                    loading = true;
                    delete();
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ))
        ],
      ),
      body: loading
          ? Loading()
          : ListView(
              padding: EdgeInsets.all(18),
              children: [
                TextField(
                  controller: title,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: content,
                  maxLines: 27,
                ),
              ],
            ),
    );
  }

  Future<void> save() async {
    if (title.text != "") {
      widget.note.title = title.text;
      widget.note.content = content.text;
      if (editMode)
        await DB().update(widget.note);
      else
        await DB().add(widget.note);
    }
    ;
    setState(() {
      loading = false;
    });
  }

  Future<void> delete() async {
    await DB().delete(widget.note);
    Navigator.pop(context);
  }
}
