import 'dart:io';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    String valueServer = Platform.isAndroid
        ? 'http://192.168.1.54:3000'
        : 'http://localhost:3000';
    // Dart client
    _socket = IO.io(valueServer, {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // _socket.on('new-message', (payload) {
    //   print('new-message: $payload');
    //   print('name: ' + payload['name']);
    //   print('message: ' + payload['message']);
    //   print(
    //       payload.containsKey('message2') ? payload['message2'] : 'Not exist');
    // });
  }
}
