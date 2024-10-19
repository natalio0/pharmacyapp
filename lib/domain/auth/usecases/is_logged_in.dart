import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/domain/auth/repository/auth.dart';
import 'package:pharmacyapp/service_locator.dart';

class IsLoggedInUseCase implements UseCase<bool, dynamic> {
  @override
  Future<bool> call({params}) async {
    return await sl<AuthRepository>().isLoggedIn();
  }
}
