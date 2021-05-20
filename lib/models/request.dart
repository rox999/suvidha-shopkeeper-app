class Request{

  String uid;
  Map<String,int> items;
  String requestTime;
  String acceptTime;
  int expectedTime; // in minute
  int totalPrice;
  String customerName;
  String customerAddress;
  String status;
  String error;
  /*
    STATUS_PENDING
    STATUS_ACCEPTED
    STATUS_COMPLETED
    STATUS_REJECTED
   */

  Request({
    this.uid,
    this.items,
    this.requestTime,
    this.acceptTime,
    this.expectedTime,
    this.totalPrice,
    this.customerName,
    this.customerAddress,
    this.status,
    this.error
  });
}