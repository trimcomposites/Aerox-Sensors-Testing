part of 'home_screen_bloc.dart';

enum HomeTab { home, database }

class HomeScreenState extends Equatable {
  final Racket? myRacket;
  final UIState uiState;
  final HomeTab selectedTab; 

  const HomeScreenState({
    this.myRacket,
    required this.uiState,
    this.selectedTab = HomeTab.home, 
  });
  
  HomeScreenState copyWith({
    Racket? racket,
    UIState? uiState,
    HomeTab? selectedTab, 
  }) => HomeScreenState(
    myRacket: racket ?? myRacket,
    uiState: uiState ?? this.uiState,
    selectedTab: selectedTab ?? this.selectedTab, 
  );
  
  @override
  List<Object?> get props => [myRacket, uiState, selectedTab]; 
}
