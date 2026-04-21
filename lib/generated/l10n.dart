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

  /// `Cardify`
  String get home {
    return Intl.message('Cardify', name: 'home', desc: '', args: []);
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

  /// `AI Card Generation`
  String get addCardWithAI {
    return Intl.message(
      'AI Card Generation',
      name: 'addCardWithAI',
      desc: '',
      args: [],
    );
  }

  /// `AI Card Generation`
  String get addNewCardWithAITitle {
    return Intl.message(
      'AI Card Generation',
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

  /// `Learn smarter with active recall and spaced repetition`
  String get createFlashcardSubtitle {
    return Intl.message(
      'Learn smarter with active recall and spaced repetition',
      name: 'createFlashcardSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Generate Smart Flashcards`
  String get GenerateSmartFlashcards {
    return Intl.message(
      'Generate Smart Flashcards',
      name: 'GenerateSmartFlashcards',
      desc: '',
      args: [],
    );
  }

  /// `Enter any words or phrases in any language and get images, definitions, word type, and examples in any language`
  String get EnterAnyWordsOrSentences {
    return Intl.message(
      'Enter any words or phrases in any language and get images, definitions, word type, and examples in any language',
      name: 'EnterAnyWordsOrSentences',
      desc: '',
      args: [],
    );
  }

  /// `Collection`
  String get selectCollection {
    return Intl.message(
      'Collection',
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

  /// `This may take a few seconds`
  String get generatingYourSmartCard {
    return Intl.message(
      'This may take a few seconds',
      name: 'generatingYourSmartCard',
      desc: '',
      args: [],
    );
  }

  /// `Please enter any amount of words or phrases to generate cards`
  String get pleaseEnterAWord {
    return Intl.message(
      'Please enter any amount of words or phrases to generate cards',
      name: 'pleaseEnterAWord',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields`
  String get PleaseFillAllFields {
    return Intl.message(
      'Please fill all fields',
      name: 'PleaseFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Please select a collection for your cards`
  String get PleaseSelectACollection {
    return Intl.message(
      'Please select a collection for your cards',
      name: 'PleaseSelectACollection',
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

  /// `Password`
  String get Password {
    return Intl.message('Password', name: 'Password', desc: '', args: []);
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

  /// `No collections found \n Start creating your collections and cards using the + button`
  String get NoCollectionsFound {
    return Intl.message(
      'No collections found \n Start creating your collections and cards using the + button',
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

  /// `Again`
  String get again {
    return Intl.message('Again', name: 'again', desc: '', args: []);
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
      desc: '',
      args: [errorMessage],
    );
  }

  /// `{count} cards`
  String cardsLabel(Object count) {
    return Intl.message(
      '$count cards',
      name: 'cardsLabel',
      desc: '',
      args: [count],
    );
  }

  /// `due`
  String get dueCards {
    return Intl.message('due', name: 'dueCards', desc: '', args: []);
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

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Sign In`
  String get signInTitle {
    return Intl.message('Sign In', name: 'signInTitle', desc: '', args: []);
  }

  /// `Sign in with your email and password \n or continue with social media`
  String get signInSubtitle {
    return Intl.message(
      'Sign in with your email and password \n or continue with social media',
      name: 'signInSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpTitle {
    return Intl.message('Sign Up', name: 'signUpTitle', desc: '', args: []);
  }

  /// `Register Account`
  String get registerAccount {
    return Intl.message(
      'Register Account',
      name: 'registerAccount',
      desc: '',
      args: [],
    );
  }

  /// `Complete your details or continue \n with social media`
  String get completeDetails {
    return Intl.message(
      'Complete your details or continue \n with social media',
      name: 'completeDetails',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Enter your first name`
  String get enterFirstName {
    return Intl.message(
      'Enter your first name',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Enter your last name`
  String get enterLastName {
    return Intl.message(
      'Enter your last name',
      name: 'enterLastName',
      desc: '',
      args: [],
    );
  }

  /// `By continuing your confirm that you agree with our term and condition`
  String get termsCondition {
    return Intl.message(
      'By continuing your confirm that you agree with our term and condition',
      name: 'termsCondition',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `please enter your email and we will send \n you a link to return to your account`
  String get forgotPasswordSubtitle {
    return Intl.message(
      'please enter your email and we will send \n you a link to return to your account',
      name: 'forgotPasswordSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Continue with Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get appLanguage {
    return Intl.message(
      'App Language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message('Free', name: 'free', desc: '', args: []);
  }

  /// `Delete Collection`
  String get deleteCollection {
    return Intl.message(
      'Delete Collection',
      name: 'deleteCollection',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this collection? This action cannot be undone.`
  String get deleteCollectionConfirm {
    return Intl.message(
      'Are you sure you want to delete this collection? This action cannot be undone.',
      name: 'deleteCollectionConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Rename Collection`
  String get renameCollection {
    return Intl.message(
      'Rename Collection',
      name: 'renameCollection',
      desc: '',
      args: [],
    );
  }

  /// `Collection Name`
  String get collectionName {
    return Intl.message(
      'Collection Name',
      name: 'collectionName',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get rename {
    return Intl.message('Rename', name: 'rename', desc: '', args: []);
  }

  /// `Delete Card`
  String get deleteCard {
    return Intl.message('Delete Card', name: 'deleteCard', desc: '', args: []);
  }

  /// `Are you sure you want to delete this card? This action cannot be undone.`
  String get deleteCardConfirm {
    return Intl.message(
      'Are you sure you want to delete this card? This action cannot be undone.',
      name: 'deleteCardConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Enable / Disable whiteboard`
  String get enableDisableWhiteboard {
    return Intl.message(
      'Enable / Disable whiteboard',
      name: 'enableDisableWhiteboard',
      desc: '',
      args: [],
    );
  }

  /// `Clear whiteboard`
  String get clearWhiteboard {
    return Intl.message(
      'Clear whiteboard',
      name: 'clearWhiteboard',
      desc: '',
      args: [],
    );
  }

  /// `Disable whiteboard`
  String get disableWhiteboard {
    return Intl.message(
      'Disable whiteboard',
      name: 'disableWhiteboard',
      desc: '',
      args: [],
    );
  }

  /// `Whiteboard color:`
  String get whiteboardColor {
    return Intl.message(
      'Whiteboard color:',
      name: 'whiteboardColor',
      desc: '',
      args: [],
    );
  }

  /// `Delete card`
  String get deleteCardMenu {
    return Intl.message(
      'Delete card',
      name: 'deleteCardMenu',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get NoInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'NoInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Basic`
  String get basic {
    return Intl.message('Basic', name: 'basic', desc: '', args: []);
  }

  /// `Front only`
  String get frontOnly {
    return Intl.message('Front only', name: 'frontOnly', desc: '', args: []);
  }

  /// `Type of Collection`
  String get typeOfCollection {
    return Intl.message(
      'Type of Collection',
      name: 'typeOfCollection',
      desc: '',
      args: [],
    );
  }

  /// `Search for a type of collection...`
  String get typeOfCollectionHint {
    return Intl.message(
      'Search for a type of collection...',
      name: 'typeOfCollectionHint',
      desc: '',
      args: [],
    );
  }

  /// `Choose an option`
  String get chooseAnOption {
    return Intl.message(
      'Choose an option',
      name: 'chooseAnOption',
      desc: '',
      args: [],
    );
  }

  /// `Choose from gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Choose from camera`
  String get chooseFromCamera {
    return Intl.message(
      'Choose from camera',
      name: 'chooseFromCamera',
      desc: '',
      args: [],
    );
  }

  /// `Select a Language`
  String get selectALanguage {
    return Intl.message(
      'Select a Language',
      name: 'selectALanguage',
      desc: '',
      args: [],
    );
  }

  /// `Search for a language...`
  String get searchLanguageHint {
    return Intl.message(
      'Search for a language...',
      name: 'searchLanguageHint',
      desc: '',
      args: [],
    );
  }

  /// `put "," or any anything between every word or phrase `
  String get putCommaBetweenEveryWordOrSentence {
    return Intl.message(
      'put "," or any anything between every word or phrase ',
      name: 'putCommaBetweenEveryWordOrSentence',
      desc: '',
      args: [],
    );
  }

  /// `is not valid, try to fix the spelling`
  String get isNotValidTryToFixTheSpelling {
    return Intl.message(
      'is not valid, try to fix the spelling',
      name: 'isNotValidTryToFixTheSpelling',
      desc: '',
      args: [],
    );
  }

  /// `No valid cards to add`
  String get noValidCardsToAdd {
    return Intl.message(
      'No valid cards to add',
      name: 'noValidCardsToAdd',
      desc: '',
      args: [],
    );
  }

  /// `Card deleted successfully`
  String get cardDeletedSuccessfully {
    return Intl.message(
      'Card deleted successfully',
      name: 'cardDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Red`
  String get red {
    return Intl.message('Red', name: 'red', desc: '', args: []);
  }

  /// `Blue`
  String get blue {
    return Intl.message('Blue', name: 'blue', desc: '', args: []);
  }

  /// `Green`
  String get green {
    return Intl.message('Green', name: 'green', desc: '', args: []);
  }

  /// `Yellow`
  String get yellow {
    return Intl.message('Yellow', name: 'yellow', desc: '', args: []);
  }

  /// `Orange`
  String get orange {
    return Intl.message('Orange', name: 'orange', desc: '', args: []);
  }

  /// `Purple`
  String get purple {
    return Intl.message('Purple', name: 'purple', desc: '', args: []);
  }

  /// `Pink`
  String get pink {
    return Intl.message('Pink', name: 'pink', desc: '', args: []);
  }

  /// `Black`
  String get black {
    return Intl.message('Black', name: 'black', desc: '', args: []);
  }

  /// `White`
  String get white {
    return Intl.message('White', name: 'white', desc: '', args: []);
  }

  /// `Color`
  String get color {
    return Intl.message('Color', name: 'color', desc: '', args: []);
  }

  /// `Please Enter Your `
  String get pleaseEnterYour {
    return Intl.message(
      'Please Enter Your ',
      name: 'pleaseEnterYour',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Successfully`
  String get signInSuccessMessage {
    return Intl.message(
      'Sign In Successfully',
      name: 'signInSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Question`
  String get EnterYourQuestion {
    return Intl.message(
      'Enter Your Question',
      name: 'EnterYourQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Answer`
  String get EnterYourAnswer {
    return Intl.message(
      'Enter Your Answer',
      name: 'EnterYourAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Information`
  String get EnterYourInformation {
    return Intl.message(
      'Enter Your Information',
      name: 'EnterYourInformation',
      desc: '',
      args: [],
    );
  }

  /// `Select Input Language`
  String get selectInputLanguage {
    return Intl.message(
      'Select Input Language',
      name: 'selectInputLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Select Output Language`
  String get selectOutputLanguage {
    return Intl.message(
      'Select Output Language',
      name: 'selectOutputLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations`
  String get congratulations {
    return Intl.message(
      'Congratulations',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `You reviewed`
  String get youReviewed {
    return Intl.message(
      'You reviewed',
      name: 'youReviewed',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Waiting for the next card...`
  String get waitingForTheNextCard {
    return Intl.message(
      'Waiting for the next card...',
      name: 'waitingForTheNextCard',
      desc: '',
      args: [],
    );
  }

  /// `The next card is after`
  String get theNextCardIsAfter {
    return Intl.message(
      'The next card is after',
      name: 'theNextCardIsAfter',
      desc: '',
      args: [],
    );
  }

  /// `cards in the learning list`
  String get cardsInTheLearningList {
    return Intl.message(
      'cards in the learning list',
      name: 'cardsInTheLearningList',
      desc: '',
      args: [],
    );
  }

  /// `Show the next card now`
  String get showTheNextCardNow {
    return Intl.message(
      'Show the next card now',
      name: 'showTheNextCardNow',
      desc: '',
      args: [],
    );
  }

  /// `due`
  String get due {
    return Intl.message('due', name: 'due', desc: '', args: []);
  }

  /// `all done ✓`
  String get all_done {
    return Intl.message('all done ✓', name: 'all_done', desc: '', args: []);
  }

  /// `Select Languages`
  String get selectLanguage {
    return Intl.message(
      'Select Languages',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `FROM`
  String get from {
    return Intl.message('FROM', name: 'from', desc: '', args: []);
  }

  /// `TO`
  String get to {
    return Intl.message('TO', name: 'to', desc: '', args: []);
  }

  /// `Select a language above first`
  String get selectInputFirst {
    return Intl.message(
      'Select a language above first',
      name: 'selectInputFirst',
      desc: '',
      args: [],
    );
  }

  /// `Failed to upload the image`
  String get FailedToUploadTheImage {
    return Intl.message(
      'Failed to upload the image',
      name: 'FailedToUploadTheImage',
      desc: '',
      args: [],
    );
  }

  /// `Edit Card`
  String get editCard {
    return Intl.message('Edit Card', name: 'editCard', desc: '', args: []);
  }

  /// `Image`
  String get image {
    return Intl.message('Image', name: 'image', desc: '', args: []);
  }

  /// `Word`
  String get word {
    return Intl.message('Word', name: 'word', desc: '', args: []);
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Definition`
  String get definition {
    return Intl.message('Definition', name: 'definition', desc: '', args: []);
  }

  /// `Example`
  String get example {
    return Intl.message('Example', name: 'example', desc: '', args: []);
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
