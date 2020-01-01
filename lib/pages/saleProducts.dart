import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scarlettstayle/functions/addToCart.dart';
import 'package:scarlettstayle/models/customermodel.dart';
import 'package:scarlettstayle/scoped/mainscoped.dart';
import 'package:scarlettstayle/theme/textStyle.dart';
import 'package:scarlettstayle/utils/menu.dart';
import 'package:scoped_model/scoped_model.dart';

class SaleProducts extends StatefulWidget {
  SaleProducts({Key key}) : super(key: key);

  @override
  _SaleProductsState createState() => _SaleProductsState();
}

class _SaleProductsState extends State<SaleProducts> {
  int _stepindex = 0;
  int _indexState = 0;
  bool _backvisible = false;
  bool _nextvisible = false;
  bool userStatus;
  TextEditingController _customerPhoneNumber = TextEditingController();
  TextEditingController _customerName = TextEditingController();
  TextEditingController _customerAddress = TextEditingController();
  FocusNode _addressFocus = FocusNode();

  Widget divider() {
    return Container(
      color: Colors.grey.shade500,
      width: 2,
      height: 25,
      margin: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  Widget fildTitles(String title) {
    return SizedBox(
      width: 35,
      child: Text(
        title,
        style: fildTitle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  _onStepContinue(index, MainModel model) {
    switch (index) {

      /// اگر در مرحله دوم بود
      case 0:
        {
          if (_customerPhoneNumber.text != null) {
            CustomerModel result =
                chekCustomerNumber(model, _customerPhoneNumber.text);
//اگر مشتری وجود داشت و بدهی نداشت اجازه ادامه بده
            if (result != null && result.customerState == 'true') {
              setState(() {
                _customerName.text = result.customerName;

                _customerAddress.text = result.customerAddress;
                userStatus = true;
                _nextvisible = true;
              });
              // اگر مشتری وجود داشت و بدهکار بود اجازه ادامه نده
            } else if (result != null && result.customerState == 'false') {
              setState(() {
                _customerName.text = result.customerName;

                _customerAddress.text = result.customerAddress;
                userStatus = false;
                _nextvisible = false;
              });
            } else
              setState(() {
                _nextvisible = false;
                userStatus = null;
              });

            setState(() {
              _stepindex = 1;
              FocusScope.of(context).unfocus();
            });
          }
          setState(() {
            _indexState = 1;
            _backvisible = true;
          });
        }

        break;

      case 1:

        /// اگر در مرحله سوم بود
        {
          print("Step 2");
          setState(() {
            _stepindex = 2;
            _indexState = 2;
            _backvisible = true;
          });
        }
        break;
      case 2:
        {
          print("Step 3");
          setState(() {
            _stepindex = 3;
            _indexState = 3;
            _backvisible = true;
          });
        }
        break;
    }
  }

  chekCustomerNumber(MainModel model, String phoneNumber) {
    CustomerModel _customer;
//بررسی کردن شماره موبایل مشتری
    model.customers.forEach((c) {
      if (phoneNumber == c.customerPhone) {
        _customer = c;
      }
    });
    return _customer;
  }

  _onStepCancel(index) {
    switch (index) {
      case 1:
        {
          setState(() {
            _stepindex = 0;
            _backvisible = false;
            _nextvisible = true;
            _indexState = 0;
            _customerName.clear();
            _customerAddress.clear();
          });
        }
        break;
      case 2:
        {
          setState(() {
            _stepindex = 1;
            _backvisible = true;
            _nextvisible = true;
            _indexState = 1;
          });
        }
        break;
      case 3:
        {
          setState(() {
            _stepindex = 2;
            _backvisible = true;
            _nextvisible = true;
            _indexState = 2;
          });
        }
        break;
    }
  }

  _nextBTNWidget(int indexState) {
    switch (indexState) {
      case 0:
        {
          return Text('بررسی شماره');
        }
        break;

      case 1:
        {
          return Text('ادامه خرید');
        }
        break;
      case 2:
        {
          return Text('ثبت کلیه اطلاعات');
        }
        break;

      case 3:
        {
          return SizedBox(
            height: 15,
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
        break;
    }
  }

  @override
  void initState() {
    MainModel model = ScopedModel.of(context);
    super.initState();
    model.fetchCustomer();
    model.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: ScopedModelDescendant<MainModel>(
          builder: (context, child, model) {
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                iconTheme: IconThemeData(color: Colors.purple),
                centerTitle: true,
                title: Text(
                  'فروش مصحول به مشتری',
                  style: titleStyle,
                ),
              ),
              drawer: Menu(),
              body: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.topCenter,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          primaryColor: Colors.pink,
                          buttonColor: Colors.pinkAccent),
                      child: Stepper(
                        currentStep: _stepindex,
                        onStepContinue: () =>
                            _onStepContinue(_stepindex, model),
                        onStepCancel: () => _onStepCancel(_stepindex),
                        controlsBuilder: (
                          BuildContext context, {
                          VoidCallback onStepContinue,
                          VoidCallback onStepCancel,
                        }) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Visibility(
                                visible: _backvisible,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onPressed: _backvisible ? onStepCancel : null,
                                  child: Text('برگشت'),
                                ),
                              ),
                              RaisedButton(
                                onPressed: _nextvisible ? onStepContinue : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: _nextBTNWidget(_indexState),
                              ),
                            ],
                          );
                        },
                        steps: [step1(), step2(), step3(), step4()],
                      ),
                    ),
                  )),
            );
          },
        ));
  }

  step1() {
    return Step(
        title: Text('بررسی شماره مشتری',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        isActive: _stepindex == 0 ? true : false,
        subtitle: Text(
          'شماره موبایل ${_customerPhoneNumber.text}',
          style: TextStyle(fontSize: 16),
        ),
        content: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: TextFormField(
            style: fildInputText,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.phone),
              counterText: '',
              hintText: 'شماره موبایل مشتری',
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            maxLength: 11,
            controller: _customerPhoneNumber,
            keyboardType: TextInputType.phone,
            onChanged: (number) {
              if (number.length == 11)
                setState(() {
                  _nextvisible = true;
                });
              else
                setState(() {
                  _nextvisible = false;
                });
            },
          ),
        ),
        state: _stepindex <= 0 ? StepState.indexed : StepState.complete);
  }

  step2() {
    return Step(
        title: Text('مشخصات مشتری',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        isActive: _stepindex == 1 ? true : false,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: userStatus != null
              ? MediaQuery.of(context).size.height * 0.25
              : MediaQuery.of(context).size.height * 0.20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.face,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          fildTitles('نــــام'),
                          divider(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: TextFormField(
                              style: fildInputText.copyWith(fontSize: 18),
                              readOnly: userStatus != null,
                              // focusNode: _productNameFocus,
                              decoration: fildInputForm,
                              maxLength: 28,
                              controller: _customerName,
                              onFieldSubmitted: (f) {
                                FocusScope.of(context)
                                    .requestFocus(_addressFocus);
                              },
                              keyboardType: TextInputType.text,
                              onChanged: (g) {
                                if (_customerAddress.text != '' && g.length > 5)
                                  setState(() {
                                    _nextvisible = true;
                                  });
                                else
                                  setState(() {
                                    _nextvisible = false;
                                  });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          fildTitles('آدرس'),
                          divider(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.44,
                            child: TextFormField(
                              style: fildInputText.copyWith(fontSize: 18),
                              readOnly: userStatus != null,
                              focusNode: _addressFocus,
                              decoration: fildInputForm,
                              maxLength: 28,
                              controller: _customerAddress,
                              keyboardType: TextInputType.text,
                              onChanged: (g) {
                                if (_customerName.text != '' && g.length > 2)
                                  setState(() {
                                    _nextvisible = true;
                                  });
                                else
                                  setState(() {
                                    _nextvisible = false;
                                  });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              userStatus != null
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: userStatus
                                  ? Colors.green.shade400
                                  : Colors.red.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                userStatus
                                    ? Icon(
                                        Icons.sentiment_very_satisfied,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.sentiment_very_dissatisfied,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                SizedBox(
                                  width: 5,
                                ),
                                userStatus
                                    ? Text('خدارو شکر بدهکاری ندارند ایشون',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))
                                    : Text('عی بابا ! بدهی قبلی دارند ایشون',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
        state: _stepindex <= 1 ? StepState.indexed : StepState.complete);
  }

  step3() {
    return Step(
        title: Text('ثبت محصول',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        isActive: _stepindex == 2 ? true : false,
        content: AddToCart(),

        // Container(
        //     decoration: BoxDecoration(
        //       color: Colors.grey.shade100,
        //       borderRadius: BorderRadius.circular(15),
        //     ),
        //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        //     ),
        state: _stepindex <= 2 ? StepState.indexed : StepState.complete);
  }

  step4() {
    return Step(
        title: Text('پرداخت و تسویه حساب',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        isActive: _stepindex == 3 ? true : false,
        content: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: TextFormField(
            style: fildInputText,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.phone),
              counterText: '',
              hintText: 'شماره موبایل مشتری',
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            maxLength: 11,
            controller: _customerPhoneNumber,
            keyboardType: TextInputType.phone,
            onChanged: (number) {
              if (number.length == 11)
                setState(() {
                  _nextvisible = true;
                });
              else
                setState(() {
                  _nextvisible = false;
                });
            },
          ),
        ),
        state: _stepindex <= 3 ? StepState.indexed : StepState.complete);
  }
}
