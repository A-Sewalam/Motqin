import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @login_to_your_account.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول إلى حسابك'**
  String get login_to_your_account;

  /// No description provided for @enter_your_email.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني'**
  String get enter_your_email;

  /// No description provided for @enter_your_password.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور'**
  String get enter_your_password;

  /// No description provided for @forget_password.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forget_password;

  /// No description provided for @dont_have_an_account.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get dont_have_an_account;

  /// No description provided for @sign_up.
  ///
  /// In ar, this message translates to:
  /// **'سجل الآن'**
  String get sign_up;

  /// No description provided for @sign_up_with_google.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل حساب جديد باستخدام جوجل'**
  String get sign_up_with_google;

  /// No description provided for @sign_up_with_facebook.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل حساب جديد باستخدام فيسبوك'**
  String get sign_up_with_facebook;

  /// No description provided for @create_your_account.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حسابك'**
  String get create_your_account;

  /// No description provided for @enter_your_name.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسمك'**
  String get enter_your_name;

  /// No description provided for @confirm_your_password.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirm_your_password;

  /// No description provided for @already_have_an_account.
  ///
  /// In ar, this message translates to:
  /// **'هل لديك حساب بالفعل؟'**
  String get already_have_an_account;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @or.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get or;

  /// No description provided for @user_name.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get user_name;

  /// No description provided for @leaderboards_and_competitions.
  ///
  /// In ar, this message translates to:
  /// **'قوائم الصدارة والمسابقات'**
  String get leaderboards_and_competitions;

  /// No description provided for @master_your_lessons.
  ///
  /// In ar, this message translates to:
  /// **'اتقن دروسك'**
  String get master_your_lessons;

  /// No description provided for @understand_your_lessons.
  ///
  /// In ar, this message translates to:
  /// **'افهم دروسك'**
  String get understand_your_lessons;

  /// No description provided for @block_distractions.
  ///
  /// In ar, this message translates to:
  /// **'منع المشتتات'**
  String get block_distractions;

  /// No description provided for @restrict_app_usage.
  ///
  /// In ar, this message translates to:
  /// **'حجب التطبيقات'**
  String get restrict_app_usage;

  /// No description provided for @block_options.
  ///
  /// In ar, this message translates to:
  /// **'خيارات الحجب'**
  String get block_options;

  /// No description provided for @admin_settings.
  ///
  /// In ar, this message translates to:
  /// **'اعدادات المشرف'**
  String get admin_settings;

  /// No description provided for @study_timer.
  ///
  /// In ar, this message translates to:
  /// **'Study timer'**
  String get study_timer;

  /// No description provided for @end.
  ///
  /// In ar, this message translates to:
  /// **''**
  String get end;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
