import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/core/views/widgets/selection_search_field.dart';
import 'package:smart_cards/generated/l10n.dart';

/// A single screen that lets the user pick both the input and output language.
///
/// The screen is split into two halves:
///   • Top  → "From" (input language)
///   • Bottom → "To" (output language)
///
/// Once the user taps a language in the **bottom** panel, the pair is confirmed
/// and the screen pops with:
///   { 'input_id', 'input_name', 'output_id', 'output_name' }
class SelectLanguagePair extends StatefulWidget {
  const SelectLanguagePair({super.key});

  @override
  State<SelectLanguagePair> createState() => _SelectLanguagePairState();
}

class _SelectLanguagePairState extends State<SelectLanguagePair>
    with SingleTickerProviderStateMixin {
  // ── language data ─────────────────────────────────────────────────────────
  static const List<Map<String, String>> _allLanguages = [
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

  // ── state ─────────────────────────────────────────────────────────────────
  Map<String, String>? _selectedInput;

  final TextEditingController _inputSearchCtrl = TextEditingController();
  final TextEditingController _outputSearchCtrl = TextEditingController();

  List<Map<String, String>> _filteredInput = List.of(_allLanguages);
  List<Map<String, String>> _filteredOutput = List.of(_allLanguages);

  // Scroll controllers so each panel scrolls independently
  final ScrollController _inputScrollCtrl = ScrollController();
  final ScrollController _outputScrollCtrl = ScrollController();

  late final AnimationController _arrowAnim;
  late final Animation<double> _arrowScale;

  @override
  void initState() {
    super.initState();
    _arrowAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _arrowScale = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(CurvedAnimation(parent: _arrowAnim, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _inputSearchCtrl.dispose();
    _outputSearchCtrl.dispose();
    _inputScrollCtrl.dispose();
    _outputScrollCtrl.dispose();
    _arrowAnim.dispose();
    super.dispose();
  }

  // ── helpers ───────────────────────────────────────────────────────────────
  void _filterInput(String query) {
    setState(() {
      _filteredInput = _applyFilter(query);
    });
  }

  void _filterOutput(String query) {
    setState(() {
      _filteredOutput = _applyFilter(query);
    });
  }

  List<Map<String, String>> _applyFilter(String query) {
    if (query.isEmpty) return List.of(_allLanguages);
    final q = query.toLowerCase();
    return _allLanguages.where((lang) {
      return lang['name']!.toLowerCase().contains(q) ||
          lang['nativeName']!.toLowerCase().contains(q);
    }).toList();
  }

  void _selectInput(Map<String, String> lang) {
    setState(() => _selectedInput = lang);
    // Pulse the arrow to draw the user's eye down
    _arrowAnim.forward(from: 0).then((_) => _arrowAnim.reverse());
  }

  void _confirm(Map<String, String> outputLang) {
    final input = _selectedInput!;
    Navigator.pop(context, {
      'input_id': input['id'],
      'input_name': input['name'],
      'output_id': outputLang['id'],
      'output_name': outputLang['name'],
    });
  }

  // ── build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).selectLanguage),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── INPUT PANEL ────────────────────────────────────────────────
          Expanded(
            child: _LanguagePanel(
              label: S.of(context).from,
              labelIcon: Icons.input_rounded,
              color: colorScheme.primary,
              searchController: _inputSearchCtrl,
              languages: _filteredInput,
              selectedId: _selectedInput?['id'],
              onSearch: _filterInput,
              scrollController: _inputScrollCtrl,
              onTap: _selectInput,
            ),
          ),

          // ── DIVIDER WITH ARROW ────────────────────────────────────────
          _LanguageDivider(
            selectedInput: _selectedInput,
            arrowScale: _arrowScale,
            primaryColor: colorScheme.primary,
          ),

          // ── OUTPUT PANEL ───────────────────────────────────────────────
          Expanded(
            child: _selectedInput == null
                ? const _LockedOutputPanel()
                : _LanguagePanel(
                    label: S.of(context).to,
                    labelIcon: Icons.output_rounded,
                    color: colorScheme.secondary,
                    searchController: _outputSearchCtrl,
                    languages: _filteredOutput,
                    selectedId: null,
                    onSearch: _filterOutput,
                    scrollController: _outputScrollCtrl,
                    onTap: _confirm,
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable panel ──────────────────────────────────────────────────────────

class _LanguagePanel extends StatelessWidget {
  const _LanguagePanel({
    required this.label,
    required this.labelIcon,
    required this.color,
    required this.searchController,
    required this.languages,
    required this.selectedId,
    required this.onSearch,
    required this.scrollController,
    required this.onTap,
  });

  final String label;
  final IconData labelIcon;
  final Color color;
  final TextEditingController searchController;
  final List<Map<String, String>> languages;
  final String? selectedId;
  final void Function(String) onSearch;
  final ScrollController scrollController;
  final void Function(Map<String, String>) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          child: Row(
            children: [
              Icon(labelIcon, size: 16.sp, color: color),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        // search field
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SelectionSearchField(
            searchController: searchController,
            onChanged: onSearch,
          ),
        ),
        SizedBox(height: 6.h),
        // list
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            itemCount: languages.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final lang = languages[index];
              final isSelected = lang['id'] == selectedId;
              return _SelectableLangItem(
                language: lang,
                isSelected: isSelected,
                selectedColor: color,
                onTap: () => onTap(lang),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Language item with selection highlight ───────────────────────────────────

class _SelectableLangItem extends StatelessWidget {
  const _SelectableLangItem({
    required this.language,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final Map<String, String> language;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? selectedColor.withOpacity(0.12) : theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected
              ? selectedColor
              : (isDark ? Colors.white10 : Colors.grey.shade200),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    (isSelected ? selectedColor : theme.primaryColor)
                        .withOpacity(isSelected ? 0.2 : 0.1),
                radius: 20.r,
                child: Text(
                  language['code']!.split('-').first.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? selectedColor : theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language['name']!,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    if (language['name'] != language['nativeName'])
                      Text(
                        language['nativeName']!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.hintColor,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: selectedColor,
                  size: 20.sp,
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: theme.hintColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Divider between the two panels ──────────────────────────────────────────

class _LanguageDivider extends StatelessWidget {
  const _LanguageDivider({
    required this.selectedInput,
    required this.arrowScale,
    required this.primaryColor,
  });

  final Map<String, String>? selectedInput;
  final Animation<double> arrowScale;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (selectedInput != null) ...[
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Text(
                selectedInput!['name']!,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),
          ],
          ScaleTransition(
            scale: arrowScale,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_downward_rounded,
                color: primaryColor,
                size: 18.sp,
              ),
            ),
          ),
          if (selectedInput != null)
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.hintColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Locked output panel shown before user picks input ───────────────────────

class _LockedOutputPanel extends StatelessWidget {
  const _LockedOutputPanel();

  @override
  Widget build(BuildContext context) {
    final hintColor = Theme.of(context).hintColor;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app_rounded,
            size: 40.sp,
            color: hintColor.withOpacity(0.4),
          ),
          SizedBox(height: 10.h),
          Text(
            S.of(context).selectInputFirst,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: hintColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
