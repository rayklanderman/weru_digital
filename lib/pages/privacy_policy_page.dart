import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy for Weru Digital App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: June 26, 2025',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Information We Collect',
              content:
                  'The Weru Digital app may collect the following information:\n\n'
                  '• Device information (device type, operating system version, unique device identifiers)\n'
                  '• Log data (IP address, browser type, pages visited, access times)\n'
                  '• Usage information (features used, time spent on the app, interactions with content)',
            ),
            _buildSection(
              title: '2. How We Use Your Information',
              content:
                  'We use the collected information to:\n\n'
                  '• Provide, maintain, and improve our services\n'
                  '• Personalize your experience\n'
                  '• Analyze app usage and trends\n'
                  '• Respond to your inquiries and provide support',
            ),
            _buildSection(
              title: '3. Data Security',
              content:
                  'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet or electronic storage is 100% secure.',
            ),
            _buildSection(
              title: '4. Third-Party Services',
              content:
                  'Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties.',
            ),
            _buildSection(
              title: '5. Children\'s Privacy',
              content:
                  'Our services are not directed to individuals under 13. We do not knowingly collect personal information from children under 13.',
            ),
            _buildSection(
              title: '6. Changes to This Policy',
              content:
                  'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchEmail('info@werudigital.co.ke'),
              child: const Text(
                'Email: info@werudigital.co.ke',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchUrl('https://werudigital.co.ke'),
              child: const Text(
                'Website: https://werudigital.co.ke',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'By using our app, you agree to the collection and use of information in accordance with this policy.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.6),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
