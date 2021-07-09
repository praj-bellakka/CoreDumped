import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getFilePath() async {
  Directory appDocumentsDirectory = await getExternalStorageDirectory();
  String appDocumentsPath = appDocumentsDirectory.path;
  print("file path is $appDocumentsPath \n");
  String filePath = '$appDocumentsPath/demoFile.txt';

  return filePath;
}

void saveFile(List<List<double>> arrayOfDurations) async {
  File file = File(await getFilePath());
  file.writeAsString("");
  await file.writeAsString("${arrayOfDurations.length}\n", mode: FileMode.append);
  for (int i = 0; i < arrayOfDurations.length; i++) {
    for (int j = 0; j < arrayOfDurations.length; j++) {
      if (arrayOfDurations[i][j] == null) {
        await file.writeAsString("", mode: FileMode.append);
      } else {
        await file.writeAsString("${arrayOfDurations[i][j]}\n",
            mode: FileMode.append);
      }
    }
    // await file.writeAsString("\n", mode: FileMode.append);
  }
  print("saved");
}
