

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'messages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Bot',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const Home(),
    );
  }
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
 final TextEditingController _controller = TextEditingController();

 List<Map<String,dynamic>> messages = [];

 @override
  void initState() {

DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opium Bot'),
      ),
      body: Column(
        children: [
          Expanded(child: MessagesScreen(messages : messages)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
            color: Colors.deepPurple,
            child: Row(children: [
              Expanded(child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
              ),),
              IconButton(onPressed: (){sendMessage(_controller.text); _controller.clear(); }, icon:const Icon( Icons.send))
            ],),
          )
        ],
      ),
    );
  }

  sendMessage(String text)async{
    if(text.isEmpty){
      if (kDebugMode) {
        print('Message is empty ');
      }
    }else{
      setState(() {
          addMessage(Message(text: DialogText(text: [text])) , true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(queryInput: QueryInput(text: TextInput(text: text)));

      if(response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message,[bool isUserMessage = false]){
    messages.add({
      'message' : message,
      'isUserMessage' : isUserMessage
    });
  }
}
