import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MentorsScreen extends StatefulWidget {
  const MentorsScreen({super.key});

  @override
  State<MentorsScreen> createState() => _MentorsScreenState();
}

class _MentorsScreenState extends State<MentorsScreen> {
  static const Color themeBlue = Color(0xFF4A00E0);

  // current user details
  String myUniversity = "";
  String myCourse = "";
  String myYear = "";
  String myUid = "";

  // ✅ new keys
  String myUniversityKey = "";
  String myCourseKey = "";

  bool isLoading = true;

  // ✅ year priority map for comparison
  final Map<String, int> yearRank = const {
    "1st Year": 1,
    "2nd Year": 2,
    "3rd Year": 3,
    "Final Year": 4,
    "Passout": 5,
  };

  @override
  void initState() {
    super.initState();
    loadMyProfile();
  }

  // ✅ Normalize same way as edit profile
  String normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r"\s+"), " ");
  }

  // ✅ Load current user profile (university/course/year)
  Future<void> loadMyProfile() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      setState(() => isLoading = false);
      return;
    }

    myUid = user.uid;

    final doc =
        await FirebaseFirestore.instance.collection("users").doc(myUid).get();

    if (!mounted) return; // ✅ VERY IMPORTANT

    if (doc.exists) {
      final data = doc.data();

      myUniversity = (data?["university"] ?? "").toString().trim();
      myCourse = (data?["course"] ?? "").toString().trim();
      myYear = (data?["year"] ?? "").toString().trim();

      myUniversityKey = (data?["universityKey"] ?? "").toString().trim();
      myCourseKey = (data?["courseKey"] ?? "").toString().trim();

      if (myUniversityKey.isEmpty) myUniversityKey = normalize(myUniversity);
      if (myCourseKey.isEmpty) myCourseKey = normalize(myCourse);

      setState(() => isLoading = false);
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


  // ✅ helper to compare mentor year > my year
  bool isHigherYear(String mentorYear) {
    final myRank = yearRank[myYear] ?? 0;
    final mentorRank = yearRank[mentorYear] ?? 0;
    return mentorRank > myRank;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (myUniversityKey.isEmpty || myCourseKey.isEmpty || myYear.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text(
            "Please complete your profile (University, Course, Year)\nso we can suggest mentors.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
    }

    // ✅ Firestore query using KEY FIELDS (No case/space problem)
    final query = FirebaseFirestore.instance
        .collection("users")
        .where("universityKey", isEqualTo: myUniversityKey)
        .where("courseKey", isEqualTo: myCourseKey);

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final docs = snapshot.data?.docs ?? [];

        // ✅ filter mentors: exclude self + higher year only
        final mentors = docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final uid = (data["uid"] ?? "").toString();
          final year = (data["year"] ?? "").toString().trim();

          if (uid == myUid) return false;
          if (year.isEmpty) return false;
          if (!isHigherYear(year)) return false;

          return true;
        }).toList();

        if (mentors.isEmpty) {
          return const Center(
            child: Text(
              "No mentors found.\nTry updating your Course / University / Year.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: mentors.length,
          itemBuilder: (context, index) {
            final doc = mentors[index];
            final m = doc.data() as Map<String, dynamic>;

            final name = (m["name"] ?? "Mentor").toString();
            final college = (m["college"] ?? "College").toString();
            final year = (m["year"] ?? "").toString();
            final skills = (m["skills"] ?? "Not added").toString();

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
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: themeBlue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "$myCourse • $year • $college",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("Skills: $skills", style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Viewing $name profile (soon) ✅")),
                            );
                          },
                          icon:
                              const Icon(Icons.visibility, color: themeBlue),
                          label: const Text(
                            "View Profile",
                            style: TextStyle(color: themeBlue),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: themeBlue),
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
                              SnackBar(
                                  content: Text("Chat with $name (soon) ✅")),
                            );
                          },
                          icon: const Icon(Icons.chat, color: Colors.white),
                          label: const Text(
                            "Chat",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeBlue,
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
      },
    );
  }
}
