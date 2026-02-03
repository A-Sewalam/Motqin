import 'package:flutter/material.dart';
import 'package:motqin/l10n/app_localizations.dart';




Widget studyTimer(BuildContext context) {

  return Container(
    
    decoration: BoxDecoration(
      
    ),
    child: Row(
            children: [
              Icon(Icons.alarm, color: Colors.blue,),
              SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.study_timer,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          )
  );
}