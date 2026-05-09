import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzin/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Foto Profil & Edit Icon
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Obx(
                          () => CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              controller.profilePicUrl.value,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.updatePhoto(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0056FF),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'TAP TO UPDATE PHOTO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            //  Kartu Personal Information 
            _buildSectionCard(
              icon: Icons.person_outline,
              title: 'Personal Information',
              children: [
                _buildInputField('Full Name', controller.nameController),
                const SizedBox(height: 16),
                _buildInputField('Email Address', controller.emailController),
              ],
            ),
            const SizedBox(height: 16),

            //  Kartu Academic Details 
            _buildSectionCard(
              icon: Icons.school_outlined,
              title: 'Academic Details',
              children: [
                _buildInputField(
                  'Academic Level',
                  controller.levelController,
                  hasDropdown: true,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  'Major/Area of Interest',
                  controller.majorController,
                ),
              ],
            ),
            const SizedBox(height: 16),

            //  Kartu Security & Preferences 
            _buildSectionCard(
              icon: Icons.settings_outlined,
              title: 'Security & Preferences',
              children: [
                _buildPreferenceTile(Icons.lock_outline, 'Change Password'),
                const SizedBox(height: 12),
                _buildPreferenceTile(
                  Icons.notifications_none,
                  'Notification Settings',
                ),
              ],
            ),
            const SizedBox(height: 32),

            //  Tombol Save & Logout 
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => controller.saveChanges(),
                icon: const Icon(Icons.save_outlined, size: 20),
                label: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => controller.logout(),
                icon: const Icon(Icons.logout, size: 20),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD32F2F), // Merah
                  side: const BorderSide(color: Color(0xFFD32F2F)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper: Membuat Card putih sebagai kontainer
  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1A365D), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // Helper: Membuat TextField dengan label di atasnya
  Widget _buildInputField(
    String label,
    TextEditingController textController, {
    bool hasDropdown = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: TextField(
            controller: textController,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0056FF)),
              ),
              suffixIcon: hasDropdown
                  ? const Icon(Icons.keyboard_arrow_down, color: Colors.grey)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  // Helper: Membuat tombol pengaturan (Change Password / Notifications)
  Widget _buildPreferenceTile(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87, size: 20),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
      ),
    );
  }
}
