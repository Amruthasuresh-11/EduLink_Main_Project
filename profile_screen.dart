import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color themeBlue = Color(0xFF4A00E0);

  String name = "";
  String university = "";
  String college = "";
  String course = "";
  String year = "";
  String skills = "";

  bool isLoading = true;
  String myUid = "";

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    myUid = user.uid;

    final doc =
        await FirebaseFirestore.instance.collection("users").doc(myUid).get();
        if(!mounted) return;

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = data["name"] ?? "";
        university = data["university"] ?? "";
        college = data["college"] ?? "";
        course = data["course"] ?? "";
        year = data["year"] ?? "";
        skills = data["skills"] ?? "";
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  String showValue(String value) =>
      value.trim().isEmpty ? "Not added yet" : value;
  //Badge Logic
  String getBadge(double rating) {
  if (rating >= 4.5) return "🥇";
  if (rating >= 3.5) return "🥈";
  if (rating >= 2.5) return "🥉";
  return "";
  }
  //Average Rating
  Future<double> getAverageRating() async {
  final snapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(myUid)
      .collection("ratings")
      .get();

  if (snapshot.docs.isEmpty) return 0;

  double total = 0;

  for (var doc in snapshot.docs) {
    total += (doc["rating"] ?? 0);
  }

  return total / snapshot.docs.length;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 38,
                          child: Icon(Icons.person, size: 40),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: themeBlue),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const EditProfileScreen(),
                                        ),
                                      );

                                      if (result == true) {
                                        setState(() => isLoading = true);
                                        fetchUserData();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_box_outlined,
                                        color: themeBlue),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AddPostDialog(),
                                      );
                                    },
                                  ),
                                  IconButton(
                                     icon: const Icon(Icons.upload_file,
                                     color: themeBlue,),
                                    onPressed: (){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: 
                                        Text("Upload notes coming soon")),
                                      );
                                    },
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.logout,
                                        color: Colors.red),
                                    onPressed: logout,
                                  ),
                                ],
                              ),
                              
                              FutureBuilder<double>(
                                future: getAverageRating(),
                                builder: (context, snapshot) {

                                  final rating = snapshot.data ?? 0;
                                  final badge = getBadge(rating);

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          if (badge.isNotEmpty) ...[
                                            const SizedBox(width: 6),
                                            Text(
                                              badge,
                                              style: const TextStyle(fontSize: 22),
                                            ),
                                          ]
                                        ],
                                      ),

                                      if (rating > 0)
                                        Text(
                                          "⭐ ${rating.toStringAsFixed(1)} Rating",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              Text("University : ${showValue(university)}"),
                              Text("College : ${showValue(college)}"),
                              Text("Course : ${showValue(course)}"),
                              Text("Year : ${showValue(year)}"),
                              Text("Skills : ${showValue(skills)}"),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: themeBlue),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Notes coming soon")),
                                      );
                                    },
                                    child: const Text("Notes",style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: themeBlue),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Messages coming soon")),
                                      );
                                    },
                                    child: const Text("Message",style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ],
                            ),


                    const SizedBox(height: 20),
                    const Text("Posts",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // ✅ MY POSTS
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("posts")
                          .where("uid", isEqualTo: myUid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final posts = snapshot.data!.docs;

                        if (posts.isEmpty) {
                          return const Center(child: Text("No posts yet"));
                        }

                        return Column(
                          children: posts.map((doc) {
                            final post = doc.data() as Map<String, dynamic>;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(post["title"] ?? "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("posts")
                                              .doc(doc.id)
                                              .delete();
                                        },
                                      )
                                    ],
                                  ),
                                  Text(post["desc"] ?? ""),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

// ================= ADD POST DIALOG =================

class AddPostDialog extends StatefulWidget {
  @override
  State<AddPostDialog> createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<AddPostDialog> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  Future<void> savePost() async {
  if (titleController.text.trim().isEmpty ||
      descController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields")),
    );
    return;
  }

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userDoc =
      await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

  await FirebaseFirestore.instance.collection("posts").add({
    "uid": user.uid,
    "name": userDoc["name"],
    "college": userDoc["college"],
    "title": titleController.text.trim(),
    "desc": descController.text.trim(),
    "createdAt": FieldValue.serverTimestamp(),
  });

  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Post"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title")),
          TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description")),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(onPressed: savePost, child: const Text("Post")),
      ],
    );
  }
}
