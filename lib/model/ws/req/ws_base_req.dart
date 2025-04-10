enum WSReqType {
  loginQRCode(1, '请求登录二维码'),
  heartbeat(2, '心跳检测'),
  authorize(3, 'token验证'),
  emailLogin(4, '请求邮箱登录'),
  ;

  final int type;
  final String desc;

  const WSReqType(this.type, this.desc);

  static WSReqType? fromType(int type) {
    for (var respType in WSReqType.values) {
      if (respType.type == type) {
        return respType;
      }
    }
    return null;
  }
}

abstract class WSBaseReqModel {
  int type;

  WSBaseReqModel(this.type);
}
