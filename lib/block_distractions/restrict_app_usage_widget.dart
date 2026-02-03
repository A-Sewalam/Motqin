import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget restrictAppUsage()  {
    final apps = [
      {'icon': FontAwesomeIcons.facebook, 'name': 'Facebook', 'color': Colors.blue},
      {'icon': FontAwesomeIcons.whatsapp, 'name': 'WhatsApp', 'color': Colors.green},
      {'icon': FontAwesomeIcons.youtube, 'name': 'YouTube', 'color': Colors.red},
      {'icon': FontAwesomeIcons.instagram, 'name': 'Instagram', 'color': Colors.purple},
      {'icon': FontAwesomeIcons.twitter, 'name': 'X', 'color': Colors.black45},
      {'icon': FontAwesomeIcons.snapchat, 'name': 'SnapChat', 'color': Colors.yellow},
      {'icon': FontAwesomeIcons.tiktok, 'name': 'TikTok', 'color': Colors.black},
      {'icon': FontAwesomeIcons.telegram, 'name': 'Telegram', 'color': Colors.blue},
    ];

    return  Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
      
        ),
        child: ListView.builder(
          itemCount: apps.length, // build as many items as apps
          itemBuilder: (context, index) {
            final app = apps[index];
        
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      app['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (value) {
                      // handle toggle here
                    },
                    activeColor: const Color(0xFFE91E63),
                  ),
                ],
              ),
            );
          },
        ),
      );
  }