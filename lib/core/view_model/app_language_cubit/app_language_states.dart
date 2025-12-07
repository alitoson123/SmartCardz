
class AppLanguageState {
  final String appLanguage;
  const AppLanguageState(this.appLanguage);
}

class AppLanguageInitialState extends AppLanguageState {
  const AppLanguageInitialState() : super('en');
}

class AppLanguageEnState extends AppLanguageState {
  const AppLanguageEnState() : super('en');
}

class AppLanguageArState extends AppLanguageState {
  const AppLanguageArState() : super('ar');
}
