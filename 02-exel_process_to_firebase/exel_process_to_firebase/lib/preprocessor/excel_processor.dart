import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class ExcelProcessor {


  String getFileNameWithExtension(FilePickerResult result) {
    if (result.files.isNotEmpty) {
      return result.files.single.name;
    } else {
      return 'Unknown File';
    }
  }

  Future<FilePickerResult?> uploadExcel() async
  {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      return result;
    }
  catch(e) {
  print('Error picking or processing Excel file: $e');
  }
    return null;

  }


  Future<List<List<List>>> processExcelSheet(BuildContext context,FilePickerResult? result) async {
    try {

      if (result != null) {
        File file = File(result.files.single.path!);
        return readExcelFile(file);
      } else {
        print('No file selected');
        return [];
      }
    } catch (e) {
      print('Error picking or processing Excel file: $e');
      return [];
    }
  }

  List<List<List<dynamic>>> readExcelFile(File file ,{bool skipFirstRow = true}) {
    List<List<List<dynamic>>> allExcelData = [];

    try {
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        List<List<dynamic>> excelData = [];


        bool isFirstRow = true;
        for (var row in excel.tables[table]!.rows) {

          if (isFirstRow && skipFirstRow) {
            isFirstRow = false;
            continue; // Skip the first row
          }
          if (row.any((cell) => cell != null && cell.value != null)) {
            // Skip rows with all null values
            var rowData = row.map((cell) => cell?.value).toList();
            excelData.add(removeTrailingNulls(rowData));
          }
        }

        if (excelData.isNotEmpty) {
          allExcelData.add(excelData);
        }
      }
    } catch (e) {
      print('Error reading Excel file: $e');
    }

    return allExcelData;
  }

  List<dynamic> removeTrailingNulls(List<dynamic> rowData) {
    // Iterate in reverse order and remove the last element if it's null
    while (rowData.isNotEmpty && rowData.last == null) {
      rowData.removeLast();
    }
    return rowData;
  }


}
