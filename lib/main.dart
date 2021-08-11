import 'package:flutter/material.dart';
import 'package:sqlitedemo/edit.dart';
import 'package:sqlitedemo/services/databasehandler.dart';
import 'package:sqlitedemo/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseHandler handler;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final countryController = TextEditingController();

  //Add multiple users
  Future<int> addUsers() async {
    User firstUser = User(name: "peter", age: 24, country: "Lebanon");
    User secondUser = User(name: "john", age: 31, country: "United Kingdom");
    List<User> listOfUsers = [firstUser, secondUser];
    return await this.handler.insertUsers(listOfUsers);
  }

  //add single user
  Future<int> addUser(String _name, int _age, String _country) async {
    User user = User(name: _name, age: _age, country: _country);
    return await this.handler.insertUser(user);
  }

  @override
  void initState() {
    super.initState();
    this.handler = DatabaseHandler();
    //Add this if want to populate Data
    // this.handler.initializeDB().whenComplete(() async {
    //   await this.addUsers();
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQLIte Demo'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Add Data'),
                        content: Container(
                          width: 300,
                          height:250,
                          child: Column(
                            children: [
                              Text('Name'),
                              TextField(controller: nameController,),
                              Text('Age'),
                              TextField(controller: ageController,),
                              Text('Country'),
                              TextField(controller: countryController,),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                //OK
                                this
                                    .handler
                                    .initializeDB()
                                    .whenComplete(() async {
                                  await this.addUser(nameController.text, int.parse(ageController.text), countryController.text);
                                  setState(() {});
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Add')),
                          TextButton(
                              onPressed: () {
                                //cancel
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'))
                        ],
                      );
                    });
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: this.handler.retrieveUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await this.handler.deleteUser(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                      child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(snapshot.data![index].name),
                    subtitle: Text(snapshot.data![index].age.toString()),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Edit(pass: snapshot.data![index])))
                          .then((value) {
                        setState(() {
                          // refresh page
                        });
                      });
                      }, icon: Icon(Icons.edit)),
                  )),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
