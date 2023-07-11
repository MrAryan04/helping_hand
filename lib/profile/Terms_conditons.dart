import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed aliquet ante eu eleifend ultrices. In tristique enim vitae '
                'ligula condimentum auctor. Phasellus bibendum ante et dui '
                'placerat, at lacinia mi vehicula. Sed nec dolor augue. '
                'Nullam rutrum ultricies orci vitae dignissim. Duis iaculis '
                'aliquet elit, nec aliquet justo venenatis in. Aenean congue '
                'quis turpis a mattis. Nulla facilisi. Sed a lorem in risus '
                'tristique molestie sed sit amet leo.',
              ),
              SizedBox(height: 16),
              Text(
                '1. Lorem ipsum dolor sit amet.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed aliquet ante eu eleifend ultrices.',
              ),
              SizedBox(height: 8),
              Text(
                '2. Lorem ipsum dolor sit amet.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed aliquet ante eu eleifend ultrices.',
              ),
              SizedBox(height: 8),
              Text(
                '3. Lorem ipsum dolor sit amet.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed aliquet ante eu eleifend ultrices.',
              ),

              // Add more terms and conditions text as needed
            ],
          ),
        ),
      ),
    );
  }
}
