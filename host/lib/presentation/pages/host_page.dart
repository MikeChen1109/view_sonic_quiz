import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:host/di/dependency_injections.dart';
import 'package:host/presentation/widgets/message_list_view.dart';

class HostPage extends ConsumerWidget {
  const HostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(hostStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Host'),
      ),
      body: state.when(
        data: (data) {
          return const MessageListView();
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return ErrorWidget(error);
        },
      ),
    );
  }
}
