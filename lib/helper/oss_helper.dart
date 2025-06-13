import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../manager/log_manager.dart';

/// OSS配置
class OssConfig {
  final bool enabled;
  final String type;
  final String endpoint;
  final String accessKey;
  final String secretKey;
  final String bucketName;

  OssConfig({
    this.enabled = true,
    this.type = 'minio',
    this.endpoint = 'http://8.153.38.39:9000',
    this.accessKey = 'RhJkFRrfHpttD3n9',
    this.secretKey = 'tWI2fPuEY64wBuqgQnV7kVVKfocSSHyZ',
    this.bucketName = 'relax',
  });
}

/// OSS助手类
class OssHelper {
  OssHelper._();

  static final OssHelper instance = OssHelper._();

  final OssConfig config = OssConfig();
  final Dio _dio = Dio();

  /// 上传图片到MinIO
  /// [file] 文件对象
  /// 返回图片URL
  Future<String> uploadImage(File file) async {
    try {
      if (!config.enabled) {
        throw Exception('OSS服务未启用');
      }

      // 获取文件名和扩展名
      String fileName = path.basename(file.path);
      String ext = path.extension(fileName);
      if (ext.isEmpty) {
        ext = '.jpg'; // 默认扩展名
      }

      // 生成唯一文件名
      String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}$ext';

      // 构建表单数据
      FormData formData = FormData.fromMap({
        'file':
            await MultipartFile.fromFile(file.path, filename: uniqueFileName),
      });

      // 构建上传URL
      String uploadUrl = '${config.endpoint}/${config.bucketName}';

      // 设置请求头
      Map<String, dynamic> headers = {
        'Content-Type': 'multipart/form-data',
      };

      // 发送请求
      Response response = await _dio.post(
        uploadUrl,
        data: formData,
        options: Options(headers: headers),
      );

      // 检查响应
      if (response.statusCode == 200) {
        // 返回文件URL
        return '${config.endpoint}/${config.bucketName}/$uniqueFileName';
      } else {
        throw Exception('上传失败: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('上传图片失败: $e');
      throw Exception('上传图片失败: $e');
    }
  }
}
