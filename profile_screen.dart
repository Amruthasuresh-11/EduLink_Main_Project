import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeBlue =  Color(0xFF4A00E0);

    const TextStyle detailStyle = TextStyle(
      fontSize: 14,
      color: Colors.black87, // ✅ same color
      height: 1.5,
    );

    return Scaffold(
      body: SingleChildScrollView(
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
                    child: const Icon(Icons.person, size: 45, color: Colors.white),
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
                            IconButton(
                              icon: const Icon(Icons.edit, color: themeBlue),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_box_outlined, color: themeBlue),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.upload_file, color: themeBlue),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.logout, color: Colors.red),
                              onPressed: () {},
                            ),
                          ],
                        ),

                        // ✅ Name & details
                        const Text(
                          "Amrutha Suresh",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),

                        const Text("University : MG University", style: detailStyle),
                        const Text("College : ABC College", style: detailStyle),
                        const Text("Course : MCA", style: detailStyle),
                        const Text("Year : Final Year", style: detailStyle),
                        const Text(
                          "Skills : Flutter • Firebase • UI Design",
                          style: detailStyle,
                        ),
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
                        backgroundColor: themeBlue, // ✅ same as nav / top
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Notes",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Message",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ✅ Posts title
              const Text(
                "Posts",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // ✅ Post area box (we will add grid later)
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
