import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class BatchErrorCheck {
  List<List<List<dynamic>>> requiredColumns = [
    [
      ["roll_no", "student_name", "college_email", "phone_no", "section", "parent_name", "parent_email", "parent_ph_no"]
    ],
    [
      ["faculty_id", "course_id", "section"]
    ],
    [
      ["Tutor", "section"]
    ]
  ];

  String checkBatchName(String batchName) {
    if (batchName.isEmpty) {
      return 'Please enter batch Year';
    } else {
      // Split the batchName by '-'
      List<String> years = batchName.split('-');

      // Ensure there are exactly two elements
      if (years.length == 2) {
        // Attempt to parse years as integers
        try {
          int firstYear = int.parse(years[0]);
          int secondYear = int.parse(years[1]);

          // Calculate the difference
          int difference = secondYear - firstYear;

          // Check if the difference is exactly 4
          if (difference == 4) {
            return '';
          } else {
            return 'Batch year should span exactly 4 years.';
          }
        } catch (e) {
          // Catch parsing errors
          return 'Invalid batch year format.';
        }
      } else {
        return 'Invalid batch year format.';
      }
    }
  }


  String checkSeniorTutorId(String seniorTutorId) {
    if (seniorTutorId.isEmpty) {
      return 'Please enter senior tutor ID';
    } else {
      return '';
    }
  }

  Future<String> checkExcelHead(FilePickerResult? result) async {
    if (result == null) {
      return "No file selected";
    }

    try {
      File file = File(result.files.single.path!);
      List<List<List<dynamic>>> firstRowData = await processFirstRowExcelSheet(file);
      return compareColumns(firstRowData) ? "" : "Columns are not in correct order";
    } catch (e) {
      print('Error picking or processing Excel file: $e');
      return "Error processing Excel file";
    }
  }

  Future<List<List<List<dynamic>>>> processFirstRowExcelSheet(File file) async {
    try {
      var bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);
      List<List<List<dynamic>>> allExcelData = [];

      for (var table in excel.tables.keys) {
        List<List<dynamic>> excelData = [];
        var sheet = excel.tables[table]!;
        if (sheet.rows.isNotEmpty) {
          var firstRow = sheet.rows.first;
          var rowData = firstRow.map((cell) => cell?.value).toList();
          excelData.add(removeTrailingNulls(rowData));
        }
        if (excelData.isNotEmpty) {
          allExcelData.add(excelData);
        }
      }
      return allExcelData;
    } catch (e) {
      print('Error reading Excel file: $e');
      return [];
    }
  }

  List<dynamic> removeTrailingNulls(List<dynamic> rowData) {
    while (rowData.isNotEmpty && rowData.last == null) {
      rowData.removeLast();
    }
    return rowData;
  }

  bool compareColumns(List<List<List<dynamic>>> processedArray) {
    List<dynamic> flattenedProcessedArray = [];
    for (var array2D in processedArray) {
      for (var array1D in array2D) {
        flattenedProcessedArray.addAll(array1D);
      }
    }

    List<dynamic> flattenedRequiredColumns = [];
    for (var array2D in requiredColumns) {
      for (var array1D in array2D) {
        flattenedRequiredColumns.addAll(array1D);
      }
    }

    if (flattenedProcessedArray.length != flattenedRequiredColumns.length) {
      return false;
    }

    for (int i = 0; i < flattenedProcessedArray.length; i++) {
      if (flattenedProcessedArray[i].toString() != flattenedRequiredColumns[i].toString()) {
        return false;
      }

    }

    return true;
  }
}
