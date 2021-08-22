import 'dart:io';

import 'package:http/http.dart';

class ImageUploader {
  final String _url;

  ImageUploader(this._url);

  Future<String> upload(File file) async {
    final request = MultipartRequest('POST', Uri.parse(_url));
    request.files.add(await MultipartFile.fromPath('picture', file.path));
    final result = await request.send();
    if (result.statusCode != 200) return '';
    final response = await Response.fromStream(result);
    return Uri.parse(_url).origin + response.body;
  }
}
