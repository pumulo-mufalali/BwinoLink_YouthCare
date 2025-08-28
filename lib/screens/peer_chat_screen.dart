import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../data/dummy_data.dart';

class PeerChatScreen extends StatefulWidget {
  const PeerChatScreen({super.key});

  @override
  State<PeerChatScreen> createState() => _PeerChatScreenState();
}

class _PeerChatScreenState extends State<PeerChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  // Dummy chat messages
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'sender': 'peer_navigator',
      'message': 'Hi! I\'m Sarah, your peer navigator. How are you doing today?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
    },
    {
      'id': '2',
      'sender': 'youth',
      'message': 'Hi Sarah! I\'m doing okay, thanks for asking.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      'isRead': true,
    },
    {
      'id': '3',
      'sender': 'peer_navigator',
      'message': 'That\'s great! I noticed you have an upcoming appointment for HIV testing. Do you have any questions about it?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      'isRead': true,
    },
    {
      'id': '4',
      'sender': 'youth',
      'message': 'Actually, I\'m a bit nervous about it. What should I expect?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      'isRead': true,
    },
    {
      'id': '5',
      'sender': 'peer_navigator',
      'message': 'That\'s completely normal! The test is quick and painless. It\'s just a small finger prick. The results are confidential and you\'ll get them within 15-20 minutes. Would you like me to explain the process in more detail?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'isRead': true,
    },
    {
      'id': '6',
      'sender': 'youth',
      'message': 'Yes, please. And what if the result is positive?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
      'isRead': true,
    },
    {
      'id': '7',
      'sender': 'peer_navigator',
      'message': 'If the result is positive, we\'ll support you every step of the way. You\'ll be connected to a healthcare provider who will confirm the result and discuss treatment options. HIV is manageable with proper treatment, and you can live a healthy life. Remember, you\'re not alone in this journey.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'isRead': true,
    },
    {
      'id': '8',
      'sender': 'youth',
      'message': 'Thank you, that really helps. I feel less anxious now.',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'isRead': true,
    },
    {
      'id': '9',
      'sender': 'peer_navigator',
      'message': 'You\'re welcome! I\'m here to support you. Is there anything else you\'d like to talk about?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentUser = appState.currentUser;
    
    // Get peer navigator info
    final peerNavigatorAssignment = appState.peerNavigatorAssignment;
    final peerNavigator = peerNavigatorAssignment != null 
        ? DummyData.users.firstWhere((user) => user.phoneNumber == peerNavigatorAssignment.peerNavigatorId)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.lightPurple,
              child: Icon(
                Icons.person,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peerNavigator?.name ?? 'Peer Navigator',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Peer Navigator',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _showCallOptions(),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showChatOptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Peer Navigator Info Card
          if (peerNavigatorAssignment != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppTheme.lightPurple.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.lightPurple,
                    child: Icon(
                      Icons.person,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          peerNavigator?.name ?? 'Peer Navigator',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Assigned since ${_formatDate(peerNavigatorAssignment.assignedDate)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: peerNavigatorAssignment.supportAreas.map((area) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                area,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryPurple,
                    ),
                    onPressed: () => _showPeerNavigatorInfo(peerNavigator, peerNavigatorAssignment),
                  ),
                ],
              ),
            ),

          // Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isFromPeer = message['sender'] == 'peer_navigator';
                      final isLastMessage = index == _messages.length - 1;
                      
                      return Column(
                        children: [
                          _buildMessageBubble(message, isFromPeer),
                          if (isLastMessage && isFromPeer && !message['isRead'])
                            _buildReadIndicator(),
                        ],
                      );
                    },
                  ),
          ),

          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppTheme.lightPurple,
                    child: Icon(
                      Icons.person,
                      color: AppTheme.primaryPurple,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTypingDot(0),
                        _buildTypingDot(1),
                        _buildTypingDot(2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: AppTheme.primaryPurple,
                  ),
                  onPressed: () => _showAttachmentOptions(),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
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
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: _messageController.text.trim().isNotEmpty
                        ? _sendMessage
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your peer navigator is here to support you',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _sendQuickMessage(),
            icon: const Icon(Icons.message),
            label: const Text('Send a quick message'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isFromPeer) {
    return Align(
      alignment: isFromPeer ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isFromPeer) ...[
              CircleAvatar(
                radius: 12,
                backgroundColor: AppTheme.lightPurple,
                child: Icon(
                  Icons.person,
                  color: AppTheme.primaryPurple,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isFromPeer ? Colors.grey[200] : AppTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['message'],
                      style: TextStyle(
                        color: isFromPeer ? Colors.black87 : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(message['timestamp']),
                      style: TextStyle(
                        color: isFromPeer ? Colors.grey[600] : Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!isFromPeer) ...[
              const SizedBox(width: 8),
              Icon(
                message['isRead'] ? Icons.done_all : Icons.done,
                size: 16,
                color: message['isRead'] ? AppTheme.primaryPurple : Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReadIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 44),
        child: Text(
          'Read',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + (index * 200)),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        shape: BoxShape.circle,
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'sender': 'youth',
      'message': _messageController.text.trim(),
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    setState(() {
      _messages.add(newMessage);
      _isTyping = false;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate peer navigator response
    _simulatePeerResponse();
  }

  void _simulatePeerResponse() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final responses = [
          'Thanks for sharing that with me. How are you feeling about it?',
          'I understand. That\'s a common concern. Would you like to talk more about it?',
          'I\'m here to support you. Is there anything specific you\'d like to discuss?',
          'That\'s a great question! Let me help you understand this better.',
          'I appreciate you reaching out. You\'re not alone in this journey.',
        ];

        final randomResponse = responses[DateTime.now().millisecond % responses.length];

        final responseMessage = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'sender': 'peer_navigator',
          'message': randomResponse,
          'timestamp': DateTime.now(),
          'isRead': false,
        };

        setState(() {
          _messages.add(responseMessage);
        });

        _scrollToBottom();
      }
    });
  }

  void _sendQuickMessage() {
    final quickMessages = [
      'Hi, I need some support',
      'Can we talk about my appointment?',
      'I have a question about my health',
      'I\'m feeling anxious',
      'Thank you for your help',
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quick Messages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...quickMessages.map((message) => ListTile(
              title: Text(message),
              onTap: () {
                Navigator.pop(context);
                _messageController.text = message;
                _sendMessage();
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _showCallOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Contact Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.call, color: AppTheme.primaryPurple),
              title: const Text('Voice Call'),
              onTap: () {
                Navigator.pop(context);
                _makeCall('voice');
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam, color: AppTheme.primaryPurple),
              title: const Text('Video Call'),
              onTap: () {
                Navigator.pop(context);
                _makeCall('video');
              },
            ),
            ListTile(
              leading: Icon(Icons.phone, color: AppTheme.primaryPurple),
              title: const Text('Direct Call'),
              onTap: () {
                Navigator.pop(context);
                _makeCall('direct');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chat Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.info, color: AppTheme.primaryPurple),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                // Show peer navigator profile
              },
            ),
            ListTile(
              leading: Icon(Icons.block, color: Colors.red),
              title: const Text('Block'),
              onTap: () {
                Navigator.pop(context);
                _showBlockDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: const Text('Clear Chat'),
              onTap: () {
                Navigator.pop(context);
                _showClearChatDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Attach',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.image, color: AppTheme.primaryPurple),
              title: const Text('Photo'),
              onTap: () {
                Navigator.pop(context);
                // Handle photo attachment
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppTheme.primaryPurple),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                // Handle camera
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: AppTheme.primaryPurple),
              title: const Text('Location'),
              onTap: () {
                Navigator.pop(context);
                // Handle location sharing
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPeerNavigatorInfo(dynamic peerNavigator, dynamic assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Peer Navigator Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${peerNavigator?.name ?? 'N/A'}'),
            Text('Phone: ${peerNavigator?.phoneNumber ?? 'N/A'}'),
            Text('Assigned: ${_formatDate(assignment.assignedDate)}'),
            const SizedBox(height: 8),
            const Text('Support Areas:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...assignment.supportAreas.map((area) => Text('• $area')),
            if (assignment.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(assignment.notes),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _makeCall(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Initiating $type call...'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block Peer Navigator'),
        content: const Text('Are you sure you want to block this peer navigator? You can unblock them later in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Peer navigator blocked'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
