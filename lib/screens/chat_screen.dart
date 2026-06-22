import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/socket_service.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends State<ChatScreen> {

  final SocketService socketService =
      SocketService();

  final TextEditingController controller =
      TextEditingController();

  List<ChatMessage> messages = [];

  @override
  void initState() {

    super.initState();

    initSocket();
  }

  Future<void> initSocket() async {

    await socketService.connect();

    socketService.socket?.on('connect', (_) {
      debugPrint('Conectado al servidor Socket.IO');
    });

    socketService.socket?.on(
      'messages-history',
      (data) {

        final history =
        (data as List)
            .map(
              (e) =>
                  ChatMessage.fromJson(e),
            )
            .toList();

        setState(() {
          messages = history;
        });
      },
    );

    socketService.socket?.on(
      'new-message',
      (data) {

        setState(() {

          messages.add(
            ChatMessage.fromJson(data),
          );

        });
      },
    );
  }

  void sendMessage() {

    if (controller.text.isEmpty) {
      return;
    }

    socketService.socket?.emit(
      'new-message',
      {
        'text':
            controller.text,
      },
    );

    controller.clear();
  }

  @override
  void dispose() {

    socketService.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Chat'),
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount:
                  messages.length,
              itemBuilder:
                  (_, index) {

                final msg =
                    messages[index];

                return ListTile(
                  title:
                      Text(msg.username),
                  subtitle:
                      Text(msg.text),
                );
              },
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(8),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller:
                        controller,
                  ),
                ),

                IconButton(
                  onPressed:
                      sendMessage,
                  icon: const Icon(
                    Icons.send,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}