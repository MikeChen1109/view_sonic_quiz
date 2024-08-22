import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:host/di/dependency_injections.dart';
import 'package:host/domain/entity/message.dart';

class MessageListView extends ConsumerStatefulWidget {
  const MessageListView({super.key});

  @override
  ConsumerState<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends ConsumerState<MessageListView> {
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageStreamProvider);
    return state.when(
      data: (data) {
        _addMessage(data);
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: _messages.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 15);
                },
                itemBuilder: (BuildContext context, int index) {
                  final message = _messages[index];
                  switch (message.event) {
                    case EventType.message:
                      return _MessageContainer(
                        message: message,
                        key: Key('item_${index}_text'),
                      );
                    case EventType.connected:
                      return const _ConnectStateWidget();
                  }
                },
              ),
            ),
            SafeArea(
              child: Container(
                height: 30,
                color: Colors.grey[200],
                child: Center(
                  child: Text('Users connected: ${data.payload.currentUsers}'),
                ),
              ),
            )
          ],
        );
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stackTrace) {
        return ErrorWidget(error);
      },
    );
  }

  void _addMessage(Message message) {
    _messages.add(message);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }
}

class _ConnectStateWidget extends StatelessWidget {
  const _ConnectStateWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: Text('connected')),
    );
  }
}

class _MessageContainer extends StatelessWidget {
  const _MessageContainer({
    required this.message,
    required super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('UserName: ${message.payload.name}'),
          const SizedBox(height: 5),
          Text('Message: ${message.payload.message}'),
          const SizedBox(height: 5),
          Text('Date: ${message.payload.date}'),
        ],
      ),
    );
  }
}
