import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen_event.dart';
import 'home_screen_repository.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final HomeScreenRepository repository;

  HomeScreenBloc(this.repository) : super(HomeScreenInitial()) {
    on<FetchCustomerEvent>((event, emit) async {
      emit(HomeScreenLoading());

      try {
        final customers = await repository.fetchCustomers(event.requestBody);
        emit(HomeScreenCustomerLoaded(customers));
      } catch (e) {
        emit(HomeScreenError(e.toString()));
      }
    });

    on<FetchCategoryEvent>((event, emit) async {
      emit(HomeScreenLoading());

      try {
        final category = await repository.fetchCategory(event.requestBody);
        emit(HomeScreenCategoryLoaded(category));
      } catch (e) {
        emit(HomeScreenError(e.toString()));
      }
    });

    on<FetchProductEvent>((event, emit) async {
      emit(HomeScreenLoading());

      try {
        final products = await repository.fetchProduct(event.requestBody);
        emit(HomeScreenProductLoaded(products));
      } catch (e) {
        emit(HomeScreenError(e.toString()));
      }
    });
  }
}
