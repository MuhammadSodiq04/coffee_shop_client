class OrderModel {
  int count;
  int totalPrice;
  String orderId;
  String productId;
  String userId;
  String orderStatus;
  String createdAt;
  String productName;
  String userName;
  String userPhone;
  String userAddress;

  OrderModel({
    required this.count,
    required this.totalPrice,
    required this.orderId,
    required this.productId,
    required this.userId,
    required this.orderStatus,
    required this.createdAt,
    required this.productName,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
  });

  OrderModel copWith({
    int? count,
    int? totalPrice,
    String? orderId,
    String? productId,
    String? userId,
    String? orderStatus,
    String? createdAt,
    String? productName,
    String? userName,
    String? userPhone,
    String? userAddress,
  }) =>
      OrderModel(
        count: count ?? this.count,
        totalPrice: totalPrice ?? this.totalPrice,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        userId: userId ?? this.userId,
        orderStatus: orderStatus ?? this.orderStatus,
        createdAt: createdAt ?? this.createdAt,
        userName: userName ?? this.userName,
        userPhone: userPhone ?? this.userPhone,
        userAddress: userAddress ?? this.userAddress,
      );

  factory OrderModel.fromJson(Map<String, dynamic> jsonData) {
    return OrderModel(
      count: jsonData['count'] as int? ?? 0,
      totalPrice: jsonData['totalPrice'] as int? ?? 0,
      orderId: jsonData['orderId'] as String? ?? '',
      productName: jsonData['productName'] as String? ?? '',
      productId: jsonData['productId'] as String? ?? '',
      userId: jsonData['userId'] as String? ?? '',
      orderStatus: jsonData['orderStatus'] as String? ?? '',
      createdAt: jsonData['createdAt'] as String? ?? '',
      userName: jsonData['userName'] as String? ?? '',
      userPhone: jsonData['userPhone'] as String? ?? '',
      userAddress: jsonData['userAddress'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'totalPrice': totalPrice,
      'orderId': orderId,
      'productId': productId,
      'userId': userId,
      'orderStatus': orderStatus,
      'createdAt': createdAt,
      'productName': productName,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
    };
  }

  @override
  String toString() {
    return '''
      count: $count,
      totalPrice: $totalPrice,
      orderId: $orderId,
      productId: $productId,
      userId: $userId,
      orderStatus: $orderStatus,
      createdAt: $createdAt,
      productName: $productName,
      userName: $userName,
      userPhone: $userPhone,
      userAddress: $userAddress,
      ''';
  }
}
