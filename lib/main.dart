import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFFB6C1),
        scaffoldBackgroundColor: const Color(0xFFFFF0F3),
      ),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  // State variables for pickers (Keeping Role as requested)
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Student';

  // 1. Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 2. Cupertino Date Picker
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  // 4. Cupertino Wheel Picker for Role
  void _showCupertinoRolePicker(BuildContext context) {
    final List<String> roles = ['Student', 'Developer', 'Designer'];
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoPicker(
          itemExtent: 32,
          scrollController: FixedExtentScrollController(
            initialItem: roles.indexOf(_selectedRole),
          ),
          onSelectedItemChanged: (int index) {
            setState(() => _selectedRole = roles[index]);
          },
          children: roles.map((role) => Center(child: Text(role))).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = "${_selectedDate.toLocal()}".split(' ')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC0CB),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView(formattedDate)
              : _buildLandscapeView(formattedDate);
        },
      ),
    );
  }

  // --- PORTRAIT VIEW ---
  Widget _buildPortraitView(String formattedDate) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const StudentPinkCard(),
        const SizedBox(height: 16),
        const TitleSection(
          name: 'University of Technology Sarawak',
          locationText: 'Sibu, Sarawak',
          locationAssetImage: 'assets/profile.jpg',
          starCount: 41,
        ),
        const SizedBox(height: 16),
        const ImageSection(imagePath: 'assets/Location.jpg'),
        const SizedBox(height: 24),
        _buildInteractivePickersCard(formattedDate),
      ],
    );
  }

  // --- LANDSCAPE VIEW ---
  Widget _buildLandscapeView(String formattedDate) {
    return Row(
      children: [
        const Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: StudentPinkCard(),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const TitleSection(
                name: 'University of Technology Sarawak',
                locationText: 'Sibu, Sarawak',
                locationAssetImage: 'assets/profile.jpg',
                starCount: 41,
              ),
              const SizedBox(height: 16),
              const ImageSection(imagePath: 'assets/Location.jpg'),
              const SizedBox(height: 24),
              _buildInteractivePickersCard(formattedDate),
            ],
          ),
        ),
      ],
    );
  }

  // --- INTERACTIVE PICKERS CARD (Matching Screenshot Layout) ---
  Widget _buildInteractivePickersCard(String formattedDate) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Header Title
            const Text(
              'Interactive Pickers (Lab 2.2)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(height: 24, thickness: 1),

            // Selected Summary
            Text(
              'Selected Date: $formattedDate',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Selected Role: $_selectedRole',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF3F51B5),
              ),
            ),
            const SizedBox(height: 20),

            // 1. Material Date Picker Button (Outlined / Pill style)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: BorderSide(color: Colors.grey.shade400),
                foregroundColor: Colors.black87,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () => _selectMaterialDate(context),
              icon: const Icon(Icons.calendar_today, size: 18, color: Color(0xFFD81B60)),
              label: const Text('Material Date Picker'),
            ),
            const SizedBox(height: 12),

            // 2. Cupertino Date Picker Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: BorderSide(color: Colors.grey.shade400),
                foregroundColor: Colors.black87,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () => _showCupertinoDatePicker(context),
              icon: const Icon(Icons.date_range, size: 18, color: Color(0xFFD81B60)),
              label: const Text('Cupertino Date Picker (Modal Sheet)'),
            ),
            const SizedBox(height: 16),

            // 3. Material Dropdown Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Material Dropdown',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                DropdownButton<String>(
                  value: _selectedRole,
                  elevation: 4,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  underline: const SizedBox(), // Clean underline
                  items: ['Student', 'Developer', 'Designer'].map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedRole = newValue);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 4. Cupertino Wheel Picker Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: BorderSide(color: Colors.grey.shade400),
                foregroundColor: Colors.black87,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onPressed: () => _showCupertinoRolePicker(context),
              icon: const Icon(Icons.unfold_more, size: 18, color: Color(0xFFD81B60)),
              label: const Text('Cupertino Wheel Picker (Role)'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- STUDENT PINK CARD ---
class StudentPinkCard extends StatelessWidget {
  const StudentPinkCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB6C1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          const SizedBox(height: 16),
          const Text(
            "MU'IZZATUL EISYA",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Student ID: BCS24020035',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Colors.white24, thickness: 1),
          ),
          const Text(
            'Personal Life Goal / Quote:',
            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          const Text(
            '"I want to make my parent proud of me"',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 13, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

// --- TITLE SECTION ---
class TitleSection extends StatelessWidget {
  final String name;
  final String locationText;
  final String locationAssetImage;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.locationText,
    required this.locationAssetImage,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: AssetImage(locationAssetImage),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      locationText,
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.pink[400]),
          const SizedBox(width: 4),
          Text('$starCount', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- IMAGE SECTION ---
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.pink[50],
            child: const Center(
              child: Icon(Icons.image, size: 50, color: Colors.pinkAccent),
            ),
          );
        },
      ),
    );
  }
}