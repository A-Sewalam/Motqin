import 'package:flutter/material.dart';
import 'package:motqin/l10n/app_localizations.dart';

Widget adminSettings(BuildContext context){

  return Container(
    
    decoration: BoxDecoration(
      
    ),
    child: Row(
            children: [
              Icon(Icons.email_outlined, color: Colors.blue,),
              SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.admin_settings,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          )
  );
}