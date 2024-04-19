import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../error_check/batch_error_check.dart';
import '../firebase_operations/push_batch.dart';
import '../preprocessor/excel_processor.dart';

class BatchCreationPage extends StatefulWidget {
  const BatchCreationPage({Key? key}) : super(key: key);

  @override
  BatchCreationPageState createState() => BatchCreationPageState();
}

class BatchCreationPageState extends State<BatchCreationPage> {
  String _batchName = '';
  String _seniorTutorId = '';
  String _selectedFileName = '';
  FilePickerResult? result;
  ExcelProcessor excelProcessor = ExcelProcessor();
  List<List<List<dynamic>>> allExcelData = [];
  bool _processingExcel = false;
  BatchErrorCheck batchErrorCheck = BatchErrorCheck();

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
          buildTextFormField('Batch Year (e.g., 2022-2025)', (value) {
            setState(() {
              _batchName = value;
            });
          }),
          const SizedBox(height: 16.0),
          buildTextFormField('Senior Tutor ID', (value) {
            setState(() {
              _seniorTutorId = value;
            });
          }),
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
         const Icon(
                Icons.cloud_upload,
                size: 200,
              ),
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
          onPressed: _processingExcel ? null : _processExcel,
          child: Text(
            _processingExcel ? 'Processing...' : 'Process Excel',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Future<void> _processExcel() async {
    setState(() {
      _processingExcel = true;
    });

    // Simulate a delay of 1 second (for demonstration purposes)
    await Future.delayed(const Duration(seconds: 1));

    // Validate batch name
    String batchMessage = batchErrorCheck.checkBatchName(_batchName);
    if (batchMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(batchMessage),
      ));
      setState(() {
        _processingExcel = false;
      });
      return;
    }

    // Validate senior tutor ID
    String seniorTutorMessage =
        batchErrorCheck.checkSeniorTutorId(_seniorTutorId);
    if (seniorTutorMessage.isNotEmpty) if (seniorTutorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(seniorTutorMessage),
      ));
      setState(() {
        _processingExcel = false;
      });
      return;
    }

    // Validate Excel file headers
    String excelMessage = await batchErrorCheck.checkExcelHead(result);
    if (excelMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(excelMessage),
      ));
      setState(() {
        _processingExcel = false;
      });
      return;
    }

    // Proceed with your existing logic...

    // Show dialog box for confirmation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Do you want to continue processing the Excel file?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _continueProcessing();
              },
              child: Text('Continue'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _processingExcel = false;
                });
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _continueProcessing() async {
    // Show dialog with loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Processing..."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Please wait while processing..."),
            ],
          ),
        );
      },
    );

    // Perform Firebase operation
    allExcelData = await excelProcessor.processExcelSheet(context, result);
    PushBatch batch = PushBatch(_batchName, _seniorTutorId);
    batch.pushBatchData(allExcelData);

    // Close dialog
    Navigator.of(context).pop(); // Close the "Processing..." dialog

    // Show completion message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Processing completed."),
    ));

    // Reset state
    setState(() {
      _processingExcel = false;
    });
  }
}
