import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class LocalizationEndpoint extends Endpoint {
  static const Map<String, Map<String, String>> _defaultBundles = {
    'en': {
      'auth.welcome_title': 'Welcome to Chat',
      'auth.phone_subtitle': 'Enter your phone number to sign in or create an account',
      'auth.phone_label': 'Phone Number',
      'auth.send_code_button': 'Continue',
      'auth.verify_title': 'Verify Code',
      'auth.verify_subtitle': 'Enter the 6-digit code sent to your phone',
      'auth.resend_code': 'Resend Code',
      'chat.conversations_title': 'Chats',
      'chat.empty_conversations': 'No conversations yet. Start a new chat!',
      'chat.new_chat_button': 'New Chat',
      'chat.search_placeholder': 'Search conversations or users...',
      'chat.message_input_placeholder': 'Type a message...',
      'chat.send_button': 'Send',
      'chat.status_online': 'Online',
      'chat.status_offline': 'Offline',
      'chat.typing': 'typing...',
      'profile.title': 'Profile',
      'profile.display_name_label': 'Display Name',
      'profile.bio_label': 'Status / Bio',
      'profile.save_button': 'Save Changes',
      'profile.change_photo': 'Change Photo',
      'profile.my_qr_code': 'My QR Code',
      'settings.title': 'Settings',
      'settings.theme_label': 'Appearance',
      'settings.theme_system': 'System Default',
      'settings.theme_light': 'Light Mode',
      'settings.theme_dark': 'Dark Mode',
      'settings.notifications_label': 'Notifications',
      'settings.notifications_subtitle': 'Receive alerts for new messages',
      'settings.logout_button': 'Log Out',
      'auth.change_phone': 'Change phone number',
      'auth.enter_valid_phone': 'Please enter a valid phone number',
      'auth.enter_valid_code': 'Please enter a 6-digit code',
      'contacts.title': 'Contacts',
      'contacts.search_placeholder': 'Search contacts...',
      'contacts.sync_button': 'Sync Contacts',
      'contacts.invite_button': 'Invite Friends',
      'contacts.empty': 'No contacts found',
      'common.error': 'Something went wrong',
      'common.save': 'Save',
      'common.cancel': 'Cancel',
      'common.search': 'Search',
    },
    'ar': {
      'auth.welcome_title': 'مرحباً بك في المحادثات',
      'auth.phone_subtitle': 'أدخل رقم هاتفك لتسجيل الدخول أو إنشاء حساب',
      'auth.phone_label': 'رقم الهاتف',
      'auth.send_code_button': 'متابعة',
      'auth.verify_title': 'تأكيد الرمز',
      'auth.verify_subtitle': 'أدخل الرمز المكون من 6 أرقام المرسل إلى هاتفك',
      'auth.resend_code': 'إعادة إرسال الرمز',
      'auth.change_phone': 'تغيير رقم الهاتف',
      'auth.enter_valid_phone': 'الرجاء إدخال رقم هاتف صحيح',
      'auth.enter_valid_code': 'الرجاء إدخال رمز مكون من 6 أرقام',
      'chat.conversations_title': 'المحادثات',
      'chat.empty_conversations': 'لا توجد محادثات حتى الآن. ابدأ محادثة جديدة!',
      'chat.new_chat_button': 'محادثة جديدة',
      'chat.search_placeholder': 'بحث في المحادثات أو المستخدمين...',
      'chat.message_input_placeholder': 'اكتب رسالة...',
      'chat.send_button': 'إرسال',
      'chat.status_online': 'متصل',
      'chat.status_offline': 'غير متصل',
      'chat.typing': 'يكتب الآن...',
      'profile.title': 'الملف الشخصي',
      'profile.display_name_label': 'الاسم المستعار',
      'profile.bio_label': 'الحالة / النبذة',
      'profile.save_button': 'حفظ التغييرات',
      'profile.change_photo': 'تغيير الصورة',
      'profile.my_qr_code': 'رمز QR الخاص بي',
      'settings.title': 'الإعدادات',
      'settings.theme_label': 'المظهر',
      'settings.theme_system': 'الوضع التلقائي',
      'settings.theme_light': 'الوضع الفاتح',
      'settings.theme_dark': 'الوضع الداكن',
      'settings.notifications_label': 'الإشعارات',
      'settings.notifications_subtitle': 'تلقي تنبيهات عند وصول رسائل جديدة',
      'settings.logout_button': 'تسجيل الخروج',
      'contacts.title': 'جهات الاتصال',
      'contacts.search_placeholder': 'البحث في جهات الاتصال...',
      'contacts.sync_button': 'مزامنة جهات الاتصال',
      'contacts.invite_button': 'دعوة الأصدقاء',
      'contacts.empty': 'لم يتم العثور على جهات اتصال',
      'common.error': 'حدث خطأ غير متوقع',
      'common.save': 'حفظ',
      'common.cancel': 'إلغاء',
      'common.search': 'بحث',
    },
  };

  /// Returns localized translation dictionary for given [locale]
  Future<TranslationBundle> getTranslations(
    Session session, {
    String locale = 'en',
    int? clientVersion,
  }) async {
    final normalizedLocale = locale.toLowerCase().split('_').first;
    final fallbackMap = _defaultBundles[normalizedLocale] ?? _defaultBundles['en']!;

    // Query database for custom/updated translations
    List<AppTranslation> dbTranslations = [];
    try {
      dbTranslations = await AppTranslation.db.find(
        session,
        where: (t) => t.locale.equals(normalizedLocale),
      );
    } catch (e) {
      // In tests or offline without database connection, fallback to defaults
      session.log('Database query for translations fallback to in-memory: $e');
    }

    final resultMap = Map<String, String>.from(fallbackMap);
    int currentVersion = 1;

    for (final translation in dbTranslations) {
      resultMap[translation.key] = translation.value;
      if (translation.version > currentVersion) {
        currentVersion = translation.version;
      }
    }

    return TranslationBundle(
      locale: normalizedLocale,
      version: currentVersion,
      translations: resultMap,
    );
  }
}
