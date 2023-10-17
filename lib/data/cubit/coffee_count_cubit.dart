import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeCountCubit extends Cubit<int> {
  CoffeeCountCubit() : super(1); // Initialize the initial count to 1

  void incrementCount() => emit(state + 1);

  void defaultCount() => emit(1);

  void decrementCount() => emit(state > 1 ? state - 1 : 1); // Ensure count never goes below 1
}
