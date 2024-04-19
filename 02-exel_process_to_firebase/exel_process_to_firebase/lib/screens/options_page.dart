
import '../screens/batch_creation_page.dart';
import 'package:flutter/material.dart';
import 'add_update_faculty.dart';
import 'add_update_student.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  OptionPageState createState() => OptionPageState();
}

class OptionPageState extends State<OptionPage> {
  int selectedOption = 1; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Option Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select an option:',
              style: TextStyle(fontSize: 18),
            ),
            RadioListTile(
              title: const Text('Create Batch'),
              value: 1,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text('Add/Update Faculty'),
              value: 2,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
            RadioListTile(
              title: const Text('Add/Update Student'),
              value: 3,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _navigateToSelectedPage(context);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSelectedPage(BuildContext context) {
    switch (selectedOption) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BatchCreationPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddOrUpdateFaculty()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddOrUpdateStudentPage()),
        );
        break;
      default:
      // Handle unexpected case
        break;
    }
  }
}

class CreateBatchPage extends StatelessWidget {
  const CreateBatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Batch'),
      ),
      body: const Center(
        child: Text('Create Batch Content'),
      ),
    );
  }
}

class AddUpdateFacultyPage extends StatelessWidget {
  const AddUpdateFacultyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Update Faculty'),
      ),
      body: const Center(
        child: Text('Add/Update Faculty Content'),
      ),
    );
  }
}

class AddUpdateStudentPage extends StatelessWidget {
  const AddUpdateStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Update Student'),
      ),
      body: const Center(
        child: Text('Add/Update Student Content'),
      ),
    );
  }
}