import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/event_model.dart';

class ImportCancelled implements Exception {
  const ImportCancelled();
}

class ImportInvalidFormat implements Exception {
  const ImportInvalidFormat();
}

class ImportIoError implements Exception {
  const ImportIoError();
}

class ExportIoError implements Exception {
  const ExportIoError();
}

class DataPortabilityService {
  static const _appTag = 'waktu_sejak';
  static const _schemaVersion = 1;

  static Future<void> exportEvents(List<EventModel> events) async {
    try {
      final payload = <String, dynamic>{
        'app': _appTag,
        'version': _schemaVersion,
        'exportedAt': DateTime.now().toIso8601String(),
        'events': events.map((e) => e.toJson()).toList(),
      };
      final jsonStr = jsonEncode(payload);
      final ts = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      final filename = 'waktu_sejak_backup_$ts.json';
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsString(jsonStr, flush: true);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/json', name: filename)],
        subject: 'Waktu Sejak backup',
      );
    } catch (_) {
      throw const ExportIoError();
    }
  }

  static Future<List<EventModel>> importEvents() async {
    final FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
    } catch (_) {
      throw const ImportIoError();
    }

    if (result == null || result.files.isEmpty) {
      throw const ImportCancelled();
    }

    final picked = result.files.single;
    List<int>? bytes = picked.bytes;
    if (bytes == null) {
      final path = picked.path;
      if (path == null) throw const ImportIoError();
      try {
        bytes = await File(path).readAsBytes();
      } catch (_) {
        throw const ImportIoError();
      }
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(bytes));
    } catch (_) {
      throw const ImportInvalidFormat();
    }

    if (decoded is! Map<String, dynamic>) {
      throw const ImportInvalidFormat();
    }

    final app = decoded['app'];
    if (app is String && app != _appTag) {
      throw const ImportInvalidFormat();
    }
    final version = decoded['version'];
    if (version is int && version > _schemaVersion) {
      throw const ImportInvalidFormat();
    }

    final eventsRaw = decoded['events'];
    if (eventsRaw is! List) {
      throw const ImportInvalidFormat();
    }

    try {
      final events = <EventModel>[];
      for (final item in eventsRaw) {
        if (item is! Map<String, dynamic>) {
          throw const ImportInvalidFormat();
        }
        if (!_isValidEventMap(item)) {
          throw const ImportInvalidFormat();
        }
        events.add(EventModel.fromJson(item));
      }
      return events;
    } on ImportInvalidFormat {
      rethrow;
    } catch (_) {
      throw const ImportInvalidFormat();
    }
  }

  static bool _isValidEventMap(Map<String, dynamic> m) {
    final id = m['id'];
    final name = m['name'];
    final targetDate = m['targetDate'];
    final emoji = m['emoji'];
    final color = m['color'];
    final createdAt = m['createdAt'];
    if (id is! String || id.isEmpty) return false;
    if (name is! String) return false;
    if (emoji is! String || emoji.isEmpty) return false;
    if (color is! int) return false;
    if (targetDate is! String || DateTime.tryParse(targetDate) == null) {
      return false;
    }
    if (createdAt is! String || DateTime.tryParse(createdAt) == null) {
      return false;
    }
    return true;
  }
}
