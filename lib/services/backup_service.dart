import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';

class BackupService {
  static Future<String> createBackup() async {
    final appDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${appDir.path}/backup');
    if (!await backupDir.exists()) {
      await backupDir.create();
    }
    final encoder = ZipFileEncoder();
    final zipPath = '${backupDir.path}/backup.zip';
    encoder.create(zipPath);
    await encoder.addDirectory(Directory(appDir.path), includeDirName: false);
    encoder.close();
    return zipPath;
  }

  static Future<void> restoreBackup(String zipPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('${appDir.path}/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('${appDir.path}/$filename').create(recursive: true);
      }
    }
  }
}
