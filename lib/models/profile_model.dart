class Profile {
  final int id;
  final int distributorId;
  final String mobile;
  final String email;
  final String firstName;
  final String lastName;
  final List<Address> addressList;

  Profile({
    required this.id,
    required this.distributorId,
    required this.mobile,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.addressList,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    List<dynamic> addressData = json['addressList'];
    List<Address> addresses = addressData
        .map((data) => Address.fromJson(data as Map<String, dynamic>))
        .toList();

    return Profile(
      id: json['id'] ?? 0,
      distributorId: json['distributor_id'] ?? 0,
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      addressList: addresses,
    );
  }
}

class Address {
  final int id;
  final int customerId;
  final String line1;
  final String line2;
  final String line3;
  final String pinCode;
  final String stateName;
  final String country;
  final String city;
  final bool isDefault;

  Address({
    required this.id,
    required this.customerId,
    required this.line1,
    required this.line2,
    required this.line3,
    required this.pinCode,
    required this.stateName,
    required this.country,
    required this.city,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      line1: json['line1'] ?? '',
      line2: json['line2'] ?? '',
      line3: json['line3'] ?? '',
      pinCode: json['pin_code'] ?? '',
      stateName: json['state_name'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }
}
