import 'CartItem.dart';
import 'Addresses.dart';

class CheckoutViewModel {
  final List<CartItem> cartItems;
  final List<Addresses> addresses;
  final String selectedAddressId;

  CheckoutViewModel({
    required this.cartItems,
    required this.addresses,
    required this.selectedAddressId,
  });

  factory CheckoutViewModel.fromFirestore(Map<String, dynamic> data) {
    return CheckoutViewModel(
      cartItems: (data['cartItems'] as List)
          .map((item) => CartItem.fromFirestore(item))
          .toList(),
      addresses: (data['addresses'] as List)
          .map((item) => Addresses.fromFirestore(item))
          .toList(),
      selectedAddressId: data['selectedAddressId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'addresses': addresses.map((item) => item.toMap()).toList(),
      'selectedAddressId': selectedAddressId,
    };
  }
}
