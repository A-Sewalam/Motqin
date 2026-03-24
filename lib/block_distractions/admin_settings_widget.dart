import 'package:flutter/material.dart';

class AdminSettingsWidget extends StatefulWidget {
  const AdminSettingsWidget({super.key});

  @override
  State<AdminSettingsWidget> createState() => _AdminSettingsWidgetState();
}

class _AdminSettingsWidgetState extends State<AdminSettingsWidget> {
  final TextEditingController _emailController = TextEditingController();

  // States: 'initial' | 'form' | 'active'
  String _state = 'initial';
  String _adminEmail = '';

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email.trim());
  }

  void _onConfirm() {
    final email = _emailController.text.trim();

    if (!_isValidEmail(email)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Text(
            'يرجى ادخال بريد الكتروني صحيح',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('حسناً',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB))),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text(
          'تم تعيين المشرف بنجاح. الآن لا يمكن تغيير الإعدادات إلا بموافقة المشرف.',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _adminEmail = email;
                _state = 'active';
                _emailController.clear();
              });
            },
            child: const Text('حسناً',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB))),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.email_outlined,
                  color: Color(0xFFEA580C), size: 22),
              const SizedBox(width: 10),
              const Text(
                'إعدادات المشرف',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const Spacer(),
              // Show "مفعل" badge when active
              if (_state == 'active')
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.lock_outline,
                          color: Color(0xFF16A34A), size: 16),
                      SizedBox(width: 4),
                      Text('مفعل',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16A34A))),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // ── State: initial ────────────────────────────────────
          if (_state == 'initial') ...[
            // Info box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDD5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Text(
                    'إضافة بريد المشرف سيمنعك من تغيير إعدادات الحجب بسهولة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFEA580C),
                        height: 1.6),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'سيتطلب إدخال بريد المشرف لإلغاء الحجب أو تغيير الإعدادات',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFED7331),
                        height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () => setState(() => _state = 'form'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA580C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('إضافة مشرف',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],

          // ── State: form ───────────────────────────────────────
          if (_state == 'form') ...[
            // Email field with orange border
            TextField(
              controller: _emailController,
              textDirection: TextDirection.rtl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'أدخل بريد المشرف الإلكتروني',
                hintStyle:
                    const TextStyle(fontSize: 14, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: Color(0xFFEA580C), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                      color: Color(0xFFEA580C), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 14),

            // تأكيد / إلغاء buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('تأكيد',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _emailController.clear();
                      setState(() => _state = 'initial');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B7280),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('إلغاء',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],

          // ── State: active ─────────────────────────────────────
          if (_state == 'active') ...[
            // Green active box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.lock_outline,
                          color: Color(0xFF16A34A), size: 22),
                      SizedBox(width: 8),
                      Text(
                        'المشرف مفعل',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF16A34A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'البريد الإلكتروني: $_adminEmail',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF16A34A)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'الآن لا يمكن تغيير إعدادات الحجب إلا بموافقة المشرف',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
