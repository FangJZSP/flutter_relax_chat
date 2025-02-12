import 'package:flutter/material.dart';

import '../manager/event_bus_manager.dart';
import '../manager/log_manager.dart';

class MyRouteObserver extends RouteObserver<PageRoute> {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    eventBus.fire(BackToRouteEvent(previousRoute));
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _handleOpenRouteEvent(route, previousRoute, false);
    super.didPush(route, previousRoute);
    eventBus.fire(OpenToRouteEvent(route));
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    logger.d('didReplace newRoure$newRoute oldRoute$oldRoute');
    _handleOpenRouteEvent(newRoute, oldRoute, true);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    logger.d('didRemove roure$route previousRoute$previousRoute');
    super.didRemove(route, previousRoute);
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    logger.d('didStartUserGesture roure$route previousRoute$previousRoute');
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    logger.d('didStopUserGesture');
    super.didStopUserGesture();
  }

  void _handleOpenRouteEvent(Route? route, Route? oldRoute, bool isReplace) {}
}
