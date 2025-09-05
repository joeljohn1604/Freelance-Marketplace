import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelance_5/services/database_service.dart';
import 'dart:ui';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _qualitiesController = TextEditingController();
  final _qualification_Controller = TextEditingController();
  final _databaseService = DatabaseService();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _qualitiesController.dispose();
    _qualification_Controller.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userData = await _databaseService.getUserData(userId);

      if (userData != null) {
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _roleController.text = userData['role'] ?? '';
          _qualitiesController.text = userData['qualities'] ?? '';
          _qualification_Controller.text = userData['qualifications'] ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load profile data. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        await _databaseService.updateUserData(
          userId,
          {
            'name': _nameController.text.trim(),
            'role': _roleController.text.trim(),
            'qualities': _qualitiesController.text.trim(),
            'qualifications': _qualification_Controller.text.trim(),
            'updatedAt': DateTime.now(),
          },
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update profile. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.grey.withOpacity(0.1), // Reduced opacity
        elevation: 0, // Remove shadow for a cleaner look
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.deepPurple,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          // 🔳 Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.3, // 👈 Adjust the background image opacity here
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img_1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.1), // 👈 Optional: add a subtle dark tint overlay
                ),
              ],
            ),
          ),

          // 🌫️ Frosted Glass with form
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Your Profile',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${FirebaseAuth.instance.currentUser!.email}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _roleController,
                                decoration: const InputDecoration(
                                  labelText: 'Professional Role',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your professional role';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _qualitiesController,
                                decoration: const InputDecoration(
                                  labelText: 'Key Qualities/Skills',
                                  border: OutlineInputBorder(),
                                  hintText: 'e.g., Creative, Detail-oriented, Flutter, React',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your qualities or skills';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _qualification_Controller,
                                decoration: const InputDecoration(
                                  labelText: 'Experience in the field',
                                  border: OutlineInputBorder(),
                                  hintText: 'Number of years of experience in the field',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the Qualifications';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF6750A4),
                        foregroundColor: Colors.white,
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Changes', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}

