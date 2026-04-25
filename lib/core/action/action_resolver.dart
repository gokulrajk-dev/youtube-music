import 'package:youtube_music/core/action/action_context.dart';
import 'package:youtube_music/core/action/action_item.dart';
import 'package:youtube_music/core/action/action_registry.dart';

class ActionResolver{
  static List<ActionItem> resolve(ActionContext ctx){
    return ActionRegistry.all.where((action){
      return action.isVisible(ctx);
   }).toList();
  }
}