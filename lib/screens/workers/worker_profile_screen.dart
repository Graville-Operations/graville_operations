import 'package:flutter/material.dart';
import 'package:graville_operations/models/worker_model.dart';
<<<<<<< HEAD
=======

>>>>>>> main

class WorkerProfileScreen extends StatelessWidget {
  final Worker worker;

  const WorkerProfileScreen({super.key, required this.worker});

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
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: worker.imageUrl != null
                    ? Image.network(
                        worker.imageUrl!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholderImage(),
                      )
                    : _placeholderImage(),
              ),

              const SizedBox(height: 20),

              _buildSectionCard(
                title: "CONTACT INFORMATION",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.fullName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: "Phone Number",
                      value: worker.phoneNumber.isNotEmpty
                          ? worker.phoneNumber
                          : '—',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.badge,
                      label: "National ID",
                      value: worker.nationalId > 0
                          ? worker.nationalId.toString()
                          : '—',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildSectionCard(
                title: "PROFESSIONAL DETAILS",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      icon: Icons.apartment,
                      label: "Task / Specialty",
                      value: worker.taskId != null
                          ? 'Task #${worker.taskId}'
                          : '—',
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
                                color:
                                    worker.skillType.toLowerCase() == 'skilled'
                                        ? Colors.blue
                                        : Colors.grey.shade500,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                worker.skillType.isNotEmpty
                                    ? worker.skillType
                                    : 'Unknown',
                                style: const TextStyle(
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
                      label: "Joined Date",
                      value: worker.createdAt != null
                          ? '${worker.createdAt!.day}/${worker.createdAt!.month}/${worker.createdAt!.year}'
                          : '—',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Site assignment
              _buildSectionCard(
                title: "CURRENT ASSIGNMENT",
                child: _buildInfoRow(
                  icon: Icons.location_on,
                  label: "Site ID",
                  value: worker.siteId != null
                      ? 'Site #${worker.siteId}'
                      : 'Not assigned',
                  iconColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(Icons.person, size: 80, color: Colors.grey),
    );
  }

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
          ),
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
              style: const TextStyle(fontSize: 13, color: Colors.grey),
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
