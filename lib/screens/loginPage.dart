import 'package:flutter/material.dart';
import 'package:suvidha_shopkeeper/screens/otpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(25.0),
            decoration: BoxDecoration(),
          ),
          Container(
            color: Colors.white54,
            child: Center(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SUVIDHA',
                      style: TextStyle(
                        fontFamily: 'ReggaeOne',
                        fontSize: 45,
                        //color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'SHOPKEEPER',
                      style: TextStyle(
                        fontFamily: 'ReggaeOne',
                        fontSize: 25,
                        //color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Card(
                      color: Colors.tealAccent[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      elevation: 8.0,
                      //color: Color(0xfff3f6f3),
                      margin: EdgeInsets.all(25.0),
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Your Phone!',
                                // textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "BreeSerif",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Your Number',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "BreeSerif",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 22,
                                letterSpacing: 3.0,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                icon: Text(
                                  "+91",
                                  style: TextStyle(
                                    letterSpacing: 4.0,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // enabledBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(25.0),
                                //   borderSide: BorderSide(color: Color.fromRGBO(129,199,169, 0.7), width: 2.0),
                                // ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                'A 6-digit OTP will be sent via SMS to verify your mobile number'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    MaterialButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      elevation: 8.0,
                      color: Colors.tealAccent[100],
                      child: Text(
                        '  Continue  ',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Future(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OtpCodeVerificationScreen(
                                          phoneNumber:
                                              "+91" + phoneController.text)));
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
