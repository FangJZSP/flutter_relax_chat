class Info {
  static const websocketDevUrl = 'ws://127.0.0.1:9999/ws';
  static const websocketProdUrl = 'ws://8.153.38.39:9999/ws';

  static const serveDevUrl = 'http://127.0.0.1:9999';
  static const serveProdUrl = 'http://8.153.38.39:9999';
  
  // Minio配置
  static const minioEndPoint = '8.153.38.39';
  static const minioPort = 9000;
  static const minioAccessKey = 'RhJkFRrfHpttD3n9';
  static const minioSecretKey = 'tWI2fPuEY64wBuqgQnV7kVVKfocSSHyZ';
  static const minioUseSSL = false;
  
  // Minio URL格式
  static String getMinioUrl(String bucketName, String objectName) {
    return 'http://$minioEndPoint:$minioPort/$bucketName/$objectName';
  }
}
