import 'package:database_app/data/local/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance();
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    print('Fetched notes: $allNotes');
    setState(() {});
  }

  void openBottomSheet({bool isUpdate=false,int sno=0}) {
    errorMsg = " ";
    titleController.clear();
    descController.clear();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
                padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,),
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25), topLeft: Radius.circular(25)),
                  child: Container(
                    width: double.infinity,
                    color: Colors.green.withOpacity(0.8),
                    padding: EdgeInsets.all(8.0),
                    child: Column(

                      children: [
                     isUpdate? Text(
                       "Update Note",
                       style: TextStyle(
                           fontSize: 25, fontWeight: FontWeight.bold),
                     ): Text(
                          "Add Note",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            label: Text('Title*'),
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: descController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            label: Text('Description*'),
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (errorMsg.isNotEmpty)
                          Text(
                            errorMsg,
                            style: TextStyle(color: Colors.red, fontSize: 17),
                          ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                var Title = titleController.text.trim();
                                var Desc = descController.text.trim();
                                if (Title.isNotEmpty && Desc.isNotEmpty) {
                                  bool check =isUpdate?
                                  await dbRef!.updateNote(title: Title, desc: Desc, sno: sno):
                                await dbRef!.addNote(mTitle: Title, mDesc: Desc);
                                  if (check) {
                                    getNotes();
                                  }
                                  Navigator.pop(context);
                                } else {
                                  setModalState(() {
                                    errorMsg = "*Please fill all the required blanks";
                                  });
                                }
                              },
                              child: Text(
                                isUpdate?'Update Note':'Add Note',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
            child: Text(
              'Notes app',
              style: TextStyle(
                  fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
            )),
        backgroundColor: Colors.green.withOpacity(0.8),
      ),
      body: allNotes.isNotEmpty ? ListView.builder(
        itemCount: allNotes.length,
        itemBuilder: (_, index) {
          return ListTile(
            leading: Text('${index+1}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),
            title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.green),),
            subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_desc],style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
            trailing: SizedBox(
              width: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap:(){
                      titleController.text=allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                      titleController.text=allNotes[index][DBHelper.COLUMN_NOTE_desc];
                      openBottomSheet(isUpdate: true,sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                    },
                      child: Icon(Icons.edit,color: Colors.lightBlueAccent,)),
                  InkWell(
                      onTap:()async{
                       bool check = await  dbRef!.deleteNote(sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                       if(check){
                         getNotes();
                       }
                      } ,
                      child: Icon(Icons.delete,color: Colors.red,))
                ],
              ),
            ),
          );
        },
      )
          : Center(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/rafiki.png",width:180,height:150,),
              Text('No Notes Yet!!',style: TextStyle(fontSize: 17,color: Colors.white),)
            ]
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: openBottomSheet,
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.green.withOpacity(0.8),
      ),
    );
  }
}


