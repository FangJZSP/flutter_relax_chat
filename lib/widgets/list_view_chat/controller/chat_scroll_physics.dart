import 'package:flutter/cupertino.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

mixin ChatScrollPhysicsMixin on ScrollPhysics {
  late final ChatScrollObserver observer;

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    final isNeedFixedPosition = observer.innerIsNeedFixedPosition;
    observer.innerIsNeedFixedPosition = false;

    var adjustPosition = super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );

    if ((newPosition.extentBefore <= observer.fixedPositionOffset &&
            adjustPosition >= 0) ||
        !isNeedFixedPosition ||
        observer.isRemove) {
      _handlePositionCallback(ChatScrollObserverHandlePositionResultModel(
        type: ChatScrollObserverHandlePositionType.none,
        mode: observer.innerMode,
        changeCount: observer.changeCount,
      ));
      return adjustPosition;
    }
    final model = observer.observeRefItem();
    if (model == null) {
      _handlePositionCallback(ChatScrollObserverHandlePositionResultModel(
        type: ChatScrollObserverHandlePositionType.none,
        mode: observer.innerMode,
        changeCount: observer.changeCount,
      ));
      return adjustPosition;
    }

    _handlePositionCallback(ChatScrollObserverHandlePositionResultModel(
      type: ChatScrollObserverHandlePositionType.keepPosition,
      mode: observer.innerMode,
      changeCount: observer.changeCount,
    ));
    final delta = model.layoutOffset - observer.innerRefItemLayoutOffset;
    return adjustPosition + delta;
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  /// Calling observer's [onHandlePositionCallback].
  void _handlePositionCallback(ChatScrollObserverHandlePositionResultModel result) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      observer.onHandlePositionResultCallback?.call(result);
      // ignore: deprecated_member_use_from_same_package
      observer.onHandlePositionCallback?.call(result.type);
    });
  }
}

class ChatClampingScrollPhysics extends ClampingScrollPhysics
    with ChatScrollPhysicsMixin {
  ChatClampingScrollPhysics({
    required ChatScrollObserver observer,
    super.parent,
  }) {
    this.observer = observer;
  }

  @override
  ChatClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ChatClampingScrollPhysics(
      parent: buildParent(ancestor),
      observer: observer,
    );
  }
}

class ChatBouncingScrollPhysics extends BouncingScrollPhysics
    with ChatScrollPhysicsMixin {
  ChatBouncingScrollPhysics({
    required ChatScrollObserver observer,
    super.parent,
  }) {
    this.observer = observer;
  }

  @override
  ChatBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ChatBouncingScrollPhysics(
      parent: buildParent(ancestor),
      observer: observer,
    );
  }
}

class ChatAlwaysScrollableScrollPhysics extends AlwaysScrollableScrollPhysics
    with ChatScrollPhysicsMixin {
  ChatAlwaysScrollableScrollPhysics({
    required ChatScrollObserver observer,
    super.parent,
  }) {
    this.observer = observer;
  }

  @override
  ChatAlwaysScrollableScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ChatAlwaysScrollableScrollPhysics(
      parent: buildParent(ancestor),
      observer: observer,
    );
  }
}
