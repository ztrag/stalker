import 'package:flutter/material.dart';
import 'package:stalker/theme/loading_text.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                height: 200,
                // height: ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.transparent,
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/cheers.jpg'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('v0.0.0', style: Theme.of(context).textTheme.bodySmall!),
              const LoadingText(length: 1000),
            ],
          ),
        ),
      )),
    );
  }
}
