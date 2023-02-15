import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  const ShareUtils._privateConsrtructor();

  static const ShareUtils _instance = ShareUtils._privateConsrtructor();
  static ShareUtils get instance => _instance;

  Future<bool> shareImage(
      {required GlobalKey key, required String textSharing}) async {
    bool result = false;
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        final pngBytes = byteData.buffer.asUint8List();
        File('$tempPath/imgshare.png').writeAsBytesSync(pngBytes);
        XFile xFile = XFile('$tempPath/imgshare.png');
        List<XFile> files = []..add(xFile);
        await Share.shareXFiles(files, text: textSharing).then((value) async {
          File file = File('$tempPath/imgshare.png');
          await file.delete();
          result = true;
        });
      }
    } catch (e) {
      print('Error at saveWidgetToImage - ShareUtils: $e');
    }
    return result;
  }
}
