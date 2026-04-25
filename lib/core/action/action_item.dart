import 'package:flutter/cupertino.dart';
import 'package:youtube_music/core/action/action_context.dart';

import 'action_id.dart';

class ActionItem {
  final ActionId id;
  final String title;
  final IconData icon;

  final bool Function(ActionContext ctx) isVisible;

  final Future<void> Function(ActionContext ctx) onExecute;

  ActionItem(
      {required this.id,
      required this.title,
      required this.icon,
      required this.isVisible,
      required this.onExecute});
}
