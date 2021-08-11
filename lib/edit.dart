import 'package:flutter/material.dart';
import 'package:sqlitedemo/services/databasehandler.dart';
import 'package:sqlitedemo/user.dart';

class Edit extends StatefulWidget {
  Edit({Key? key, required this.pass}) : super(key: key);

  final User pass;

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController()
      ..text = widget.pass.name;
    TextEditingController ageController = TextEditingController()
      ..text = widget.pass.age.toString();
    TextEditingController countryController = TextEditingController()
      ..text = widget.pass.country;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit user'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Text('ID ${widget.pass.id.toString()}'),
              SizedBox(
                height: 30,
              ),
              Text('Name:'),
              TextField(
                controller: nameController,
              ),
              Text('Age:'),
              TextField(
                controller: ageController,
              ),
              Text('Country'),
              TextField(
                controller: countryController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        //edit function here
                        await this.handler.updateUser(User(
                            id: widget.pass.id,
                            name: nameController.text,
                            age: int.parse(ageController.text),
                            country: countryController.text));
                        Navigator.pop(context);
                      },
                      child: Text('Edit User')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
