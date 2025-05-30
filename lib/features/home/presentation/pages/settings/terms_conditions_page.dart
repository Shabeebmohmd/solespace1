import 'package:flutter/material.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Terms & Conditions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(context, 'Account Terms', [
              'You must be at least 18 years old to use this service',
              'You are responsible for maintaining account security',
              'You must provide accurate and complete information',
              'You may not use the service for any illegal purposes',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Ordering and Payment', [
              'All prices are in the specified currency and include applicable taxes',
              'We reserve the right to refuse any order',
              'Payment must be made in full before order processing',
              'We accept various payment methods as displayed during checkout',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Shipping and Delivery', [
              'Delivery times are estimates and not guaranteed',
              'Shipping costs are calculated based on your location',
              'Risk of loss transfers to you upon delivery',
              'International shipping may be subject to customs duties',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Returns and Refunds', [
              'Items must be returned within 30 days of delivery',
              'Products must be unused and in original packaging',
              'Refunds will be processed within 7-14 business days',
              'Shipping costs for returns are the customer\'s responsibility',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Product Information', [
              'Product images are for illustrative purposes',
              'Colors may vary slightly from what is shown',
              'Sizes and measurements are approximate',
              'We reserve the right to modify product specifications',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Intellectual Property', [
              'All content on the app is our property',
              'You may not copy or reproduce any content',
              'Trademarks and logos are protected',
              'User-generated content grants us usage rights',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Limitation of Liability', [
              'We are not liable for indirect damages',
              'Our liability is limited to the purchase price',
              'We are not responsible for third-party services',
              'Force majeure events may affect our obligations',
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Contact Information', [
              'For general inquiries: support@sole-space.com',
              'For legal matters: legal@sole-space.com',
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
