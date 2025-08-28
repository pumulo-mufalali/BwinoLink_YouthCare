import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';

class YouthAssignedScreen extends StatelessWidget {
  const YouthAssignedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _buildAssignedYouthSection(context, appState),
      ),
    );
  }

  // Assigned Youth Section
  Widget _buildAssignedYouthSection(BuildContext context, AppState appState) {
    final assignedYouth = DummyData.users.where((user) =>
    user.role == 'youth' &&
        DummyData.getPeerNavigatorAssignment(user.phoneNumber)?.peerNavigatorId == appState.currentUser?.phoneNumber
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...assignedYouth.map((youth) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.accentPink,
              child: Text(
                youth.name.substring(0, 1),
                style: const TextStyle(color: AppTheme.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(youth.name),
            subtitle: Text('${youth.age} years • ${youth.location}'),
            trailing: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/peer-chat');
              },
              icon: Icon(Icons.message, color: AppTheme.primaryPurple),
            ),
          ),
        )),
      ],
    );
  }
}