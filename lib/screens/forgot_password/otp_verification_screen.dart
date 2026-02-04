import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graville_operations/screens/forgot_password/reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String generatedOtp;

  const OtpVerificationScreen({super.key, required this.generatedOtp});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  late String currentOtp;
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    currentOtp = widget.generatedOtp;
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _isExpired = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          _isExpired = true;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _verifyOtp() {
    if (_isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP has expired. Please resend.'),
          backgroundColor: Colors.blueAccent,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_otpController.text == currentOtp) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verified successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP'),
            backgroundColor: Colors.blueAccent,
          ),
        );
      }
    }
  }

  void _resendOtp() {
    setState(() {
      currentOtp = _generateOtp();
      _otpController.clear();
    });

    debugPrint('Resent OTP: $currentOtp');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('New OTP sent')));

    _startTimer();
  }

  String _generateOtp() {
    return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Verify OTP', style: TextStyle(color: Colors.white)),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_user,
                  size: 80,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 20),

                const Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  _isExpired
                      ? 'OTP expired'
                      : 'OTP expires in $_secondsRemaining seconds',
                  style: TextStyle(
                    color: _isExpired ? Colors.blueAccent : Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(color: Colors.white),

                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'OTP is required';
                    }
                    if (value.length != 6) {
                      return 'Enter a valid 6-digit OTP';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _verifyOtp,
                    child: const Text('Verify OTP'),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: _isExpired ? _resendOtp : null,
                  child: const Text(
                    'Resend OTP',
                    style: TextStyle(color: Colors.white),
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
