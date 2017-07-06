// Copyright (c) 2017, kevin. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:firebase/firebase.dart';
import 'message.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components
@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, CORE_DIRECTIVES],
  providers: const [materialProviders],
)

class AppComponent implements OnInit {
  int value = 100;
  Random random = new Random();
  List<Message> messages;
  String inputText = "";
  String inputName = "Anonymous";
  DatabaseReference counterDB;
  DatabaseReference msgDB;

  Future<int> updateCounter(Function update) async{
    var transaction = await counterDB.transaction((current) {
      if(current!=null)
        current = update(current);
      return current;
    });
    return transaction.snapshot.val();
  }

  Future sendMessage(String name, String text) async{
    if(inputText.isEmpty) return;
    Message msg = new Message(name, text);
    inputText = "";
    await msgDB.push(msg.toMap());
  }

  send() async
  {
    sendMessage(inputName, inputText);
    print(messages);
  }

  click() async
  {
    value = await updateCounter((c) => c + 1);
    print(value);
  }

  @override
  ngOnInit() {
    initializeApp(

    apiKey: "AIzaSyAJa28gQbt9zhn7G1tAXYLhAlrCwgTsZNM",
    authDomain: "hello-ef613.firebaseapp.com",
    databaseURL: "https://hello-ef613.firebaseio.com",
    storageBucket: "hello-ef613.appspot.com"

    );

    counterDB = database().ref('counter');
    counterDB.onValue.listen((e) => value = e.snapshot.val());

    msgDB = database().ref('messages');

    messages = [];
    msgDB.limitToLast(16).onChildAdded.listen(
        (event) {
          messages.add(new Message.fromMap(event.snapshot.val()));
          if(messages.length>16)messages.removeAt(0);
        }
    );

  }
}
