import 'package:flutter/material.dart';
import 'package:motqin/block_distractions/block_options_widget.dart';
import 'package:motqin/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motqin/block_distractions/restrict_app_usage_widget.dart';

class BlockDistractionsScreen extends StatefulWidget {
  const BlockDistractionsScreen({super.key});

  @override
  State<BlockDistractionsScreen> createState() => _BlockDistractionsContentState();
}

class _BlockDistractionsContentState extends State<BlockDistractionsScreen> {
  bool isFocusModeOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
      
            Row(
              children: [
                Icon(Icons.phone_android_outlined, color: Colors.blue,),
                SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.restrict_app_usage,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            restrictAppUsage(),
      
            SizedBox(height: 12),
            blockOptions(context),
      
            SizedBox(height: 12),
            
            _buildSettingItem(
              icon: Icons.notifications_off,
              title: 'كتم الإشعارات',
              subtitle: 'منع جميع الإشعارات',
              value: true,
            ),
            _buildSettingItem(
              icon: Icons.phone_disabled,
              title: 'حظر المكالمات',
              subtitle: 'السماح للطوارئ فقط',
              value: false,
            ),
            _buildSettingItem(
              icon: Icons.apps,
              title:'حظر التطبيقات',
              subtitle: 'منع التطبيقات المشتتة',
              value: true,
            ),
            _buildSettingItem(
            icon: Icons.access_time,
            title: 'مؤقت بومودورو',
            subtitle: '25 دقيقة عمل، 5 دقائق راحة',
            value: false,
            ),
            SizedBox(height: 20),
        
      
        
        ...List.generate(8, (index) {
          final apps = [
            {'icon': FontAwesomeIcons.facebook, 'name': 'Facebook', 'color': Colors.blue},
            {'icon': FontAwesomeIcons.whatsapp, 'name': 'WhatsApp', 'color': Colors.green},
            {'icon': FontAwesomeIcons.youtube, 'name': 'YouTube', 'color': Colors.red},
            {'icon': FontAwesomeIcons.instagram, 'name': 'Instagram', 'color': Colors.purple},
            {'icon': FontAwesomeIcons.twitter, 'name': 'X', 'color': Colors.black45},
            {'icon': FontAwesomeIcons.snapchat, 'name': 'SnapChat', 'color': Colors.purple},
            {'icon': FontAwesomeIcons.tiktok, 'name': 'TikTok', 'color': Colors.purple},
            {'icon': FontAwesomeIcons.telegram, 'name': 'Telegram', 'color': Colors.purple},
          ];
          
          final app = apps[index % apps.length];
          
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                 Icon(
                    app['icon'] as IconData,
                    color: app['color'] as Color,
                  ),
                
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    app['name'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: Color(0xFFE91E63),
                ),
              ],
            ),
          );
        }),
      ],
        ),
      ),
    );
}
Widget _buildSettingItem({
required IconData icon,
required String title,
required String subtitle,
required bool value,
}) {
return Container(
margin: EdgeInsets.only(bottom: 12),
padding: EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(12),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 10,
offset: Offset(0, 4),
),
],
),
child: Row(
children: [
Container(
width: 50,
height: 50,
decoration: BoxDecoration(
color: Color(0xFFE91E63).withOpacity(0.1),
borderRadius: BorderRadius.circular(10),
),
child: Icon(icon, color: Color(0xFFE91E63)),
),
SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
Text(
subtitle,
style: TextStyle(color: Colors.grey, fontSize: 14),
),
],
),
),
Switch(
value: value,
onChanged: (v) {},
activeColor: Color(0xFFE91E63),
),
],
),
);
}
}

// Container(   
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFF8BBD0), Color(0xFFF48FB1)],
//               ),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   isFocusModeOn ? Icons.block : Icons.block_outlined,
//                   size: 60,
//                   color: Color(0xFFE91E63),
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   isFocusModeOn ? 'وضع التركيز مفعل' : 'وضع التركيز متوقف',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       isFocusModeOn = !isFocusModeOn;
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Color(0xFFE91E63),
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                   ),
//                   child: Text(
//                     isFocusModeOn ? 'إيقاف' : 'تفعيل',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             ),
//           ),