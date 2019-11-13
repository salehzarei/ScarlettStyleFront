import 'package:flutter/material.dart';
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
  TextEditingController _customerPhoneNumber = TextEditingController();

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
      width: 40,
      child: Text(
        title,
        style: fildTitle.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  _onStepContinue(index, MainModel model) async {
//// اگر در مرحله اول بود دستورات زیر رو انجام بده
    if (index == 0) {
      if (_customerPhoneNumber.text != null)  {
        print("number is" + _customerPhoneNumber.text);
        
      bool result =  await chekCustomerNumber(model, _customerPhoneNumber.text);
       print(result);
        setState(() {
          _stepindex = 1;
        });
      }
      setState(() {
        _indexState = 1;
        _nextvisible = false;
      });
    }
  }

  Widget _nextBTNWidget(int indexState) {
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

  chekCustomerNumber(MainModel model, String phoneNumber)  {
//بررسی کردن شماره موبایل مشتری
bool findedNumber = false ;
    model.customers.forEach((c) {
      if (phoneNumber == c.customerPhone)
        findedNumber = true;
    });
    return findedNumber;
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
                                  child: const Text('برگشت'),
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
        title: Text('بررسی اطلاعات مشتری',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        isActive: _stepindex == 0 ? true : false,
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
        isActive: _stepindex == 0 ? true : false,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            Icons.phone_android,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          fildTitles('موبایل'),
                          divider(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: TextFormField(
                              style: fildInputText,
                              // focusNode: _productNameFocus,
                              decoration: fildInputForm,
                              maxLength: 28,
                              // controller: _productName,
                              // onFieldSubmitted: (f) {
                              //   FocusScope.of(context)
                              //       .requestFocus(_productBuyPriceFocus);
                              // },
                              keyboardType: TextInputType.text,
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
                            Icons.face,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          fildTitles('نام'),
                          divider(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: TextFormField(
                              style: fildInputText,
                              // focusNode: _productNameFocus,
                              decoration: fildInputForm,
                              maxLength: 28,
                              // controller: _productName,
                              // onFieldSubmitted: (f) {
                              //   FocusScope.of(context)
                              //       .requestFocus(_productBuyPriceFocus);
                              // },
                              keyboardType: TextInputType.text,
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
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: TextFormField(
                              style: fildInputText,
                              // focusNode: _productNameFocus,
                              decoration: fildInputForm,
                              maxLength: 28,
                              // controller: _productName,
                              // onFieldSubmitted: (f) {
                              //   FocusScope.of(context)
                              //       .requestFocus(_productBuyPriceFocus);
                              // },
                              keyboardType: TextInputType.text,
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
                            Icons.euro_symbol,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          fildTitles('سابقه'),
                          divider(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: TextFormField(
                              style: fildInputText,
                              // focusNode: _productNameFocus,
                              decoration: fildInputForm,
                              maxLength: 28,
                              // controller: _productName,
                              // onFieldSubmitted: (f) {
                              //   FocusScope.of(context)
                              //       .requestFocus(_productBuyPriceFocus);
                              // },
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        state: _stepindex <= 1 ? StepState.indexed : StepState.complete);
  }

  step3() {
    return Step(
        title: Text('ثبت محصول',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        isActive: _stepindex == 0 ? true : false,
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

  step4() {
    return Step(
        title: Text('پرداخت و تسویه حساب',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        isActive: _stepindex == 0 ? true : false,
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
}
