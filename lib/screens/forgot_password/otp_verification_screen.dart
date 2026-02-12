import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graville_operations/screens/commons/assets/images.dart';
import 'package:pinput/pinput.dart';
import 'package:graville_operations/screens/commons/widgets/custom_button.dart';
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
        setState(() => _isExpired = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _verifyOtp() {
    if (_isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP has expired. Please resend.')),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
      }
    }
  }

  void _resendOtp() {
    setState(() {
      currentOtp = _generateOtp();
      _otpController.clear();
    });

    debugPrint('Resend OTP: $currentOtp');

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
    final theme = Theme.of(context);

    final basePinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: theme.textTheme.titleLarge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    CommonImages.otpverification,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'OTP Verification',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _isExpired
                      ? 'OTP expired'
                      : 'OTP expires in $_secondsRemaining seconds',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _isExpired
                        ? theme.colorScheme.error
                        : theme.hintColor,
                  ),
                ),

                const SizedBox(height: 30),

                Pinput(
                  controller: _otpController,
                  length: 6,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: basePinTheme,
                  focusedPinTheme: basePinTheme.copyWith(
                    decoration: basePinTheme.decoration!.copyWith(
                      border: Border.all(color: theme.colorScheme.primary),
                    ),
                  ),
                  submittedPinTheme: basePinTheme,
                  validator: (value) =>
                      value?.length == 6 ? null : 'Enter a valid 6-digit OTP',
                  //onCompleted: (_) => _verifyOtp(),
                ),

                const SizedBox(height: 24),

                CustomButton(label: "Verify OTP", onPressed: _verifyOtp),

                const SizedBox(height: 12),

                CustomButton(label: "Resend OTP", onPressed: _resendOtp),

                // TextButton(
                //   onPressed: _isExpired ? _resendOtp : null,
                //   child: const Text('Resend OTP'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
