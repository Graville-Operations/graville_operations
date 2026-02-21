import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/assets/images.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= HEADER IMAGE =================
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  CommonImages.Worker,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              // ================= CONTACT INFORMATION =================
              _buildSectionCard(
                title: "CONTACT INFORMATION",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Marcus Johnson",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildInfoRow(
                      icon: Icons.phone,
                      label: "Phone Number",
                      value: "+254 755 234 567",
                    ),

                    const SizedBox(height: 16),

                    _buildInfoRow(
                      icon: Icons.badge,
                      label: "National ID",
                      value: "402456",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= PROFESSIONAL DETAILS =================
              _buildSectionCard(
                title: "PROFESSIONAL DETAILS",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildInfoRow(
                      icon: Icons.apartment,
                      label: "Department",
                      value: "Electrical",
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.verified, color: Colors.blue),
                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Skill Level",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Skilled",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildInfoRow(
                      icon: Icons.calendar_month,
                      label: "Join Date",
                      value: "March 2014",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= CURRENT ASSIGNMENT =================
              _buildSectionCard(
                title: "CURRENT ASSIGNMENT",
                child: _buildInfoRow(
                  icon: Icons.trending_up,
                  label: "Active Project",
                  value: "Riverside Plaza - Tower B",
                  iconColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SECTION CARD =================
  Widget _buildSectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }

  // ================= INFO ROW =================
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = Colors.blue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Icon(icon, color: iconColor),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}