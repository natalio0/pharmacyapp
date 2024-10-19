import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacyapp/domain/product/usecases/get_top_selling.dart';
import 'package:pharmacyapp/presentation/home/bloc/top_selling_display_state.dart';
import 'package:pharmacyapp/service_locator.dart';

class TopSellingDisplayCubit extends Cubit<TopSellingDisplayState> {
  TopSellingDisplayCubit() : super(ProductLoading());

  void displayProduct() async {
    var returnData = await sl<GetTopSellingUseCase>().call();
    returnData.fold((error) {
      emit(LoadProductFailure());
    }, (data) {
      emit(ProductLoaded(products: data));
    });
  }
}
