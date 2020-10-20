import 'package:flutter_chatbot/models/chat_message.dart';
import 'package:flutter_chatbot/widgets/chat_message_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _messageList = <ChatMessage>[];
  final _controllerText = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controllerText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Chatbot - Professor'),
      ),
      body: Column(
        children: <Widget>[
          _buildList(),
          Divider(height: 1.0,),
          _buildUserInput()
        ],
      ),
    );
  }

  // Criar a lista de menssagens (de baixo para cima)
  Widget _buildList() {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => ChatMessageListItem(chatMessage: _messageList[index],),
        itemCount: _messageList.length,
      ),
    );
  }

  // Envia a msg com padrão da direita
  void _sendMessage({String text}) {
    _controllerText.clear();
    _addMessage(name: 'Mauricio de Castro Pasquotto', text: text, type: ChatMessageType.sent);
  }

  // Adiciona uma menssagem na lista de menssagens
  void _addMessage({String name, String text, ChatMessageType type}) {
    var message = ChatMessage(
      text: text, name: name, type: type);
    setState(() {
      _messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      // Envia a mensagem para o chatbot e aguarda sua resposta
      _dialogFlowRequest(query: message.text);
    }
  }

  Future _dialogFlowRequest({String query}) async {

  }

  // Campo para escrever a msg
  Widget _buildTextField() {
    return new Flexible(
      child: new TextField(
        controller: _controllerText,
        decoration: new InputDecoration.collapsed(
          hintText: "Enviar menssagem"
        ),
      ),
    );
  }

  // Btn  para enviar msg
  Widget _buildSendButton() {
    return new Container(
      margin: new EdgeInsets.only(left: 8.0),
      child: new IconButton(
        icon: new Icon(Icons.send, color: Theme.of(context).accentColor),
        onPressed: () {
          if (_controllerText.text.isNotEmpty) {
            _sendMessage(text: _controllerText.text);
          }
        },
      ),
    );
  }

  // Montar a linha com o campo de texto  e o btn de envio
  Widget _buildUserInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          _buildTextField(),
          _buildSendButton()
        ],
      ),
    );
  }
}