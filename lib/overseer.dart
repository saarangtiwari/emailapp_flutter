import 'package:emailapp/managers/contact_manager.dart';
import 'package:emailapp/managers/counter_manager.dart';
import 'package:emailapp/managers/message_form_manager.dart';

class OverSeer {
  Map<dynamic, dynamic> repository = {};

  OverSeer() {
    register(ContactManager, ContactManager());
    register(CounterManager, CounterManager());
    register(MessageFormManager, MessageFormManager());
  }

  register(name, object) {
    repository[name] = object;
  }

  fetch(name) => repository[name];
}
