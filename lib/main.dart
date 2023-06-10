import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<List<dynamic>> getData() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/todos/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Integrasi Data"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<dynamic>>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                List<dynamic> todos = snapshot.data!;
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            todos[index]['id'].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          todos[index]['title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          todos[index]['completed']
                              ? "Completed"
                              : "Not Completed",
                        ),
                        trailing: Icon(
                          todos[index]['completed']
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: todos[index]['completed']
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Failed to fetch data'),
                );
              }
              return Container(); 
            },
          ),
        ),
      ),
    );
  }
}