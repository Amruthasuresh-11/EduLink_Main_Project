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
  // ✅ Theme color
  static const Color themeBlue = Color(0xFF4A00E0);

  // ✅ User details (Firestore)
  String name = "";
  String university = "";
  String college = "";
  String course = "";
  String year = "";
  String skills = "";

  bool isLoading = true;

  // ✅ Fetch user data safely from Firestore
  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // ✅ if no user logged in
      if (user == null) {
        if (!mounted) return;
        setState(() => isLoading = false);
        return;
      }

      final uid = user.uid;

      // ✅ fetch document
      final doc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (!mounted) return; // ✅ prevents setState after dispose

      if (doc.exists) {
        setState(() {
          name = (doc.data()?["name"] ?? "").toString();
          university = (doc.data()?["university"] ?? "").toString();
          college = (doc.data()?["college"] ?? "").toString();
          course = (doc.data()?["course"] ?? "").toString();
          year = (doc.data()?["year"] ?? "").toString();
          skills = (doc.data()?["skills"] ?? "").toString();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading profile: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // ✅ Logout function
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // ✅ Helper: show default value if empty
  String showValue(String value) {
    return value.trim().isEmpty ? "Not added yet" : value;
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle detailStyle = TextStyle(
      fontSize: 14,
      color: Colors.black87,
      height: 1.5,
    );

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // ✅ Top Profile Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Profile image left
                        CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(Icons.person,
                              size: 45, color: Colors.white),
                        ),

                        const SizedBox(width: 14),

                        // ✅ Details + icons on right
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ Icons row at top right
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // ✅ Edit profile button
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: themeBlue),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EditProfileScreen(),
                                        ),
                                      );

                                      // ✅ Refresh profile after edit
                                      if (result == true) {
                                        if (!mounted) return;
                                        setState(() => isLoading = true);
                                        fetchUserData();
                                      }
                                    },
                                  ),

                                  // ✅ Add post (future)
                                  IconButton(
                                    icon: const Icon(Icons.add_box_outlined,
                                        color: themeBlue),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Add Post coming soon ✅")),
                                      );
                                    },
                                  ),

                                  // ✅ Upload notes (future)
                                  IconButton(
                                    icon: const Icon(Icons.upload_file,
                                        color: themeBlue),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Upload Notes coming soon ✅")),
                                      );
                                    },
                                  ),

                                  // ✅ Logout
                                  IconButton(
                                    icon: const Icon(Icons.logout,
                                        color: Colors.red),
                                    onPressed: logout,
                                  ),
                                ],
                              ),

                              // ✅ Name & details from Firestore
                              Text(
                                name.isEmpty ? "Student" : name,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),

                              Text("University : ${showValue(university)}",
                                  style: detailStyle),
                              Text("College : ${showValue(college)}",
                                  style: detailStyle),
                              Text("Course : ${showValue(course)}",
                                  style: detailStyle),
                              Text("Year : ${showValue(year)}",
                                  style: detailStyle),
                              Text("Skills : ${showValue(skills)}",
                                  style: detailStyle),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ✅ Notes + Message buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeBlue,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Notes page coming soon ✅")),
                              );
                            },
                            child: const Text(
                              "Notes",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeBlue,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Messages page coming soon ✅")),
                              );
                            },
                            child: const Text(
                              "Message",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // ✅ Posts title
                    const Text(
                      "Posts",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    // ✅ Post area box
                    Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "No posts yet",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
