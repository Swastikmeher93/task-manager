import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TextEditingController _dueDateController = TextEditingController();
  Widget _buildLabel(String text, {bool isOptional = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 24.0),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: const Color(0xFF595C67),
            ),
          ),
          if (isOptional)
            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                '(optional)',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFA5A7B4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    String? hint,
    int maxLines = 1,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextEditingController? controller,
    Color hintColor = const Color(0xFFA5A7B4),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBECEF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: hintColor,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF15161E),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF15161E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Task',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF15161E),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Ritual',
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF3B50C1),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Define your intention and set your focus for today.',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF595C67),
                height: 1.4,
              ),
            ),
            
            _buildLabel('TASK TITLE'),
            _buildTextField(hint: 'What is your focus?'),
            
            _buildLabel('DESCRIPTION'),
            _buildTextField(hint: 'Add more details about this ritual...', maxLines: 4),
            
            _buildLabel('DUE DATE'),
            _buildTextField(
              hint: 'mm/dd/yyyy',
              hintColor: const Color(0xFF15161E),
              prefixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF3B50C1), size: 20),
              readOnly: true,
              controller: _dueDateController,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF3B50C1), // header background color
                          onPrimary: Colors.white, // header text color
                          onSurface: Color(0xFF15161E), // body text color
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (selectedDate != null) {
                  _dueDateController.text = DateFormat('MM/dd/yyyy').format(selectedDate);
                }
              },
            ),

            _buildLabel('CURRENT STATUS'),
            _buildTextField(
              hint: 'To-Do',
              hintColor: const Color(0xFF15161E),
              prefixIcon: const Icon(Icons.pending_actions_outlined, color: Color(0xFF3B50C1), size: 20),
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF8B90A0)),
            ),

            _buildLabel('BLOCKED BY', isOptional: true),
            _buildTextField(
              hint: 'No dependency',
              hintColor: const Color(0xFF15161E),
              prefixIcon: const Icon(Icons.link_off_rounded, color: Color(0xFF3B50C1), size: 20),
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF8B90A0)),
            ),

            const SizedBox(height: 40),
            
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF2F42A6),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2F42A6).withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Save Task',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _dueDateController.dispose();
    super.dispose();
  }
}
