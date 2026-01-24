import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color themeBlue = Color(0xFF4A00E0);

  // ✅ Controllers
  final TextEditingController universityController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isSaving = false;

  // ✅ Allowed values for dropdown
  final List<String> yearList = const [
    "1st Year",
    "2nd Year",
    "3rd Year",
    "Final Year",
    "Passout",
  ];

  // ✅ Default dropdown selection
  String selectedYearStatus = "1st Year";

  @override
  void initState() {
    super.initState();
    loadExistingData();
  }

  // ✅ Normalize function (important for mentor matching)
  String normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r"\s+"), " ");
  }

  // ✅ Load existing profile data
  Future<void> loadExistingData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      final uid = user.uid;

      final doc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (doc.exists) {
        final data = doc.data();

        universityController.text = (data?["university"] ?? "").toString();
        collegeController.text = (data?["college"] ?? "").toString();
        courseController.text = (data?["course"] ?? "").toString();
        skillsController.text = (data?["skills"] ?? "").toString();

        String savedYear = (data?["year"] ?? "").toString();

        // ✅ ensure dropdown always has valid value
        if (yearList.contains(savedYear)) {
          selectedYearStatus = savedYear;
        } else {
          selectedYearStatus = "1st Year";
        }
      }

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data: $e")),
      );
    }
  }

  // ✅ Save profile (with normalized keys)
  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;

      final university = universityController.text.trim();
      final college = collegeController.text.trim();
      final course = courseController.text.trim();
      final skills = skillsController.text.trim();

      // ✅ extra fields for mentor matching
      final universityKey = normalize(university);
      final courseKey = normalize(course);

      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "university": university,
        "college": college,
        "course": course,
        "skills": skills,
        "year": selectedYearStatus,

        // ✅ IMPORTANT (for mentor suggestion matching)
        "universityKey": universityKey,
        "courseKey": courseKey,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully ✅")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update failed: $e")),
      );
    }

    if (!mounted) return;
    setState(() => isSaving = false);
  }

  @override
  void dispose() {
    universityController.dispose();
    collegeController.dispose();
    courseController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  // ✅ Input field widget
  Widget buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: themeBlue),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ✅ Dropdown widget
  Widget buildYearDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: selectedYearStatus,
        decoration: InputDecoration(
          labelText: "Year",
          prefixIcon:
              const Icon(Icons.calendar_month_outlined, color: themeBlue),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: yearList.map((year) {
          return DropdownMenuItem(
            value: year,
            child: Text(year),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedYearStatus = value!;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildField(
                        label: "University",
                        controller: universityController,
                        icon: Icons.school_outlined,
                      ),
                      buildField(
                        label: "College",
                        controller: collegeController,
                        icon: Icons.apartment_outlined,
                      ),
                      buildField(
                        label: "Course",
                        controller: courseController,
                        icon: Icons.book_outlined,
                      ),

                      // ✅ Year dropdown
                      buildYearDropdown(),

                      buildField(
                        label: "Skills",
                        controller: skillsController,
                        icon: Icons.lightbulb_outline,
                      ),

                      const SizedBox(height: 20),

                      // ✅ Save button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Save Changes",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
