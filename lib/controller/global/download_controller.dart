import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sm_project/core/const/colors.dart';
import 'package:media_scanner/media_scanner.dart';

class DownloadFiles extends GetxController {
  downloadFile({required String url}) async {
    PermissionStatus status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      Fluttertoast.showToast(
        msg: 'Connecting',
        backgroundColor: AppColors.white,
        textColor: AppColors.black,
      );
      var response = await get(
        Uri.parse(
          url,
        ),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Download Started',
          backgroundColor: AppColors.white,
          textColor: AppColors.black,
        );
        int random = Random().nextInt(9999999);
        late String filename;
        String fileType =
            response.headers['content-type'].toString().split('/')[1];
        filename = '${random}_SMP';

        final file = File('/storage/emulated/0/Download/$filename.$fileType');
        await file.writeAsBytes(response.bodyBytes);
        await MediaScanner.loadMedia(path: file.path);

        Fluttertoast.showToast(
          msg: 'Downloaded',
          backgroundColor: AppColors.white,
          textColor: AppColors.black,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Error : ${response.statusCode}',
          backgroundColor: AppColors.white,
          textColor: AppColors.black,
        );
      }
    }
  }
}
