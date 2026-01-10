import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // Dummy chat list
  final List<Map<String, String>> chats = const [
    {"name": "Arjun P.", "msg": "Hi, how can I help you?", "time": "10:20 AM"},
    {"name": "Meera K.", "msg": "Send your syllabus details.", "time": "Yesterday"},
    {"name": "Rahul M.", "msg": "Sure, I will share notes.", "time": "2 days ago"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        final chat = chats[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF4A00E0),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              chat["name"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chat["msg"]!),
            trailing: Text(
              chat["time"]!,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Open chat with ${chat["name"]}")),
              );
            },
          ),
        );
      },
    );
  }
}
