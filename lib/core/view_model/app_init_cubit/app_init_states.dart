class AppInitState {}

class AppInitInitialState extends AppInitState {}

class AppInitLoadingState extends AppInitState {}

class AppInitSuccessState extends AppInitState {}

class AppInitFailedState extends AppInitState {
  final String errMessage;

  AppInitFailedState({required this.errMessage});
}
