import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pharmacyapp/domain/auth/entity/user.dart';
import 'package:pharmacyapp/domain/auth/usecases/get_user.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final UserEntity user;

  AccountLoaded({required this.user});
}

class AccountFailure extends AccountState {}

class AccountCubit extends Cubit<AccountState> {
  final GetUserUseCase useCase;
  final Logger logger = Logger();

  AccountCubit({required this.useCase}) : super(AccountInitial());

  Future<void> fetchUserDetails() async {
    emit(AccountLoading());
    try {
      final result = await useCase(); // result is Either<Failure, UserEntity>

      result.fold(
        (failure) {
          // Handle the failure case
          logger.e('Error fetching user details: $failure');
          emit(AccountFailure());
        },
        (user) {
          // Handle the success case
          logger.d('User fetched: $user');
          emit(AccountLoaded(user: user));
        },
      );
    } catch (e) {
      logger.e('Unexpected error: $e');
      emit(AccountFailure());
    }
  }
}
