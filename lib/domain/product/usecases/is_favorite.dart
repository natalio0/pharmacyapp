import 'package:pharmacyapp/core/usecase/usecase.dart';
import 'package:pharmacyapp/domain/product/repository/product.dart';
import 'package:pharmacyapp/service_locator.dart';

class IsFavoriteUseCase implements UseCase<bool, String> {
  @override
  Future<bool> call({String? params}) async {
    return await sl<ProductRepository>().isFavorite(params!);
  }
}
