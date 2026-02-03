import 'package:flutter/material.dart';
import 'package:motqin/l10n/app_localizations.dart';

Widget blockOptions(BuildContext context){


  return Container(
    
    decoration: BoxDecoration(
      
    ),
    child: Row(
            children: [
              Icon(Icons.shield_outlined, color: Colors.blue,),
              SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.block_options,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          )
  );
}