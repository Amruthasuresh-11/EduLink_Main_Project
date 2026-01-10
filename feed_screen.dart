import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  // Dummy posts list (later from Firebase)
  final List<Map<String, String>> posts = const [
    {
      "name": "Anjali S.",
      "college": "XYZ College",
      "time": "2 hours ago",
      "title": "Completed Python Internship Certificate 🎉",
      "desc":
          "Happy to share that I completed my Python internship successfully. Thanks to my mentors!",
    },
    {
      "name": "Rahul M.",
      "college": "ABC College",
      "time": "Yesterday",
      "title": "Won 1st Prize in Hackathon 🏆",
      "desc":
          "Our team secured 1st prize in the inter-college hackathon. Great learning experience!",
    },
    {
      "name": "Meera K.",
      "college": "LMN College",
      "time": "3 days ago",
      "title": "Uploaded DBMS Notes 📚",
      "desc":
          "I uploaded my DBMS semester notes. Hope it helps juniors for exam preparation.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

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
              // 🔹 Top User Info Row
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF4A00E0),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post["name"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          post["college"]!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    post["time"]!,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 🔹 Post Title
              Text(
                post["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 6),

              // 🔹 Post Description
              Text(
                post["desc"]!,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),

              const SizedBox(height: 12),

              // 🔹 Certificate/Post Image Placeholder
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 Like / Comment Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.thumb_up_alt_outlined,
                        color: Color(0xFF4A00E0)),
                    label: const Text(
                      "Like",
                      style: TextStyle(color: Color(0xFF4A00E0)),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.comment_outlined,
                        color: Color(0xFF4A00E0)),
                    label: const Text(
                      "Comment",
                      style: TextStyle(color: Color(0xFF4A00E0)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
