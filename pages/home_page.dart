import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelance_5/components/company_card.dart';
import 'package:freelance_5/models/company_model.dart';
import 'package:freelance_5/pages/account_page.dart';
import 'package:freelance_5/services/auth_service.dart';
import 'dart:ui';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  bool _isLoading = true;
  List<CompanyModel> _companies = [];

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _companies = [
        CompanyModel(
          id: '1',
          name: 'Tech Innovators',
          description:
          'Leading software development company specializing in mobile apps and web solutions.',
          positions: ['Flutter Developer', 'UI/UX Designer', 'Project Manager'],
        ),
        CompanyModel(
          id: '2',
          name: 'Creative Solutions',
          description:
          'Digital agency focused on creating beautiful and functional digital experiences.',
          positions: ['Frontend Developer', 'Graphic Designer', 'Content Writer'],
        ),
        CompanyModel(
          id: '3',
          name: 'Data Insights',
          description:
          'Data analytics company helping businesses make data-driven decisions.',
          positions: ['Data Scientist', 'Machine Learning Engineer', 'Business Analyst'],
        ),
        CompanyModel(
          id: '4',
          name: 'Cloud Experts',
          description:
          'Cloud infrastructure and DevOps services for businesses of all sizes.',
          positions: ['DevOps Engineer', 'Cloud Architect', 'System Administrator'],
        ),
        CompanyModel(
          id: '5',
          name: 'Data Analyst',
          description:
          'Data Visualization of the datasets',
          positions: ['DevOps Engineer', 'Cloud Architect', 'System Administrator'],
        ),
        CompanyModel(
          id: '6',
          name: 'Design Engineer',
          description:
          'Software engineering',
          positions: ['DevOps Engineer', 'Cloud Architect', 'System Administrator'],
        ),
      ];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load companies. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sign out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.6),
        elevation: 0,
        title: const Text(
          'Freelance Marketplace',
          style: TextStyle(
            color: Color(0xFF6750A4),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Color(0xFF6750A4)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF6750A4)),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/img_1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _loadCompanies,
              child: _companies.isEmpty
                  ? const Center(
                child: Text('No companies available at the moment.'),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                itemCount: _companies.length,
                itemBuilder: (context, index) {
                  final company = _companies[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6), // Lower opacity for glass effect
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.6)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                company.description,
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children: company.positions.map((position) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      _showApplyDialog(context, company, position);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6750A4),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                    ),
                                    child: Text(position),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },

              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplyDialog(BuildContext context, CompanyModel company, String position) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apply to ${company.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Position: $position'),
            const SizedBox(height: 16),
            const Text(
              'Your profile information will be shared with this company. They will contact you if they are interested.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Applied to $position at ${company.name}'),
                  backgroundColor: Colors.green,
                ),
              );

              await FirebaseFirestore.instance.collection('applications').add({
                'userId': FirebaseAuth.instance.currentUser!.uid,
                'companyId': company.id,
                'position': position,
                'appliedAt': DateTime.now(),
              });
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
