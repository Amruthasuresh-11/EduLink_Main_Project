import 'package:flutter/material.dart';

class MentorsScreen extends StatelessWidget {
  const MentorsScreen({super.key});

  // Dummy mentors list (Later: Firebase / rule-based matching)
  final List<Map<String, dynamic>> mentors = const [
    {
      "name": "Arjun P.",
      "college": "ABC College",
      "course": "MCA Final Year",
      "skills": "Flutter • Firebase • UI Design",
      "rating": 4.7,
    },
    {
      "name": "Meera K.",
      "college": "XYZ College",
      "course": "BCA Final Year",
      "skills": "Python • DBMS • Project Guidance",
      "rating": 4.5,
    },
    {
      "name": "Rahul M.",
      "college": "LMN College",
      "course": "MSc CS",
      "skills": "Java • Data Structures • Exam Tips",
      "rating": 4.6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: mentors.length,
      itemBuilder: (context, index) {
        final m = mentors[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mentor header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF4A00E0),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${m["course"]} • ${m["college"]}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // rating
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A00E0).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFF4A00E0), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          m["rating"].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A00E0),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 10),

              // Skills
              Text(
                "Skills: ${m["skills"]}",
                style: const TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 12),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Viewing ${m["name"]} profile")),
                        );
                      },
                      icon: const Icon(Icons.visibility, color: Color(0xFF4A00E0)),
                      label: const Text(
                        "View Profile",
                        style: TextStyle(color: Color(0xFF4A00E0)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4A00E0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Chat with ${m["name"]}")),
                        );
                      },
                      icon: const Icon(Icons.chat, color: Colors.white),
                      label: const Text("Chat",
                      style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A00E0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
