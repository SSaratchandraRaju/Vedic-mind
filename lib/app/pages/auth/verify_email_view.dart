import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import '../../controllers/verify_email_controller.dart';
import '../../routes/app_routes.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';

class VerifyEmailView extends GetView<VerifyEmailController> {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.offAllNamed(Routes.LOGIN),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [AppColors.yellow.withOpacity(0.15), AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final verified = controller.isVerified.value;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    verified ? 'Email verified!' : 'Verify your email',
                    style: AppTextStyles.h2.copyWith(fontSize: 26, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    verified
                        ? 'Great! Redirecting...'
                        : 'We sent a verification link to ${controller.maskedEmail}. Tap the link in your inbox to continue.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (!verified)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: (controller.secondsRemaining.value == 0 && !controller.isSending.value)
                            ? controller.resendEmail
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          disabledBackgroundColor: AppColors.gray300,
                        ),
                        child: controller.isSending.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                controller.secondsRemaining.value == 0
                                    ? 'Resend Verification Email'
                                    : 'Resend available in ${controller.secondsRemaining.value}s',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                      ),
                    ),
                  if (!verified) const SizedBox(height: 18),
                  if (!verified)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: controller.refreshStatus,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'I Verified',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  if (!verified) const SizedBox(height: 12),
                  if (!verified)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: _openMailApp,
                        icon: const Icon(Icons.mail_outline),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        label: const Text(
                          'Open Mail App',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  if (!verified) const SizedBox(height: 28),
                  if (!verified)
                    Text(
                      'We auto-check every 12s. If you cannot find the email, check spam or add our address to trusted senders.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  if (verified) const LinearProgressIndicator(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> _openMailApp() async {
    try {
      if (Platform.isAndroid) {
        // Try Gmail by package name
        const gmailPackage = 'com.google.android.gm';
        final gmailIntent = AndroidIntent(
          action: 'android.intent.action.VIEW',
          package: gmailPackage,
          componentName: 'com.google.android.gm/.ConversationListActivityGmail',
        );
        await gmailIntent.launch().then((_) async {
          // If it returns early, we assume success; there is no direct success callback.
        }).catchError((_) async {
          // Try generic email intent MIME type
          final genericIntent = AndroidIntent(
            action: 'android.intent.action.SENDTO',
            data: 'mailto:',
          );
          await genericIntent.launch().catchError((_) async {
            // Fallback to Gmail web
            final gmailWeb = Uri.parse('https://mail.google.com/mail/u/0/#inbox');
            if (await canLaunchUrl(gmailWeb)) {
              await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
            } else {
              Get.snackbar('Open Mail', 'No mail app found', snackPosition: SnackPosition.BOTTOM);
            }
          });
        });
        return;
      } else if (Platform.isIOS) {
        // iOS Mail scheme
        final iosMail = Uri.parse('message://');
        if (await canLaunchUrl(iosMail)) {
          await launchUrl(iosMail);
          return;
        }
        // Fallback to mailto compose
        final mailto = Uri.parse('mailto:');
        if (await canLaunchUrl(mailto)) {
          await launchUrl(mailto);
          return;
        }
        // Safari Gmail
        final gmailWeb = Uri.parse('https://mail.google.com/mail/u/0/#inbox');
        if (await canLaunchUrl(gmailWeb)) {
          await launchUrl(gmailWeb);
          return;
        }
        Get.snackbar('Open Mail', 'Unable to open a mail application', snackPosition: SnackPosition.BOTTOM);
      } else {
        // Other platforms: open Gmail web or mailto
        final gmailWeb = Uri.parse('https://mail.google.com/mail/u/0/#inbox');
        if (await canLaunchUrl(gmailWeb)) {
          await launchUrl(gmailWeb);
          return;
        }
        final mailto = Uri.parse('mailto:');
        if (await canLaunchUrl(mailto)) {
          await launchUrl(mailto);
          return;
        }
        Get.snackbar('Open Mail', 'No suitable mail handler', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Open Mail', 'Error launching mail: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}

// Removed StatusChip per updated UI requirements.
