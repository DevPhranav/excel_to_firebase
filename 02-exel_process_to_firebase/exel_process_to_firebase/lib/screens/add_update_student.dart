
import '../firebase_operations/add_or_update_student_firebase.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../preprocessor/excel_processor.dart';

class AddOrUpdateStudentPage extends StatefulWidget {
  const AddOrUpdateStudentPage({super.key});

  @override
  AddOrUpdateStudentPageState createState() => AddOrUpdateStudentPageState();
}

class AddOrUpdateStudentPageState extends State<AddOrUpdateStudentPage> {
  String _batchName = '';
  String _selectedFileName = '';
  late AddOrUpdateStudentFirebase student;
  FilePickerResult? result;
  ExcelProcessor excelProcessor = ExcelProcessor();
  List<List<List<dynamic>>> allExcelData =[];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: buildBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Excel Upload'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Add any actions for the three-dot vertical icon
          },
        ),
      ],
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTopContainer(),
          buildSubBodyContainer(),
          buildBottomButton(),
        ],
      ),
    );
  }

  Widget buildTopContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextFormField('Batch Name', (value) {
            setState(() {
              _batchName = value;
            });
          }),
         const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget buildTextFormField(String label, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildSubBodyContainer() {
    return Container(
      width: 300,
      height: 300,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      child: buildFileUploadContent(),
    );
  }

  Widget buildFileUploadContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Upload Batch Excel File '),
        const Icon(Icons.cloud_upload, size: 200,),
        const SizedBox(width: 8.0),
        buildUploadContainer(),
      ],
    );
  }

  Widget buildUploadContainer() {
    return GestureDetector(
      onTap: () async {
        result = await excelProcessor.uploadExcel();
        String fileName = excelProcessor.getFileNameWithExtension(result!);
        setState(() {
          _selectedFileName = fileName;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tap to Upload'),
          ],
        ),
      ),
    );
  }

  Widget buildBottomButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Container displaying the selected file name
        if (_selectedFileName.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Selected File: $_selectedFileName',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),

        // Bottom button
        ElevatedButton(
          onPressed: ()  async{
            if (mounted) {
              student = AddOrUpdateStudentFirebase(batch_name: _batchName);
              allExcelData= await excelProcessor.processExcelSheet(context, result);
              student.addOrUpdateStudent(allExcelData);

            }
          },
          child: const Text(
            'Process Excel',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

}
