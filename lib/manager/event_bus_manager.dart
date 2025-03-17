import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../model/ws/resp/ws_msg_model.dart';

EventBus eventBus = EventBus();

class WSReceivedMsgEvent {
  WSMessageModel model;

  WSReceivedMsgEvent(this.model);
}

class WSLoginSuccessEvent {
  WSLoginSuccessModel model;

  WSLoginSuccessEvent(this.model);
}

class UpdateConversationListEvent {
  UpdateConversationListEvent();
}

class BackToRouteEvent {
  final Route? route;

  BackToRouteEvent(this.route);
}

class OpenToRouteEvent {
  final Route? route;

  OpenToRouteEvent(this.route);
}
