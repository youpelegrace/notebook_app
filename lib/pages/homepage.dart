import 'package:flutter/material.dart';
import 'package:note_book_app/pages/editnote.dart';
import 'package:note_book_app/widgets/loading.dart';

class NoteBook extends StatefulWidget {
  const NoteBook({Key? key}) : super(key: key);

  @override
  _NoteBookState createState() => _NoteBookState();
}

class _NoteBookState extends State<NoteBook> {
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
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditNote()))
                    .then((value) => refresh());
              },
            );
          }),
      body: loading
          ? Loading()
          : ListView.builder(
              padding: EdgeInsets.all(5.0),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text("Title" + index.toString(),
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    subtitle: Text("Sample content",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(
                        () {
                          loading = true;
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditNote()))
                              .then((value) => refresh());
                        },
                      );
                    },
                  ),
                );
              }),
    );
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() => loading = false);
  }
}
