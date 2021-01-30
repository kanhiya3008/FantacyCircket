import 'package:cloud_functions/cloud_functions.dart';
import 'package:uuid/uuid.dart';

const String payment = "Payment";
const String webStaging = "WEBSTAGING";
const String currency = "INR";
const mid = "lUvMfI35194252768557";
const String custId = "cust01";
const String callBackUrl =
    "https://securegw-stage.paytm.in/theia/paytmCallback";
var uuid = Uuid();
var orderID = uuid.v1();
final HttpsCallable callable = CloudFunctions.instance
    .getHttpsCallable(functionName: 'payment')
      ..timeout = const Duration(seconds: 30);
