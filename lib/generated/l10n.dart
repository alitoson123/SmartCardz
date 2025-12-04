// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Smart Cards`
  String get home {
    return Intl.message('Smart Cards', name: 'home', desc: '', args: []);
  }

  /// `cards`
  String get cards {
    return Intl.message('cards', name: 'cards', desc: '', args: []);
  }

  /// `Create New Collection`
  String get createNewCollection {
    return Intl.message(
      'Create New Collection',
      name: 'createNewCollection',
      desc: '',
      args: [],
    );
  }

  /// `Add Card`
  String get addCard {
    return Intl.message('Add Card', name: 'addCard', desc: '', args: []);
  }

  /// `Add Card with AI`
  String get addCardWithAI {
    return Intl.message(
      'Add Card with AI',
      name: 'addCardWithAI',
      desc: '',
      args: [],
    );
  }

  /// `Add New Card`
  String get addNewCardTitle {
    return Intl.message(
      'Add New Card',
      name: 'addNewCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add New Card with AI`
  String get addNewCardWithAITitle {
    return Intl.message(
      'Add New Card with AI',
      name: 'addNewCardWithAITitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Flashcard`
  String get createYourFlashcard {
    return Intl.message(
      'Create Your Flashcard',
      name: 'createYourFlashcard',
      desc: '',
      args: [],
    );
  }

  /// `Add a new word and its definition to your deck`
  String get createFlashcardSubtitle {
    return Intl.message(
      'Add a new word and its definition to your deck',
      name: 'createFlashcardSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Select a collection`
  String get selectCollection {
    return Intl.message(
      'Select a collection',
      name: 'selectCollection',
      desc: '',
      args: [],
    );
  }

  /// `Enter the front side`
  String get enterFrontSide {
    return Intl.message(
      'Enter the front side',
      name: 'enterFrontSide',
      desc: '',
      args: [],
    );
  }

  /// `Enter the back side`
  String get enterBackSide {
    return Intl.message(
      'Enter the back side',
      name: 'enterBackSide',
      desc: '',
      args: [],
    );
  }

  /// `Enter a word to generate...`
  String get enterWordToGenerate {
    return Intl.message(
      'Enter a word to generate...',
      name: 'enterWordToGenerate',
      desc: '',
      args: [],
    );
  }

  /// `Generating your smart card...`
  String get generatingYourSmartCard {
    return Intl.message(
      'Generating your smart card...',
      name: 'generatingYourSmartCard',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a word`
  String get pleaseEnterAWord {
    return Intl.message(
      'Please enter a word',
      name: 'pleaseEnterAWord',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields and select a collection`
  String get PleaseFillAllFieldsAndSelectACollection {
    return Intl.message(
      'Please fill all fields and select a collection',
      name: 'PleaseFillAllFieldsAndSelectACollection',
      desc: '',
      args: [],
    );
  }

  /// `Front Side`
  String get FrontSide {
    return Intl.message('Front Side', name: 'FrontSide', desc: '', args: []);
  }

  /// `Back Side`
  String get BackSide {
    return Intl.message('Back Side', name: 'BackSide', desc: '', args: []);
  }

  /// `Card saved successfully`
  String get CardSavedSuccessfully {
    return Intl.message(
      'Card saved successfully',
      name: 'CardSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message('Settings', name: 'settingsTitle', desc: '', args: []);
  }

  /// `Account`
  String get Account {
    return Intl.message('Account', name: 'Account', desc: '', args: []);
  }

  /// `Email`
  String get Email {
    return Intl.message('Email', name: 'Email', desc: '', args: []);
  }

  /// `Plan`
  String get Plan {
    return Intl.message('Plan', name: 'Plan', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Notification`
  String get Notification {
    return Intl.message(
      'Notification',
      name: 'Notification',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message('Appearance', name: 'appearance', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `About App`
  String get AboutApp {
    return Intl.message('About App', name: 'AboutApp', desc: '', args: []);
  }

  /// `Version`
  String get version {
    return Intl.message('Version', name: 'version', desc: '', args: []);
  }

  /// `Actions`
  String get actions {
    return Intl.message('Actions', name: 'actions', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `App Theme`
  String get appTheme {
    return Intl.message('App Theme', name: 'appTheme', desc: '', args: []);
  }

  /// `Create a New Collection`
  String get createCollectionTitle {
    return Intl.message(
      'Create a New Collection',
      name: 'createCollectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter collection name...`
  String get enterCollectionName {
    return Intl.message(
      'Enter collection name...',
      name: 'enterCollectionName',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Collection created successfully`
  String get CollectionCreatedSuccessfully {
    return Intl.message(
      'Collection created successfully',
      name: 'CollectionCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No collections found`
  String get NoCollectionsFound {
    return Intl.message(
      'No collections found',
      name: 'NoCollectionsFound',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get SomethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'SomethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Search for a collection`
  String get searchCollectionTitle {
    return Intl.message(
      'Search for a collection',
      name: 'searchCollectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search for a collection...`
  String get searchCollectionHint {
    return Intl.message(
      'Search for a collection...',
      name: 'searchCollectionHint',
      desc: '',
      args: [],
    );
  }

  /// `Revision`
  String get revisionTitle {
    return Intl.message('Revision', name: 'revisionTitle', desc: '', args: []);
  }

  /// `Easy`
  String get easy {
    return Intl.message('Easy', name: 'easy', desc: '', args: []);
  }

  /// `Medium`
  String get medium {
    return Intl.message('Medium', name: 'medium', desc: '', args: []);
  }

  /// `Hard`
  String get hard {
    return Intl.message('Hard', name: 'hard', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Select Image`
  String get selectImage {
    return Intl.message(
      'Select Image',
      name: 'selectImage',
      desc: '',
      args: [],
    );
  }

  /// `No cards due for review 🎉`
  String get noCardsDue {
    return Intl.message(
      'No cards due for review 🎉',
      name: 'noCardsDue',
      desc: '',
      args: [],
    );
  }

  /// `No front side data`
  String get noFrontSideData {
    return Intl.message(
      'No front side data',
      name: 'noFrontSideData',
      desc: '',
      args: [],
    );
  }

  /// `No back side data`
  String get noBackSideData {
    return Intl.message(
      'No back side data',
      name: 'noBackSideData',
      desc: '',
      args: [],
    );
  }

  /// `Show Answer`
  String get showAnswer {
    return Intl.message('Show Answer', name: 'showAnswer', desc: '', args: []);
  }

  /// `No front side data`
  String get NoFrontSideData {
    return Intl.message(
      'No front side data',
      name: 'NoFrontSideData',
      desc: '',
      args: [],
    );
  }

  /// `No back side data`
  String get NoBrontSideData {
    return Intl.message(
      'No back side data',
      name: 'NoBrontSideData',
      desc: '',
      args: [],
    );
  }

  /// `Rating saved ✅\nLoading next card...`
  String get ratingSavedLoadingNext {
    return Intl.message(
      'Rating saved ✅\nLoading next card...',
      name: 'ratingSavedLoadingNext',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected state (no handler)`
  String get unexpectedState {
    return Intl.message(
      'Unexpected state (no handler)',
      name: 'unexpectedState',
      desc: '',
      args: [],
    );
  }

  /// `Error: {errorMessage}`
  String errorOccurred(Object errorMessage) {
    return Intl.message(
      'Error: $errorMessage',
      name: 'errorOccurred',
      desc: 'Error message shown when fetch/rating fails',
      args: [errorMessage],
    );
  }

  /// `{count} cards`
  String cardsLabel(Object count) {
    return Intl.message(
      '$count cards',
      name: 'cardsLabel',
      desc: 'Cards count shown in item subtitle',
      args: [count],
    );
  }

  /// `Collections`
  String get collectionsTitle {
    return Intl.message(
      'Collections',
      name: 'collectionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `New collection`
  String get newCollection {
    return Intl.message(
      'New collection',
      name: 'newCollection',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get titleLabel {
    return Intl.message('Title', name: 'titleLabel', desc: '', args: []);
  }

  /// `Cards count`
  String get cardsCountLabel {
    return Intl.message(
      'Cards count',
      name: 'cardsCountLabel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
