import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AssignUserToGroupScreen extends StatefulWidget {
  const AssignUserToGroupScreen({super.key});

  @override
  State<AssignUserToGroupScreen> createState() =>
      _AssignUserToGroupScreenState();
}

class _AssignUserToGroupScreenState extends State<AssignUserToGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _groupIdController = TextEditingController();

  bool _isLoading = false;
  String? _toastMessage;
  bool _toastSuccess = true;

  @override
  void dispose() {
    _userIdController.dispose();
    _groupIdController.dispose();
    super.dispose();
  }

  Future<void> _assign() async {
    // Always validate — shows errors on empty fields
    if (!_formKey.currentState!.validate()) return;

    final userId = _userIdController.text.trim();
    final groupId = _groupIdController.text.trim();
    final url = Uri.parse(
      'http://localhost:8000/api/v1/group/$userId/users?group_id=$groupId',
    );

    setState(() {
      _isLoading = true;
      _toastMessage = null;
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      String message = isSuccess
          ? 'User $userId assigned to group $groupId successfully.'
          : 'Something went wrong.';

      if (!isSuccess) {
        try {
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          message = (body['detail'] ?? body['message'] ?? message).toString();
        } catch (_) {}
        message = 'Error ${response.statusCode}: $message';
      }

      setState(() {
        _toastSuccess = isSuccess;
        _toastMessage = message;
        if (isSuccess) {
          _userIdController.clear();
          _groupIdController.clear();
        }
      });
    } catch (e) {
      setState(() {
        _toastSuccess = false;
        _toastMessage = 'Network error: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  OutlineInputBorder _border({double width = 1.2, Color? color}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color ?? Colors.grey.shade400,
          width: width,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D9E75),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Assign User to Group',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'User ID',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _userIdController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Enter user ID  e.g. 101',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.black87,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder:
                      _border(width: 1.8, color: const Color(0xFF1D9E75)),
                  errorBorder: _border(color: Colors.grey.shade400),
                  focusedErrorBorder:
                      _border(width: 1.8, color: Colors.grey.shade500),
                  errorStyle:
                      TextStyle(color: const Color.fromARGB(255, 237, 29, 29)),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'User ID is required'
                    : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Group ID',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _groupIdController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Enter group ID  e.g. 5',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.group_outlined,
                    color: Colors.black87,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder:
                      _border(width: 1.8, color: const Color(0xFF1D9E75)),
                  errorBorder: _border(color: Colors.grey.shade400),
                  focusedErrorBorder:
                      _border(width: 1.8, color: Colors.grey.shade500),
                  errorStyle:
                      TextStyle(color: const Color.fromARGB(255, 237, 29, 29)),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Group ID is required'
                    : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _assign,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    disabledBackgroundColor: const Color(0xFF1A73E8),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color(0xFF1558B0),
                        width: 2,
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Assign User to Group',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                ),
              ),
              if (_toastMessage != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _toastSuccess
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _toastSuccess
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _toastSuccess
                            ? Icons.check_circle_outline_rounded
                            : Icons.error_outline_rounded,
                        color: _toastSuccess
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _toastMessage!,
                          style: TextStyle(
                            color: _toastSuccess
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
