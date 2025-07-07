import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 4, 94, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _profileCard(),
              const SizedBox(height: 20),
              _settingsCard(isDarkMode),
              const SizedBox(height: 20),
              _infoCard(),
              const SizedBox(height: 20),
              _logoutCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: child,
    );
  }

  Widget _profileCard() {
    return _cardWrapper(
      child: Column(
        children: const [
          CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.person,
              size: 50,
              color: Color.fromRGBO(3, 4, 94, 1),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Dr. Nilesh Argade',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Inventory Admin'),
        ],
      ),
    );
  }

  Widget _settingsCard(bool isDarkMode) {
    return _cardWrapper(
      child: Column(
        children: [
          _settingTile(
            icon: Icons.brightness_6,
            title: 'Dark Mode',
            trailing: Switch(
              value: isDarkMode,
              onChanged: (val) {
                // toggle theme logic
              },
            ),
          ),
          const Divider(),
          _settingTile(
            icon: Icons.notifications,
            title: 'Notifications',
            trailing: Switch(
              value: true,
              onChanged: (val) {
                // toggle notifications
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return _cardWrapper(
      child: _settingTile(
        icon: Icons.info_outline,
        title: 'App Version',
        trailing: const Text('v1.0.0'),
      ),
    );
  }

  Widget _logoutCard() {
    return _cardWrapper(
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Logout', style: TextStyle(color: Colors.red)),
        onTap: () {
          // logout logic
        },
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing,
    );
  }
}
