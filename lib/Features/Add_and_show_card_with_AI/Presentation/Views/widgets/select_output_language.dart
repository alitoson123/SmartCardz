import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/select_the_language_item.dart';
import 'package:smart_cards/core/views/widgets/cancel_widget.dart';
import 'package:smart_cards/core/views/widgets/selection_search_field.dart';
import 'package:smart_cards/generated/l10n.dart';

class SelectOutputLanguage extends StatefulWidget {
  const SelectOutputLanguage({super.key});

  @override
  State<SelectOutputLanguage> createState() => _SelectOutputLanguageState();
}

class _SelectOutputLanguageState extends State<SelectOutputLanguage> {
  final TextEditingController searchController = TextEditingController();

  // Comprehensive list of languages
  final List<Map<String, String>> allLanguages = [
    // All the supported languages
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

  List<Map<String, String>> filteredLanguages =
      []; // Filtered list of languages

  @override
  void initState() {
    super.initState();
    filteredLanguages = allLanguages;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: Text(S.of(context).selectOutputLanguage)),
      body: Column(
        children: [
          //***************************************************** */
          //   search Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: SelectionSearchField(
              searchController: searchController,
              onChanged: filterLanguages,
            ),
          ),

          //***************************************************** */
          //   list of languages
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: filteredLanguages.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final language = filteredLanguages[index];
                return SelectTheLanguageItem(
                  language: language,
                  onTap: () {
                    Navigator.pop(context, {
                      'output_id': language['id'],
                      'output_name': language['name'],
                    });
                  },
                );
              },
            ),
          ),

          //***************************************************** */
          //   cancel button
          const CancelWidget(),
        ],
      ),
    );
  }

  // filter the languages (search Function)
  void filterLanguages(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLanguages = allLanguages;
      } else {
        filteredLanguages = allLanguages.where((language) {
          final name = language['name']!.toLowerCase();
          final native = language['nativeName']!.toLowerCase();
          final search = query.toLowerCase();
          return name.contains(search) || native.contains(search);
        }).toList();
      }
    });
  }
}
