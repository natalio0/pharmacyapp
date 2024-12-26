import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailSender {
  static Future<void> sendEmailWithAttachment({
    required String toEmail,
    required String subject,
    required String body,
    required String attachmentPath,
  }) async {
    final email = Email(
      recipients: [toEmail],
      subject: subject,
      body: body,
      attachmentPaths: [attachmentPath],
    );

    await FlutterEmailSender.send(email);
  }
}
