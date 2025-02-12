class TimeUtils {
  //时间戳转时间字符串 一月 7, 11:01
  static String timestamp3TimeString(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    String twoStringWithStr(String sting) {
      if (sting.length == 1) {
        return '0$sting';
      }
      return sting;
    }

    int hour = dateTime.hour;

    return '${monthStrList()[dateTime.month]}月${dateTime.day}日 $hour:${twoStringWithStr(dateTime.minute.toString())}';
  }

  static List<String> monthStrList() => [
        '',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
      ];
}
