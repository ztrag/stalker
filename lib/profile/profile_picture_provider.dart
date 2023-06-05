import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ProfilePictureFetcher {
  Future<Uint8List> fetch(String url) async {
    final dir = await getApplicationSupportDirectory();
    final filepath = '${dir.path}/${url.hashCode}';
    final file = File(filepath);

    if (file.existsSync()) {
      return file.readAsBytes();
    }

    final result = await http.get(Uri.parse(url));
    final bytes = result.bodyBytes;
    file.writeAsBytes(bytes);
    return bytes;
  }
}
