import 'package:minio_flutter/io.dart';
import 'package:minio_flutter/minio.dart';
import 'package:path/path.dart' as path;
import '../common/info.dart';
import '../manager/log_manager.dart';

class FileUploadHelper {
  /// 上传文件到Minio服务器
  /// [filePath] 本地文件路径
  /// [bucketName] 存储桶名称，默认为'relax'
  /// [directory] 存储目录，默认为'images'
  /// 返回完整的文件URL
  static Future<String> uploadToMinio(
    String filePath, {
    String bucketName = 'relax',
    String directory = 'images',
  }) async {
    try {
      final fileName = path.basename(filePath);
      final extension = path.extension(fileName).isNotEmpty
          ? path.extension(fileName)
          : '.jpg';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final objectName = '$directory/$timestamp$extension';

      String url =
          await Minio.shared.fPutObject(bucketName, objectName, filePath);
      if (url.isEmpty) {
        return '';
      }

      // 使用Info类生成URL，而不是硬编码
      return Info.getMinioUrl(bucketName, objectName);
    } catch (e) {
      logger.d('文件上传失败 $e');
      return '';
    }
  }
}
