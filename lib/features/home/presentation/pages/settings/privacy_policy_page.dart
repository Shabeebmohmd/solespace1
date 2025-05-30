import 'package:flutter/material.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(context, 'Information We Collect', [
              'Personal information (name, email, address)',
              'Payment information',
              'Order history and preferences',
              'Device information and usage data',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'How We Use Your Information', [
              'Process your orders and payments',
              'Communicate about your orders',
              'Send promotional offers (with your consent)',
              'Improve our services and user experience',
              'Prevent fraud and ensure security',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Information Sharing', [
              'We share information with payment processors',
              'Shipping partners for order delivery',
              'Service providers who assist our operations',
              'We do not sell your personal information',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Your Rights', [
              'Access your personal information',
              'Correct inaccurate data',
              'Request deletion of your data',
              'Opt-out of marketing communications',
              'Data portability',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Security', [
              'We implement industry-standard security measures',
              'Secure payment processing',
              'Regular security assessments',
              'Encrypted data transmission',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Contact Us', [
              'For privacy-related questions: privacy@sole-space.com',
              'For data requests: data@sole-space.com',
              'Last updated: ${DateTime.now().year}',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<String> points,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(
                  child: Text(
                    point,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
