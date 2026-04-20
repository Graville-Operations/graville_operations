import 'package:flutter/material.dart';
import 'package:graville_operations/core/commons/widgets/custom_text_input.dart';
class NoAccessScreen extends StatefulWidget {
  const NoAccessScreen({super.key});

  @override
  State<NoAccessScreen> createState() => _NoAccessScreenState();
}

class _NoAccessScreenState extends State<NoAccessScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // TODO: integrate email sending to administrator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Request sent! Administrator will reach out soon."),
          backgroundColor: Colors.blue.shade900,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 72,
                  color: Colors.blue.shade900,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                "No Access",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                "Your account has no menus assigned. "
                    "Fill in the form below and your administrator will be notified.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 32),

              // Contact Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade50,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Card header
                      Row(
                        children: [
                          Icon(Icons.support_agent, color: Colors.blue.shade900, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            "Contact Administrator",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "We'll forward your request to the admin for access configuration.",
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500, height: 1.4),
                      ),

                      const Divider(height: 28),

                      // Email field
                      Text(
                        "Your Email",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextInput(
                        controller: _emailController,
                        labelText: "Your Email",
                        hintText: "you@example.com",
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Message field
                      Text(
                        "Message",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextInput(
                        controller: _messageController,
                        labelText: "Message",
                        hintText: "Describe the access you need...",
                        prefixIcon: Icons.message_outlined,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe the access you need';
                          }
                          if (value.length < 10) {
                            return 'Message must be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitRequest,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: const Text("Send Request"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: call your logout method e.g controller.logout()
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue.shade900,
                    side: BorderSide(color: Colors.blue.shade900),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}