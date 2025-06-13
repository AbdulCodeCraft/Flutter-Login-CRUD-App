import 'package:flutter/material.dart';

// Item class (Model)
class Item {
  int id;
  String title;
  String description;
  String imagePath; // Path of asset image

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// HomePage (Main screen)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> items = [];

  // Default image path for static asset image
  final String defaultImagePath = 'assets/bg.jpg';

  // Function to create new item
  void _createItem() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              Image.asset(defaultImagePath, height: 100, width: 100, fit: BoxFit.cover),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                setState(() {
                  items.add(Item(
                    id: items.isEmpty ? 1 : items.last.id + 1,
                    title: titleController.text,
                    description: descController.text,
                    imagePath: defaultImagePath, // Use static image
                  ));
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Function to edit item
  void _editItem(Item item) {
    TextEditingController titleController = TextEditingController(text: item.title);
    TextEditingController descController = TextEditingController(text: item.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              Image.asset(defaultImagePath, height: 100, width: 100, fit: BoxFit.cover), // Static image
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                item.title = titleController.text;
                item.description = descController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Function to delete item
  void _deleteItem(int id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  // UI build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          Item item = items[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                item.imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(item.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.description),
                  Text('ID: ${item.id}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _editItem(item),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () => _deleteItem(item.id),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
