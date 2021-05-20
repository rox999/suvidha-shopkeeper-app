import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:suvidha_shopkeeper/database/shopkeeper_database.dart';
import 'package:suvidha_shopkeeper/shared/loading.dart';

class OtpCodeVerificationScreen extends StatefulWidget {

  String phoneNumber;
  OtpCodeVerificationScreen({this.phoneNumber});

  @override
  _OtpCodeVerificationScreenState createState() =>
      _OtpCodeVerificationScreenState();
}

class _OtpCodeVerificationScreenState extends State<OtpCodeVerificationScreen> {


  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController smsCodeController = TextEditingController();
  bool isLoading = true;
  String verificationId;
  int count = 60;
  Timer timer;
  String uid;

  @override
  void dispose() {
    // TODO: implement dispose
    if(timer.isActive)
      timer.cancel();
    super.dispose();
  }

  void startTimer(){
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (count == 0) {
          setState(() {
            Navigator.pop(context);
          });
        } else {
          setState(() {
            count--;
          });
        }
      },
    );
  }



  Future signIn(String phone)async{
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential)async{
          final result = await _firebaseAuth.signInWithCredential(authCredential);
          setState(() {
            uid = result.user.uid;
          });
          ShopkeeperDatabase(uid: uid).shopkeeper;
          // Fluttertoast.showToast(msg: "Successfully sign in");
          Navigator.pop(context);
        },
        verificationFailed: (e){
          // Fluttertoast.showToast(msg: e.message);
          Navigator.pop(context);
        },
        codeSent: (String verificationId, [int forceResendingToken])async{
          setState(() {
            isLoading = !isLoading;
          });
          startTimer();
          print("code sent");
          // Fluttertoast.showToast(msg: "Code Sent");
          setState(() {
            this.verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (v){
          print(v);
        });
  }

  void doSignIn(){
    signIn(widget.phoneNumber);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) { });
    doSignIn();
  }



  @override
  Widget build(BuildContext context) {
    return isLoading==false?Scaffold(
      body: Stack(
        children: [
          // Container(
          //   padding: EdgeInsets.all(25.0),
          //   decoration: BoxDecoration(
          //       image: DecorationImage(
          //         image: AssetImage('assets/madOtp.png'),
          //         fit: BoxFit.cover,
          //       )),
          // ),
          Center(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SUV',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          // fontFamily:'dsc',
                          //color: Colors.white,

                        ),
                      ),
                      CircleAvatar(
                        // backgroundImage: AssetImage('assets/feminine.png'),
                        backgroundColor: Color.fromRGBO(120, 120, 120, 0),
                      ),
                      Text(
                        'DHA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            // fontFamily:'dsc'
                          //color: Colors.white,

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                  Card(
                    margin: EdgeInsets.all(15.0),
                    elevation: 10.0,
                    child: Column(

                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0, bottom: 40.0, left: 20.0,),
                            child: Text(
                              'OTP Verification',
                              style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 8),
                            child: RichText(
                              maxLines: 2,
                              text: TextSpan(
                                  text: "Enter the OTP you received to ",
                                  children: [
                                    TextSpan(
                                        text: widget.phoneNumber,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ],
                                  style:
                                  TextStyle(color: Colors.black54, fontSize: 15)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: PinCodeTextField(
                            controller: smsCodeController,
                            appContext: context,
                            pastedTextStyle: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 6,
                            animationType: AnimationType.slide,
                            validator: (v) {
                              if (v.length < 6) {
                                return "Enter valid otp";
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                              inactiveFillColor: Colors.white,
                              inactiveColor: Colors.teal,
                              shape: PinCodeFieldShape.underline,
                              // borderRadius: BorderRadius.circular(5),
                              fieldHeight: 40,
                              fieldWidth: 30,
                              activeFillColor: Colors.teal,
                            ),
                            cursorColor: Colors.black,
                            animationDuration: Duration(milliseconds: 300),
                            keyboardType: TextInputType.number,
                            onCompleted: (v) async{
                              try{
                                final result = await _firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: v));
                                setState(() {
                                  uid = result.user.uid;
                                });
                                // UserDatabase(uid: uid).user;
                                ShopkeeperDatabase(uid: uid).shopkeeper;
                                Navigator.pop(context);
                              }catch(e){
                                print(e);
                              }
                            },
                            beforeTextPaste: (text) {
                              return false;
                            },
                            autoDismissKeyboard: true,
                            onChanged: (String value) {},
                          ),
                        ),

                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 20,),
                            child: RichText(
                              maxLines: 2,
                              text: TextSpan(
                                  text: "OTP Valid For  ",
                                  children: [
                                    TextSpan(
                                        text: "${count.toString()} seconds",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ],
                                  style:
                                  TextStyle(color: Colors.black54, fontSize: 15)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  )
                  ,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "RESEND",
                            style: TextStyle(
                                color: Color(0xFF91D3B3),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ))
                    ],
                  ),

                  SizedBox(height: 20)
                ],
              ),
            ),
          )
        ],
      ),
    ):Loading();
  }
}
