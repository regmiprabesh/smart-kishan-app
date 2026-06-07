import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/farmland.dart';
import 'package:smart_kishan/models/soildata.dart';
import 'package:smart_kishan/screens/farmland/widgets/image_widget.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/widgets/input_text_field.dart';

class AddFarmlandScreen extends StatefulWidget {
  const AddFarmlandScreen({super.key});
  @override
  State<AddFarmlandScreen> createState() => _AddFarmlandScreenState();
}

class _AddFarmlandScreenState extends State<AddFarmlandScreen> {
  final _farmlandTitleController = TextEditingController();
  final _farmlandDescriptionController = TextEditingController();
  final _farmlandLatController = TextEditingController();
  final _farmlandLngController = TextEditingController();
  final _farmlandSoilNController = TextEditingController();
  final _farmlandSoilPController = TextEditingController();
  final _farmlandSoilKController = TextEditingController();
  final _farmlandSoilPHController = TextEditingController();
  final _farmlandTempController = TextEditingController();
  final _farmlandHumidityController = TextEditingController();
  final _farmlandRainfallController = TextEditingController();
  final _farmlandSoilOrganicController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Farmland selectedFarmland = Farmland();

  Color getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.hovered,
      WidgetState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return kSecondaryColor;
    }
    return kPrimaryColor;
  }

  @override
  void initState() {
    if (farmlandController.isEdit.value) {
      setState(() {
        selectedFarmland = farmlandController.selectedFarmland.value;
      });
      _farmlandTitleController.text = selectedFarmland.title!;
      _farmlandDescriptionController.text = selectedFarmland.description ?? '';
      _farmlandLatController.text =
          selectedFarmland.lat != null ? selectedFarmland.lat.toString() : '';
      _farmlandLngController.text =
          selectedFarmland.lng != null ? selectedFarmland.lng.toString() : '';
      _farmlandSoilNController.text = selectedFarmland.nitrogen != null
          ? selectedFarmland.nitrogen.toString()
          : '';
      _farmlandSoilOrganicController.text =
          selectedFarmland.organicMatter != null
              ? selectedFarmland.organicMatter.toString()
              : '';
      _farmlandSoilPController.text = selectedFarmland.phosphate != null
          ? selectedFarmland.phosphate.toString()
          : '';
      _farmlandSoilKController.text = selectedFarmland.potassium != null
          ? selectedFarmland.potassium.toString()
          : '';
      _farmlandSoilPHController.text =
          selectedFarmland.pH != null ? selectedFarmland.pH.toString() : '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
            farmlandController.isEdit.value
                ? 'खेतबारी अपडेट गर्नुहोस्'
                : 'खेतबारी थप्नुहोस्',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(16)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Basic Information Section
                _buildSectionCard(
                  title: 'आधारभूत जानकारी',
                  icon: Icons.info_outline,
                  children: [
                    _buildLabel('खेतबारीको नाम*'),
                    SizedBox(height: getProportionateScreenWidth(8)),
                    InputTextField(
                      textEditingController: _farmlandTitleController,
                      title: 'खेतबारीको नाम प्रविष्टि गर्नुहोस्',
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'कृपया आफ्नो खेतबारीको नाम प्रविष्टि गर्नुहोस्';
                        }
                        if (value.length < 3) {
                          return "खेतबारीको नाम कम्तिमा पनि ३ अक्षरको हुनुपर्छ";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: getProportionateScreenWidth(16)),
                    _buildLabel('खेतबारीको विवरण'),
                    SizedBox(height: getProportionateScreenWidth(8)),
                    InputTextField(
                      textEditingController: _farmlandDescriptionController,
                      title: 'खेतबारीको विवरण प्रविष्टि गर्नुहोस्',
                      maxLines: 4,
                    ),
                    SizedBox(height: getProportionateScreenWidth(16)),
                    ImageWidget(
                      imageTitle: 'खेतबारीको तस्वीर',
                      placeHolderImage: 'assets/images/farmland.png',
                      onAdd: (String path) {
                        farmlandController.selectedFarmlandImage(path);
                      },
                      error: false,
                      errorText: 'खेतबारीको तस्वीर प्रविष्टि गर्नुहोस्*',
                      networkImagePath:
                          farmlandController.networkFarmlandImage.value,
                    ),
                  ],
                ),

                SizedBox(height: getProportionateScreenWidth(16)),

                // Location Section
                _buildSectionCard(
                  title: 'भौगोलिक स्थान',
                  icon: Icons.location_on_outlined,
                  actionButton: _buildActionButton(
                    label: 'मेरो स्थान प्राप्त गर्नुहोस्',
                    icon: Icons.my_location,
                    onPressed: () async {
                      Map<String, double>? myPosition =
                          await farmlandController.getMyLatLng();
                      if (myPosition != null &&
                          myPosition.containsKey('lat') &&
                          myPosition.containsKey('lng')) {
                        _farmlandLatController.text =
                            myPosition['lat'].toString();
                        _farmlandLngController.text =
                            myPosition['lng'].toString();
                      }
                    },
                  ),
                  children: [
                    _buildLabel('अक्षाश'),
                    SizedBox(height: getProportionateScreenWidth(8)),
                    InputTextField(
                      textEditingController: _farmlandLatController,
                      title: 'खेतबारीको अक्षाश प्रविष्टि गर्नुहोस्',
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(height: getProportionateScreenWidth(16)),
                    _buildLabel('देशान्तर'),
                    SizedBox(height: getProportionateScreenWidth(8)),
                    InputTextField(
                      textEditingController: _farmlandLngController,
                      title: 'खेतबारीको देशान्तर प्रविष्टि गर्नुहोस्',
                      textInputType: TextInputType.text,
                    ),
                  ],
                ),

                SizedBox(height: getProportionateScreenWidth(16)),

                // Soil Properties Section
                _buildSectionCard(
                  title: 'माटोको गुण',
                  icon: Icons.grass_outlined,
                  actionButton: _buildActionButton(
                    label: 'स्वतः प्राप्त गर्नुहोस्',
                    icon: Icons.auto_awesome,
                    onPressed: () async {
                      if (_farmlandLatController.text.isNotEmpty &&
                          _farmlandLngController.text.isNotEmpty) {
                        SoilData? soilData = await farmlandController
                            .getSoilProperty(Coordinates(
                                lat: double.tryParse(
                                    _farmlandLatController.text),
                                lng: double.tryParse(
                                    _farmlandLngController.text)));
                        if (soilData != null) {
                          _farmlandSoilNController.text =
                              soilData.totalNitrogen.toString() != 'null'
                                  ? soilData.totalNitrogen.toString()
                                  : '';
                          _farmlandSoilPHController.text =
                              soilData.ph.toString() != 'null'
                                  ? soilData.ph.toString()
                                  : '';
                          _farmlandSoilPController.text =
                              soilData.p2o5.toString() != 'null'
                                  ? soilData.p2o5.toString()
                                  : '';
                          _farmlandSoilOrganicController.text =
                              soilData.organicMatter.toString() != 'null'
                                  ? soilData.organicMatter.toString()
                                  : '';
                        }
                      }
                    },
                  ),
                  children: [
                    _buildSoilInput(
                      label: 'नाइट्रोजन (%)',
                      controller: _farmlandSoilNController,
                      hint: 'नाइट्रोजनको मात्रा प्रविष्टि गर्नुहोस्',
                    ),
                    _buildSoilInput(
                      label: 'जैविक पदार्थ (%)',
                      controller: _farmlandSoilOrganicController,
                      hint: 'जैविक पदार्थको मात्रा प्रविष्टि गर्नुहोस्',
                    ),
                    _buildSoilInput(
                      label: 'फास्फेट (किलोग्राम/हेक्टर)',
                      controller: _farmlandSoilPController,
                      hint: 'फास्फेटको मात्रा प्रविष्टि गर्नुहोस्',
                    ),
                    _buildSoilInput(
                      label: 'पोटासियम',
                      controller: _farmlandSoilKController,
                      hint: 'पोटासियमको मात्रा प्रविष्टि गर्नुहोस्',
                    ),
                    _buildSoilInput(
                      label: 'पी.एच',
                      controller: _farmlandSoilPHController,
                      hint: 'पी.एच मात्रा प्रविष्टि गर्नुहोस्',
                      isLast: true,
                    ),
                  ],
                ),

                SizedBox(height: getProportionateScreenWidth(24)),

                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    minimumSize:
                        Size(double.infinity, getProportionateScreenWidth(48)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    farmlandController.isEdit.value
                        ? 'अपडेट गर्नुहोस्'
                        : 'थप्नुहोस्',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (farmlandController.isEdit.value) {
                        farmlandController.updateFarmland(Farmland(
                          id: selectedFarmland.id!,
                          title: _farmlandTitleController.text,
                          description: _farmlandDescriptionController.text,
                          image: farmlandController
                                  .selectedFarmlandImage.value.isNotEmpty
                              ? farmlandController.selectedFarmlandImage.value
                              : null,
                          lat: _farmlandLatController.text.isNotEmpty
                              ? double.tryParse(_farmlandLatController.text)
                              : null,
                          lng: _farmlandLngController.text.isNotEmpty
                              ? double.tryParse(_farmlandLngController.text)
                              : null,
                          nitrogen: _farmlandSoilNController.text.isNotEmpty
                              ? double.tryParse(_farmlandSoilNController.text)
                              : null,
                          phosphate: _farmlandSoilPController.text.isNotEmpty
                              ? double.tryParse(_farmlandSoilPController.text)
                              : null,
                          potassium: _farmlandSoilKController.text.isNotEmpty
                              ? double.tryParse(_farmlandSoilKController.text)
                              : null,
                          pH: _farmlandSoilPHController.text.isNotEmpty
                              ? double.tryParse(_farmlandSoilPHController.text)
                              : null,
                          organicMatter:
                              _farmlandSoilOrganicController.text.isNotEmpty
                                  ? double.tryParse(
                                      _farmlandSoilOrganicController.text)
                                  : null,
                          temperature:
                              double.tryParse(_farmlandTempController.text),
                          humidity:
                              double.tryParse(_farmlandHumidityController.text),
                          rainfall:
                              double.tryParse(_farmlandRainfallController.text),
                        ));
                      } else {
                        farmlandController.addFarmland(
                            Farmland(
                              title: _farmlandTitleController.text,
                              description: _farmlandDescriptionController.text,
                              image: farmlandController
                                      .selectedFarmlandImage.value.isNotEmpty
                                  ? farmlandController
                                      .selectedFarmlandImage.value
                                  : null,
                              lat: _farmlandLatController.text.isNotEmpty
                                  ? double.tryParse(_farmlandLatController.text)
                                  : null,
                              lng: _farmlandLngController.text.isNotEmpty
                                  ? double.tryParse(_farmlandLngController.text)
                                  : null,
                              nitrogen: _farmlandSoilNController.text.isNotEmpty
                                  ? double.tryParse(
                                      _farmlandSoilNController.text)
                                  : null,
                              phosphate:
                                  _farmlandSoilPController.text.isNotEmpty
                                      ? double.tryParse(
                                          _farmlandSoilPController.text)
                                      : null,
                              potassium:
                                  _farmlandSoilKController.text.isNotEmpty
                                      ? double.tryParse(
                                          _farmlandSoilKController.text)
                                      : null,
                              pH: _farmlandSoilPHController.text.isNotEmpty
                                  ? double.tryParse(
                                      _farmlandSoilPHController.text)
                                  : null,
                              organicMatter:
                                  _farmlandSoilOrganicController.text.isNotEmpty
                                      ? double.tryParse(
                                          _farmlandSoilOrganicController.text)
                                      : null,
                              temperature:
                                  double.tryParse(_farmlandTempController.text),
                              humidity: double.tryParse(
                                  _farmlandHumidityController.text),
                              rainfall: double.tryParse(
                                  _farmlandRainfallController.text),
                              date: DateTime.now().toString(),
                            ),
                            false);
                      }
                    }
                  },
                ),
                SizedBox(height: getProportionateScreenWidth(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? actionButton,
  }) {
    return Container(
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
          // Header
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(16)),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: kPrimaryColor,
                    size: getProportionateScreenWidth(20),
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(12)),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: getProportionateScreenWidth(15),
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
                if (actionButton != null) actionButton,
              ],
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: getProportionateScreenWidth(13),
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: getProportionateScreenWidth(16)),
      label: Text(
        label,
        style: TextStyle(fontSize: getProportionateScreenWidth(11)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(12),
          vertical: getProportionateScreenWidth(8),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildSoilInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        SizedBox(height: getProportionateScreenWidth(8)),
        InputTextField(
          textEditingController: controller,
          title: hint,
          textInputType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        if (!isLast) SizedBox(height: getProportionateScreenWidth(16)),
      ],
    );
  }
}
