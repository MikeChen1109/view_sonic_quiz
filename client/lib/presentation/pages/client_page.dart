import 'package:client/di/dependency_injections.dart';
import 'package:client/presentation/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientPage extends ConsumerStatefulWidget {
  const ClientPage({super.key});

  @override
  ConsumerState<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends ConsumerState<ClientPage> {
  late final TextEditingController messageTextController;
  late final TextEditingController nameTextController;

  @override
  void initState() {
    super.initState();
    messageTextController = TextEditingController();
    nameTextController = TextEditingController();
  }

  @override
  void dispose() {
    messageTextController.dispose();
    nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientStateProvider);
    return Scaffold(
      appBar:
          AppBar(title: const Text('Client'), backgroundColor: Colors.purple),
      body: state.when(connected: () {
        return _ConnectedStateWidget(
          onPressedExit: () {
            final notifier = ref.read(clientStateProvider.notifier);
            notifier.disconnect();
          },
          onPressedSend: () async {
            if (messageTextController.text.isEmpty) {
              ToastHelper.show('Message cannot be empty');
              return;
            }
            final notifier = ref.read(clientStateProvider.notifier);
            await notifier.sendMessage(messageTextController.text);
            messageTextController.clear();
          },
          textController: messageTextController,
        );
      }, idle: () {
        return _IdleStateWidget(
          textController: nameTextController,
          onPressedConnect: () async {
            if (nameTextController.text.isEmpty) {
              ToastHelper.show('Name cannot be empty');
              return;
            }
            final notifier = ref.read(clientStateProvider.notifier);
            await notifier.connect(nameTextController.text);
          },
        );
      }),
    );
  }
}

class _ConnectedStateWidget extends StatelessWidget {
  const _ConnectedStateWidget({
    this.onPressedExit,
    this.onPressedSend,
    required this.textController,
  });

  final VoidCallback? onPressedSend;
  final VoidCallback? onPressedExit;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Message'),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your message',
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPressedSend,
            child: const Text('Send'),
          ),
          ElevatedButton(
            onPressed: onPressedExit,
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class _IdleStateWidget extends StatelessWidget {
  const _IdleStateWidget({this.onPressedConnect, required this.textController});

  final VoidCallback? onPressedConnect;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Name'),
            const SizedBox(width: 10),
            SizedBox(
              width: 200,
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your name',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onPressedConnect,
          child: const Text('Connect'),
        ),
      ],
    );
  }
}
