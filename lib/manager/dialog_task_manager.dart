typedef DialogShowEvent = Future Function();

class DialogTaskManager {
  final Duration _dialogDuration = const Duration(milliseconds: 200);

  static DialogTaskManager? _instance;

  /// 当前弹窗是否在展示
  bool _showing = false;

  /// 进入指定页面（通话）需要暂停弹框，退出后继续弹框
  bool _isPause = false;

  DialogTaskManager._();

  static DialogTaskManager get instance => _instance ??= DialogTaskManager._();

  final List<DialogElement> _dialogQueue = [];

  void init() {}

  /// 弹窗暂停
  void pause() {
    _isPause = true;
  }

  /// 弹窗开始
  void start() {
    _isPause = false;
    show();
  }

  /// 弹窗展示并添加任务
  void show({DialogElement? element}) {
    if (element != null) {
      // 添加到队列并排序
      _dialogQueue.add(element);
    }
    if (_dialogQueue.isEmpty) {
      return;
    }

    _dialogQueue.sort(
        (a, b) => b.dialogPriority.index.compareTo(a.dialogPriority.index));
    // 无正在展示的，直接展示当前
    var current = _dialogQueue.first;

    if (!_showing && !_isPause) {
      _showing = true;
      current.showEvent().then((value) {
        _showing = false;
        _dialogQueue.remove(current);
        Future.delayed(_dialogDuration).then((value) {
          _showNext();
        });
      });
    }
  }

  void _showNext() {
    if (_dialogQueue.isEmpty) {
      return;
    }
    var current = _dialogQueue.first;
    if (!_showing && !_isPause) {
      _showing = true;
      current.showEvent().then((value) {
        _showing = false;
        _dialogQueue.remove(current);
        Future.delayed(_dialogDuration).then((value) {
          _showNext();
        });
      });
    }
  }

  void clear() {
    _dialogQueue.clear();
  }
}

class DialogElement {
  DialogPriority? priority;

  DialogShowEvent showEvent;

  DialogElement({required this.showEvent, this.priority});

  DialogPriority get dialogPriority => priority ?? DialogPriority.preset;
}

/// 枚举index大小为优先级，越靠后，越优先
/// 补充弹窗名字 名字越后优先级越高 会先弹出
enum DialogPriority {
  none,
  low,
  medium,
  high,
  preset,
}
