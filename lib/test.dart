import 'dart:async';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/paytm.dart';

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  String _response = 'no response';
  int _responseCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    mm();
    super.initState();
  }

  Future<void> mm() async {
    //await Firebase.initializeApp();
  }

  final int orderId = 9999;
  final int amt = 10;
  final String custId = 'cust01';
  final String mid = "lUvMfI35194252768557";
  final String callBackURL =
      "https://securegw-stage.paytm.in/theia/paytmCallback";

  @override
  Widget build(BuildContext context) {
    final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'payment')
          ..timeout = const Duration(seconds: 30);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Functions example app'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
          child: Column(
            children: <Widget>[
              Text('Response $_responseCount: $_response'),
              MaterialButton(
                child: const Text('SEND REQUEST'),
                onPressed: () async {
                  try {
                    final HttpsCallableResult result = await callable.call(
                      <String, dynamic>{
                        'orderId': orderId.toString(),
                        'amt': amt.toString(),
                        'custId': custId
                      },
                    );
                    print('result');
                    print(result.data);
                    print(result.data['checksum']);

                    var body = {
                      "requestType": "Payment",
                      "mid": mid,
                      "websiteName": "WEBSTAGING",
                      "orderId": orderId.toString(),
                      "callbackUrl": callBackURL,
                      "txnAmount": {
                        "value": amt.toString(),
                        "currency": "INR",
                      },
                      "userInfo": {
                        "custId": custId,
                      }
                    };
                    print(body);
                    var head = {"signature": result.data['checksum']};
                    print(head);

                    var post_data = {"body": body, "head": head};

                    print(post_data.toString());

                    var pp = jsonEncode(post_data);
                    var url =
                        'https://securegw-stage.paytm.in/theia/api/v1/initiateTransaction?mid=lUvMfI35194252768557&orderId=' +
                            orderId.toString();
                    var response = await http.post(
                      url,
                      body: pp,
                      headers: {
                        'Content-Type': 'application/json',
                        'Content-Length': pp.length.toString()
                      },
                    );
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');

                    bool isValidToken = false;
                    String tokenString = '';
                    final tokenResponse = jsonDecode(response.body);
                    if (tokenResponse['body']['resultInfo']['resultStatus'] ==
                        'S') {
                      tokenString = tokenResponse['body']['txnToken'];
                      isValidToken = true;
                      print("token details");
                      print(isValidToken);
                      print(tokenString);

                      var paytmResponse = Paytm.payWithPaytm(
                          mid,
                          orderId.toString(),
                          tokenString,
                          amt.toString(),
                          callBackURL + "?ORDER_ID=" + orderId.toString(),
                          true);

                      paytmResponse.then((value) {
                        print(value);
//                          setState(() {
//                            loading = false;
//                            payment_response = value.toString();
//                          });
                      });
                    }

//                    print('Response body: ${tokenResponse['body']['resultInfo']}');

//                    print(await http.read('https://example.com/foobar.txt'));
                  } on CloudFunctionsException catch (e) {
                    print('caught firebase functions exception');
                    print(e.code);
                    print(e.message);
                    print(e.details);
                  } catch (e) {
                    print('caught generic exception');
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
//    Widget build(BuildContext context) {
//      final HttpsCallable callable = CloudFunctions.instance
//          .getHttpsCallable(functionName: 'paytm_checksum1')
//        ..timeout = const Duration(seconds: 30);
//      return  Scaffold(
//          appBar: AppBar(
//            title: const Text('Cloud Functions example app'),
//          ),
//          body: Center(
//            child: Container(
//              margin: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
//              child: Column(
//                children: <Widget>[
//                  Text('Response $_responseCount: $_response'),
//                  MaterialButton(
//                    child: const Text('SEND REQUEST'),
//                    onPressed: () async {
//                      try {
//
//                        final HttpsCallableResult result = await callable.call(
//                          <String, dynamic>{
//                            'message': 'hello world!',
//                            'count': _responseCount,
//                          },
//                        );
//                        print('result');
//                        print(result.data);
//                        print(result.data['message']);
////                        setState(() {
////                          _response = result.data['repeat_message'];
////                          _responseCount = result.data['repeat_count'];
////                        });
//                      } on CloudFunctionsException catch (e) {
//                        print('caught firebase functions exception');
//                        print(e.code);
//                        print(e.message);
//                        print(e.details);
//                      } catch (e) {
//                        print('caught generic exception');
//                        print(e);
//                      }
//                    },
//                  ),
//                ],
//              ),
//            ),
//          ),
//        );
//
//    }
}
