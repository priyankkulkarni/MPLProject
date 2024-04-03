import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';


class BarPage extends StatefulWidget {
  const BarPage({Key? key}) : super(key: key);

  @override
  State<BarPage> createState() => _BarPageState();
}

class _BarPageState extends State<BarPage> {
  final _formKey = GlobalKey<FormState>(); // For form validation

  String _city = '';
  int _days = 0;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  double _budget = 0.0;
  String _openAIResponse = '';
  String _openAIError = '';

  Future<void> _callOpenAI() async {
    try {
      // Replace 'YOUR_OPENAI_API_KEY' with your actual key
      OpenAI.apiKey = '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';
      String prompt =
          'Create a day wise trip plan for a $_days day trip to $_city in Rs $_budget';

      // Use OpenAI.instance.completions.create(...)
      OpenAICompletionModel response = await OpenAI.instance.completion.create(
        model: 'davinci-002', // Choose an appropriate OpenAI engine
        prompt: prompt,
        maxTokens: 1000, // Adjust maxTokens for response length
        n: 1,
        stop: null,
        temperature: 0.7,
      );

      setState(() {
        _openAIResponse = response.choices!.first.text.trim();

        _openAIError = '';
      });
    } catch (error) {
      setState(() {
        _openAIError = 'Error: ${error.toString()}';
        _openAIResponse = '';
      });
      print(error); // Print the complete error message for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _city = value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Number of Days'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter number of days';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _days = int.parse(value!)),
              ),
              Row(
                children: [
                  const Text('Start Date: '),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() => _startDate = pickedDate);
                      }
                    },
                    child: Text(_startDate.toString().split(' ').first),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('End Date: '),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() => _endDate = pickedDate);
                      }
                    },
                    child: Text(_endDate.toString().split(' ').first),
                  ),
                ],
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Budget(in Rupees)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a budget';
                  }
                  return null;
                },
                onSaved: (value) =>
                    setState(() => _budget = double.parse(value!)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _callOpenAI();
                  }
                },
                child: const Text('Generate Plan '),
              ),
              if (_openAIResponse.isNotEmpty)
                Container(
                  height: 300.0, // Adjust height as needed
                  child: SingleChildScrollView(
                    // Allow scrolling within response
                    child: Text(
                      _openAIResponse,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

