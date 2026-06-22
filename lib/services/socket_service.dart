import 'package:socket_io_client/socket_io_client.dart'
    as IO;

import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class SocketService {

  IO.Socket? socket;

  Future<void> connect() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token');

    socket = IO.io(
      ApiConfig.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({
            'token': token,
          })
          .enableAutoConnect()
          .build(),
    );

    socket!.connect();
  }

  void disconnect() {
    socket?.disconnect();
  }
}