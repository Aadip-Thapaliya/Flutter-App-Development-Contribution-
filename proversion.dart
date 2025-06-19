import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upgrade to Pro',
      theme: ThemeData.dark(),
      home: const ProVersionPurchasePage(),
    );
  }
}

class ProVersionPurchasePage extends StatelessWidget {
  const ProVersionPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Pro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unlock Pro Features',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Get real-time stock alerts, advanced analytics, an ad-free experience, and priority support.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const ProFeaturesCard(),
            const SizedBox(height: 24),
            const Text(
              'Pricing Plans',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const PricingPlansCard(),
          ],
        ),
      ),
    );
  }
}

class ProFeaturesCard extends StatelessWidget {
  const ProFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            FeatureListTile(
              icon: Icons.notifications_active,
              title: 'Real-time Stock Alerts',
              subtitle: 'Get instant notifications for stock price changes.',
            ),
            FeatureListTile(
              icon: Icons.analytics,
              title: 'Advanced Analytics',
              subtitle: 'Access in-depth analysis tools for better investment decisions.',
            ),
            FeatureListTile(
              icon: Icons.ad_units,
              title: 'Ad-Free Experience',
              subtitle: 'Enjoy an uninterrupted experience without ads.',
            ),
            FeatureListTile(
              icon: Icons.support_agent,
              title: 'Priority Support',
              subtitle: 'Receive faster and more personalized assistance.',
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class PricingPlansCard extends StatelessWidget {
  const PricingPlansCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const PricingOption(
              price: '\$9.99/month',
              period: 'Monthly',
              isBestValue: false,
            ),
            const SizedBox(height: 16),
            const PricingOption(
              price: '\$99.99/year',
              period: 'Yearly',
              isBestValue: true,
            ),
          ],
        ),
      ),
    );
  }
}

class PricingOption extends StatelessWidget {
  final String price;
  final String period;
  final bool isBestValue;

  const PricingOption({
    super.key,
    required this.price,
    required this.period,
    required this.isBestValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
        color: isBestValue ? Colors.green.withOpacity(0.1) : Colors.transparent,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                period,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (isBestValue)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Best Value',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle upgrade logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Upgrade Now'),
            ),
          ),
        ],
      ),
    );
  }
}
