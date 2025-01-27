part of 'details_screen_bloc.dart';

class DetailsScreenState extends Equatable {
  final bool isLoading;
  final bool isError;

  const DetailsScreenState({
    required this.isLoading, 
    required this.isError
  });

  copyWith({
    bool? isLoading,
    bool? isError
  }) => DetailsScreenState(
    isLoading: isLoading ?? this.isLoading,
    isError: isError ?? this.isError
  );

  
  @override
  List<Object> get props => [];
}


