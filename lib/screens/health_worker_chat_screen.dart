import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../data/dummy_data.dart';

class HealthWorkerChatScreen extends StatefulWidget {
  const HealthWorkerChatScreen({super.key});

  @override
  State<HealthWorkerChatScreen> createState() => _HealthWorkerChatScreenState();
}

class _HealthWorkerChatScreenState extends State<HealthWorkerChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;
    
    // Get health worker info (for demo, using first health worker)
    final healthWorker = DummyData.healthWorkers.first;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryPurple,
              child: Text(
                healthWorker.name.split(' ').map((n) => n[0]).join(''),
                style: const TextStyle(
                  color: AppTheme.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    healthWorker.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    healthWorker.specialization.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: AppTheme.white,
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: healthWorker.isOnline ? AppTheme.successGreen : AppTheme.lightGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              healthWorker.isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                fontSize: 10,
                color: healthWorker.isOnline ? AppTheme.white : AppTheme.darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildChatMessages(healthWorker),
          ),
          _buildMessageInput(healthWorker),
        ],
      ),
    );
  }

  Widget _buildChatMessages(HealthWorkerProfile healthWorker) {
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;
    
    // Get messages between current user and health worker
    final messages = DummyData.healthWorkerMessages
        .where((msg) => 
            (msg.senderId == currentUser?.phoneNumber && msg.receiverId == healthWorker.phoneNumber) ||
            (msg.senderId == healthWorker.phoneNumber && msg.receiverId == currentUser?.phoneNumber))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: AppTheme.lightGrey,
            ),
            const SizedBox(height: 16),
            Text(
              'Start a conversation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ask questions about your health or screening results',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isFromCurrentUser = message.senderId == currentUser?.phoneNumber;
        
        return _buildMessageBubble(message, isFromCurrentUser, healthWorker);
      },
    );
  }

  Widget _buildMessageBubble(HealthWorkerMessage message, bool isFromCurrentUser, HealthWorkerProfile healthWorker) {
    return Align(
      alignment: isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isFromCurrentUser) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primaryPurple,
                child: Text(
                  healthWorker.name.split(' ').map((n) => n[0]).join(''),
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isFromCurrentUser 
                      ? AppTheme.primaryPurple 
                      : AppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(20).copyWith(
                    bottomLeft: isFromCurrentUser ? const Radius.circular(20) : const Radius.circular(4),
                    bottomRight: isFromCurrentUser ? const Radius.circular(4) : const Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message,
                      style: TextStyle(
                        color: isFromCurrentUser ? AppTheme.white : AppTheme.darkGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatMessageTime(message.timestamp),
                      style: TextStyle(
                        color: isFromCurrentUser 
                            ? AppTheme.white.withOpacity(0.7)
                            : AppTheme.lightGrey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isFromCurrentUser) ...[
              const SizedBox(width: 8),
              Icon(
                message.isRead ? Icons.done_all : Icons.done,
                size: 16,
                color: message.isRead ? AppTheme.successGreen : AppTheme.white.withOpacity(0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(HealthWorkerProfile healthWorker) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightGrey.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  setState(() {
                    _isTyping = value.isNotEmpty;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: _isTyping ? AppTheme.primaryPurple : AppTheme.lightGrey,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isTyping ? Icons.send : Icons.send,
                color: _isTyping ? AppTheme.white : AppTheme.darkGrey,
              ),
              onPressed: _isTyping ? _sendMessage : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final appState = context.read<AppState>();
    final currentUser = appState.currentUser;
    final healthWorker = DummyData.healthWorkers.first;

    // Create new message
    final newMessage = HealthWorkerMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUser?.phoneNumber ?? '',
      receiverId: healthWorker.phoneNumber,
      message: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Add to dummy data
    DummyData.healthWorkerMessages.add(newMessage);

    // Clear input
    _messageController.clear();
    setState(() {
      _isTyping = false;
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate health worker response after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final responseMessage = HealthWorkerMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: healthWorker.phoneNumber,
          receiverId: currentUser?.phoneNumber ?? '',
          message: _getHealthWorkerResponse(_messageController.text.trim()),
          timestamp: DateTime.now(),
          isRead: false,
        );
        
        DummyData.healthWorkerMessages.add(responseMessage);
        setState(() {});
        _scrollToBottom();
      }
    });
  }

  String _getHealthWorkerResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    if (message.contains('blood pressure') || message.contains('bp')) {
      return 'Blood pressure is an important health indicator. Normal BP is typically 120/80 mmHg. If you have concerns, we can schedule a follow-up screening.';
    } else if (message.contains('hiv') || message.contains('test')) {
      return 'HIV testing is confidential and important for your health. The rapid test gives results in 15-20 minutes. Would you like to schedule a test?';
    } else if (message.contains('contraceptive') || message.contains('birth control')) {
      return 'There are many contraceptive options available. I can help you understand the different methods and their effectiveness. This is completely confidential.';
    } else if (message.contains('mental health') || message.contains('anxiety') || message.contains('stress')) {
      return 'Mental health is just as important as physical health. It\'s normal to feel stressed or anxious. I can connect you with counseling services if needed.';
    } else if (message.contains('appointment') || message.contains('schedule')) {
      return 'I\'d be happy to schedule an appointment. What day and time works best for you? I have availability on weekdays.';
    } else {
      return 'Thank you for your message. I\'m here to help with any health-related questions. Feel free to ask about screenings, appointments, or general health concerns.';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
