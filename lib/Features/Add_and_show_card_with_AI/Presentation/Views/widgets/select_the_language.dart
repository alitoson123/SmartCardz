import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class SelectTheLanguage extends StatefulWidget {
  const SelectTheLanguage({super.key});

  @override
  State<SelectTheLanguage> createState() => _SelectTheLanguageState();
}

class _SelectTheLanguageState extends State<SelectTheLanguage> {
  final TextEditingController searchController = TextEditingController();

  // Comprehensive list of languages
  final List<Map<String, String>> _allLanguages = [
    {'id': '1', 'name': 'English', 'nativeName': 'English', 'code': 'en'},
    {'id': '2', 'name': 'Arabic', 'nativeName': 'العربية', 'code': 'ar'},
    {'id': '3', 'name': 'Spanish', 'nativeName': 'Español', 'code': 'es'},
    {'id': '4', 'name': 'French', 'nativeName': 'Français', 'code': 'fr'},
    {'id': '5', 'name': 'German', 'nativeName': 'Deutsch', 'code': 'de'},
    {'id': '6', 'name': 'Italian', 'nativeName': 'Italiano', 'code': 'it'},
    {'id': '7', 'name': 'Portuguese', 'nativeName': 'Português', 'code': 'pt'},
    {'id': '8', 'name': 'Russian', 'nativeName': 'Русский', 'code': 'ru'},
    {
      'id': '9',
      'name': 'Chinese (Simplified)',
      'nativeName': '简体中文',
      'code': 'zh-CN',
    },
    {'id': '10', 'name': 'Japanese', 'nativeName': '日本語', 'code': 'ja'},
    {'id': '11', 'name': 'Turkish', 'nativeName': 'Türkçe', 'code': 'tr'},
    {'id': '12', 'name': 'Hindi', 'nativeName': 'हिन्दी', 'code': 'hi'},
    {'id': '13', 'name': 'Korean', 'nativeName': '한국어', 'code': 'ko'},
    {'id': '14', 'name': 'Dutch', 'nativeName': 'Nederlands', 'code': 'nl'},
    {'id': '15', 'name': 'Swedish', 'nativeName': 'Svenska', 'code': 'sv'},
    {'id': '16', 'name': 'Polish', 'nativeName': 'Polski', 'code': 'pl'},
    {
      'id': '17',
      'name': 'Indonesian',
      'nativeName': 'Bahasa Indonesia',
      'code': 'id',
    },
    {
      'id': '18',
      'name': 'Vietnamese',
      'nativeName': 'Tiếng Việt',
      'code': 'vi',
    },
    {'id': '19', 'name': 'Thai', 'nativeName': 'ไทย', 'code': 'th'},
    {'id': '20', 'name': 'Greek', 'nativeName': 'Ελληνικά', 'code': 'el'},
    {'id': '21', 'name': 'Czech', 'nativeName': 'Čeština', 'code': 'cs'},
    {'id': '22', 'name': 'Danish', 'nativeName': 'Dansk', 'code': 'da'},
    {'id': '23', 'name': 'Finnish', 'nativeName': 'Suomi', 'code': 'fi'},
    {'id': '24', 'name': 'Norwegian', 'nativeName': 'Norsk', 'code': 'no'},
    {'id': '25', 'name': 'Hungarian', 'nativeName': 'Magyar', 'code': 'hu'},
    {'id': '26', 'name': 'Romanian', 'nativeName': 'Română', 'code': 'ro'},
    {'id': '27', 'name': 'Ukrainian', 'nativeName': 'Українська', 'code': 'uk'},
    {'id': '28', 'name': 'Hebrew', 'nativeName': 'עברית', 'code': 'he'},
    {'id': '29', 'name': 'Malay', 'nativeName': 'Bahasa Melayu', 'code': 'ms'},
    {'id': '30', 'name': 'Bengali', 'nativeName': 'বাংলা', 'code': 'bn'},
    {'id': '31', 'name': 'Persian', 'nativeName': 'فارسی', 'code': 'fa'},
    {'id': '32', 'name': 'Urdu', 'nativeName': 'اردو', 'code': 'ur'},
    {'id': '33', 'name': 'Tagalog', 'nativeName': 'Tagalog', 'code': 'tl'},
    {'id': '34', 'name': 'Swahili', 'nativeName': 'Kiswahili', 'code': 'sw'},
    {'id': '35', 'name': 'Tamil', 'nativeName': 'தமிழ்', 'code': 'ta'},
    {'id': '36', 'name': 'Telugu', 'nativeName': 'తెలుగు', 'code': 'te'},
    {'id': '37', 'name': 'Marathi', 'nativeName': 'मराठी', 'code': 'mr'},
    {'id': '38', 'name': 'Punjabi', 'nativeName': 'ਪੰਜਾਬੀ', 'code': 'pa'},
    {'id': '39', 'name': 'Gujarati', 'nativeName': 'ગુજરાતી', 'code': 'gu'},
    {'id': '40', 'name': 'Kannada', 'nativeName': 'ಕನ್ನಡ', 'code': 'kn'},
    {'id': '41', 'name': 'Malayalam', 'nativeName': 'മലയാളം', 'code': 'ml'},
    {'id': '42', 'name': 'Slovak', 'nativeName': 'Slovenčina', 'code': 'sk'},
    {'id': '43', 'name': 'Bulgarian', 'nativeName': 'Български', 'code': 'bg'},
    {'id': '44', 'name': 'Croatian', 'nativeName': 'Hrvatski', 'code': 'hr'},
    {'id': '45', 'name': 'Lithuanian', 'nativeName': 'Lietuvių', 'code': 'lt'},
    {
      'id': '46',
      'name': 'Slovenian',
      'nativeName': 'Slovenščina',
      'code': 'sl',
    },
    {'id': '47', 'name': 'Latvian', 'nativeName': 'Latviešu', 'code': 'lv'},
    {'id': '48', 'name': 'Estonian', 'nativeName': 'Eesti', 'code': 'et'},
    {'id': '49', 'name': 'Serbian', 'nativeName': 'Српски', 'code': 'sr'},
    {'id': '50', 'name': 'Catalan', 'nativeName': 'Català', 'code': 'ca'},
    {'id': '51', 'name': 'Basque', 'nativeName': 'Euskara', 'code': 'eu'},
    {'id': '52', 'name': 'Galician', 'nativeName': 'Galego', 'code': 'gl'},
    {'id': '53', 'name': 'Somali', 'nativeName': 'Soomaali', 'code': 'so'},
    {'id': '54', 'name': 'Afrikaans', 'nativeName': 'Afrikaans', 'code': 'af'},
    {'id': '55', 'name': 'Albanian', 'nativeName': 'Shqip', 'code': 'sq'},
    {'id': '56', 'name': 'Amharic', 'nativeName': 'አማርኛ', 'code': 'am'},
    {'id': '57', 'name': 'Armenian', 'nativeName': 'Հայերեն', 'code': 'hy'},
    {
      'id': '58',
      'name': 'Azerbaijani',
      'nativeName': 'Azərbaycan',
      'code': 'az',
    },
    {'id': '59', 'name': 'Burmese', 'nativeName': 'မြန်မာစာ', 'code': 'my'},
    {'id': '60', 'name': 'Cambodian', 'nativeName': 'ភាសាខ្មែរ', 'code': 'km'},
  ];

  List<Map<String, String>> _filteredLanguages = [];

  @override
  void initState() {
    super.initState();
    _filteredLanguages = _allLanguages;
  }

  void _filterLanguages(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLanguages = _allLanguages;
      } else {
        _filteredLanguages = _allLanguages.where((language) {
          final name = language['name']!.toLowerCase();
          final native = language['nativeName']!.toLowerCase();
          final search = query.toLowerCase();
          return name.contains(search) || native.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine colors based on theme
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final hintColor = theme.hintColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          S.of(context).selectALanguage,
          style:
              theme.appBarTheme.titleTextStyle ??
              TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
        ),
        leading: BackButton(color: textColor),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: isDark
                    ? [] // No shadow in dark mode for cleaner look
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(.5),
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                border: isDark ? Border.all(color: Colors.white10) : null,
              ),
              child: TextField(
                controller: searchController,
                onChanged: _filterLanguages,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: hintColor),
                  hintText: S.of(context).searchLanguageHint,
                  hintStyle: TextStyle(color: hintColor, fontSize: 14.sp),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: _filteredLanguages.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final language = _filteredLanguages[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, {
                      'id': language['id'],
                      'name': language['name'],
                    });
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          radius: 20.r,
                          child: Text(
                            language['code']!.split('-').first.toUpperCase(),
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              language['name']!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            if (language['name'] != language['nativeName'])
                              Text(
                                language['nativeName']!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: hintColor,
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16.sp,
                          color: hintColor,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.h, top: 8.h),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
