import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/activity.dart';
import 'package:smart_kishan/screens/daily_activity/widgets/buy_form.dart';
import 'package:smart_kishan/screens/daily_activity/widgets/other_form.dart';
import 'package:smart_kishan/screens/daily_activity/widgets/sell_form.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';

class AddDailyActivityScreen extends StatefulWidget {
  const AddDailyActivityScreen({super.key});
  @override
  State<AddDailyActivityScreen> createState() => _AddDailyActivityScreenState();
}

class _AddDailyActivityScreenState extends State<AddDailyActivityScreen> {
  String _selectedOption = 'Buy';

  final _activityTitleController = TextEditingController();
  final _activityDescriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _costPriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Activity selectedActivity = Activity();

  @override
  void initState() {
    if (dailyActivityController.isEdit.value) {
      setState(() {
        selectedActivity = dailyActivityController.selectedActivity.value;
      });
      _activityTitleController.text = selectedActivity.title!;
      _activityDescriptionController.text = selectedActivity.description!;
      _selectedOption =
          selectedActivity.type != null ? selectedActivity.type! : 'Buy';
      _quantityController.text = selectedActivity.quantity != null
          ? selectedActivity.quantity!.toString()
          : '';
      _costPriceController.text = selectedActivity.expense != null
          ? selectedActivity.expense.toString()
          : '';
      _sellingPriceController.text = selectedActivity.income != null
          ? selectedActivity.income.toString()
          : '';
    }
    super.initState();
  }

  Widget _buildActivityTypeCard(String value, String label, IconData icon) {
    final isSelected = _selectedOption == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedOption = value;
            _quantityController.clear();
            _costPriceController.clear();
            _sellingPriceController.clear();
          });
          dailyActivityController.selectedProductId('');
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(12),
          ),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? kPrimaryColor : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: getProportionateScreenWidth(24),
              ),
              SizedBox(height: getProportionateScreenWidth(6)),
              Text(
                label,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(12),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: getProportionateScreenWidth(8)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: getProportionateScreenWidth(14),
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          dailyActivityController.isEdit.value
              ? 'दैनिक गतिविधि अपडेट गर्नुहोस्'
              : 'दैनिक गतिविधि थप्नुहोस्',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            // Decorative header curve
            Container(
              height: getProportionateScreenWidth(30),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(getProportionateScreenWidth(30)),
                  bottomRight: Radius.circular(getProportionateScreenWidth(30)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Activity Title Card
                    Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    getProportionateScreenWidth(8)),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.title,
                                  color: kPrimaryColor,
                                  size: getProportionateScreenWidth(20),
                                ),
                              ),
                              SizedBox(width: getProportionateScreenWidth(10)),
                              _buildSectionLabel('गतिविधिको शीर्षक'),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenWidth(10)),
                          InputTextField(
                            textEditingController: _activityTitleController,
                            title: 'गतिविधिको शीर्षक प्रविष्टि गर्नुहोस्',
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'कृपया आफ्नो गतिविधिको शीर्षक प्रविष्टि गर्नुहोस्';
                              }
                              if (value.length < 3) {
                                return 'गतिविधिको शीर्षक कम्तिमा पनि ३ अक्षरको हुनुपर्छ';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: getProportionateScreenWidth(16)),

                    // Activity Description Card
                    Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    getProportionateScreenWidth(8)),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.description,
                                  color: kPrimaryColor,
                                  size: getProportionateScreenWidth(20),
                                ),
                              ),
                              SizedBox(width: getProportionateScreenWidth(10)),
                              _buildSectionLabel('दैनिक गतिविधिको विवरण'),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenWidth(10)),
                          InputTextField(
                            textEditingController:
                                _activityDescriptionController,
                            title: 'दैनिक गतिविधि विवरण प्रविष्टि गर्नुहोस्',
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: getProportionateScreenWidth(16)),

                    // Activity Type Card
                    Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    getProportionateScreenWidth(8)),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.category,
                                  color: kPrimaryColor,
                                  size: getProportionateScreenWidth(20),
                                ),
                              ),
                              SizedBox(width: getProportionateScreenWidth(10)),
                              _buildSectionLabel('गतिविधिको प्रकार'),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenWidth(12)),
                          Row(
                            children: [
                              _buildActivityTypeCard(
                                  'Buy', 'खरिद', Icons.shopping_cart),
                              SizedBox(width: getProportionateScreenWidth(10)),
                              _buildActivityTypeCard(
                                  'Sell', 'बिक्री', Icons.sell),
                              SizedBox(width: getProportionateScreenWidth(10)),
                              _buildActivityTypeCard(
                                  'Other', 'अन्य', Icons.more_horiz),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: getProportionateScreenWidth(16)),

                    // Dynamic Form Content
                    Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _selectedOption == 'Buy'
                          ? BuyForm(
                              quantityController: _quantityController,
                              costPriceController: _costPriceController)
                          : _selectedOption == 'Sell'
                              ? SellForm(
                                  quantityController: _quantityController,
                                  sellPriceController: _sellingPriceController)
                              : OtherForm(
                                  costPriceController: _costPriceController,
                                  sellingPriceController:
                                      _sellingPriceController,
                                ),
                    ),

                    SizedBox(height: getProportionateScreenWidth(24)),

                    // Submit Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            kPrimaryColor,
                            kPrimaryColor.withOpacity(0.8)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: Size(
                            double.infinity,
                            getProportionateScreenWidth(50),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              dailyActivityController.isEdit.value
                                  ? Icons.update
                                  : Icons.add_circle_outline,
                              size: getProportionateScreenWidth(20),
                            ),
                            SizedBox(width: getProportionateScreenWidth(8)),
                            Text(
                              dailyActivityController.isEdit.value
                                  ? 'अपडेट गर्नुहोस्'
                                  : 'थप्नुहोस्',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(16),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (dailyActivityController.isEdit.value) {
                              dailyActivityController.updateActivity(Activity(
                                id: selectedActivity.id!,
                                title: _activityTitleController.text,
                                description:
                                    _activityDescriptionController.text,
                                type: _selectedOption,
                                productId: int.tryParse(dailyActivityController
                                    .selectedProductId.value),
                                expense:
                                    double.tryParse(_costPriceController.text),
                                income: double.tryParse(
                                    _sellingPriceController.text),
                                quantity:
                                    int.tryParse(_quantityController.text),
                                userId: 1,
                                date: DateTime.now().toString(),
                              ));
                            } else {
                              dailyActivityController.addActivity(Activity(
                                title: _activityTitleController.text,
                                description:
                                    _activityDescriptionController.text,
                                type: _selectedOption,
                                productId: int.tryParse(dailyActivityController
                                    .selectedProductId.value),
                                expense:
                                    double.tryParse(_costPriceController.text),
                                income: double.tryParse(
                                    _sellingPriceController.text),
                                quantity:
                                    int.tryParse(_quantityController.text),
                                userId: 1,
                                date: DateTime.now().toString(),
                              ));
                            }
                          }
                        },
                      ),
                    ),

                    SizedBox(height: getProportionateScreenWidth(20)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
