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
            decoration: BoxDecoration(
                // image: DecorationImage(
                //   // image: AssetImage('assets/madOtp.png'),
                //   fit: BoxFit.cover,
                // ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CircleAvatar(
                  //   backgroundImage: AssetImage('assets/otp.jpg'),
                  //   radius: 130,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SUV',
                        style: TextStyle(
                          // fontFamily: 'dsc',
                          fontSize: 40,
                          //color: Colors.white,

                        ),
                      ),
                      // CircleAvatar(
                      //   // backgroundImage: AssetImage('assets/feminine.png'),
                      //   backgroundColor: Color.fromRGBO(120, 120, 120, 0),
                      // ),
                      Text(
                        'DHA',
                        style: TextStyle(
                          fontFamily: 'dsc',
                          fontSize: 40,
                          //color: Colors.white,

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                  Card(
                    elevation: 2.0,
                    color: Color(0xfff3f6f3),
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.0,),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              icon: Text(
                                "+91",
                                style: TextStyle(
                                  fontSize: 18,
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
                              'A 6-digit OTP will be sent via SMS to verify your mobile number'
                          ),
                        ],

                      ),

                    ),
                  ),
                  SizedBox(height: 40,),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0)),
                    elevation: 0.5,
                    color: Colors.pink[300],
                    child: Text('  Continue  ',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Future(() {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                OtpCodeVerificationScreen(phoneNumber: "+91" +
                                    phoneController.text)));
                      });
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
