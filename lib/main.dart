import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';


void main() async {
  await Hive.initFlutter();
  await Hive.openBox('todo');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoHome()
    );
  }
}

class TodoHome extends StatefulWidget {
  const TodoHome({Key? key}) : super(key: key);

  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome>{
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var box = Hive.box('todo');
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: Center(
        child: Column(
          children: [
            const  Text('My Todos', style: TextStyle(
                color: Colors.amber,
                fontSize: 30
            ),),
            ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box box, _) {
                if (box.values.isEmpty) {
                  return const Text('No Todos');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: box.values.length,
                      itemBuilder: (context, index) {
                        final todo = box.getAt(index) as Map;
                        return ListTile(

                          trailing: IconButton(
                            onPressed: () {
                              box.deleteAt(index);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          title: Text(todo['title']),
                          subtitle: Text(todo['description']),
                          leading: IconButton(
                            onPressed: () {
                              showDialog(context: context, builder: (context) =>Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Form(child: Column(
                                      children: [
                                        const Text('Edit Todo'),
                                        const SizedBox(height: 30,),
                                        Center(
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: titleController,
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      hintText: 'Title'
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                                TextField(
                                                  controller: descriptionController,
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      hintText: 'Description'

                                                  ),
                                                ),
                                                const SizedBox(height: 10,),

                                                ElevatedButton(
                                                  onPressed: () {
                                                    Todo todo = Todo(title: titleController.text.toString(), description: descriptionController.text.toString());
                                                    box.putAt(index, todo.toMap());
                                                    var data = box.get(0);

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Edit Todo'),
                                                )
                                              ],
                                            )
                                        )

                                      ],
                                    )),
                                  ),
                                ),
                              ));
                            },
                            icon: const Icon(Icons.edit),
                          )
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          showDialog(context: context, builder: (context) =>Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Form(child: Column(
                  children: [
                    const Text('Add Todo'),
                    const SizedBox(height: 30,),
                    Center(
                        child: Column(
                          children: [
                            TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Title'
                              ),
                            ),
                            const SizedBox(height: 10,),
                            TextField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Description'

                              ),
                            ),
                            const SizedBox(height: 10,),

                            ElevatedButton(
                              onPressed: () {
                                Todo todo = Todo(title: titleController.text.toString(), description: descriptionController.text.toString());
                                box.add(todo.toMap());
                                var data = box.get(0);
                                print(data);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Add Todo'),
                            )
                          ],
                        )
                    )

                  ],
                )),
              ),
            ),
          ));

        },
        child: const Icon(Icons.add),
      )
    );
  }
}

class Todo {
  int? id;
  String title;
  String description;
  Todo({
    required this.title,
    required this.description,
    this.id
  });

  Map<String, dynamic> toMap() {
    return {

      'title': title,
      'description': description
    };
  }
}
