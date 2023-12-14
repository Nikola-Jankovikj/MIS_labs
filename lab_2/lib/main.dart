import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '213204',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MIS LAB 1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> subjects = [];

  void addSubject() {
    showDialog(context: context, builder: (BuildContext context) {
      String newSubject = "";
      return AlertDialog(
        title: const Text(
          "Add a new subject",
          style: TextStyle(color: Colors.blue), // Blue text color for the question
        ),
        content: TextField(
          onChanged: (value) {
            newSubject = value;
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (newSubject.isNotEmpty) {
                  subjects.add(newSubject);
                }
                Navigator.pop(context);
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Green background color for the button
            ),
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.red), // Red text color for the button text
            ),
          ),
        ],
      );
    });
  }

  void deleteSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  void editSubject(int index) {
    showDialog(context: context, builder: (BuildContext context) {
      String newSubject = subjects[index];
      return AlertDialog(
        title: const Text(
          "Edit subject",
          style: TextStyle(color: Colors.blue), // Blue text color for the question
        ),
        content: TextField(
          onChanged: (value) {
            newSubject = value;
          },
          controller: TextEditingController(text: subjects[index]),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (newSubject.isNotEmpty) {
                  subjects[index] = newSubject;
                }
                Navigator.pop(context);
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Green background color for the button
            ),
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.red), // Red text color for the button text
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clothes list'),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                subjects[index],
                style: const TextStyle(fontSize: 18),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteSubject(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      editSubject(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addSubject,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_box_outlined),
      ),
    );
  }
}
