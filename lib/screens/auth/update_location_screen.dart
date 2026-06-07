import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/auth_controller.dart';
import 'package:smart_kishan/languages/langauge_constants.dart';
import 'package:smart_kishan/screens/auth/services/remote_auth_services.dart';
import 'package:smart_kishan/size_config.dart';

class UpdateLocationScreen extends StatefulWidget {
  const UpdateLocationScreen({Key? key}) : super(key: key);

  @override
  State<UpdateLocationScreen> createState() => _UpdateLocationScreenState();
}

class _UpdateLocationScreenState extends State<UpdateLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find();
  final RemoteAuthService _remoteAuthService = RemoteAuthService();

  late TextEditingController _addressController;

  bool _isLoading = false;
  bool _isLoadingProvinces = false;
  bool _isLoadingDistricts = false;
  bool _isLoadingMunicipalities = false;
  bool _isLoadingWards = false;

  int? _selectedProvinceId;
  int? _selectedDistrictId;
  int? _selectedMunicipalityId;
  int? _selectedWardId;

  List<dynamic> _provinces = [];
  List<dynamic> _districts = [];
  List<dynamic> _municipalities = [];
  List<dynamic> _wards = [];

  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _currentLanguage = Get.locale?.languageCode ?? 'en';
    _addressController =
        TextEditingController(text: authController.user.value?.address ?? '');
    _selectedProvinceId = authController.user.value?.provinceId;
    _selectedDistrictId = authController.user.value?.districtId;
    _selectedMunicipalityId = authController.user.value?.municipalityId;
    _selectedWardId = authController.user.value?.wardId;
    _loadProvinces();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  String _getMultilingualName(dynamic item) {
    if (item == null) return '';
    var name = item['name'];
    if (name is Map) {
      return name[_currentLanguage] ?? name['en'] ?? name['ne'] ?? '';
    }
    return name?.toString() ?? '';
  }

  Future<void> _loadProvinces() async {
    setState(() {
      _isLoadingProvinces = true;
    });

    try {
      final result = await _remoteAuthService.getProvinces();
      if (result['success']) {
        setState(() {
          _provinces = result['data'];
        });
        if (_selectedProvinceId != null) {
          await _loadDistricts(_selectedProvinceId!);
        }
      }
    } catch (e) {
      print('Error loading provinces: $e');
    } finally {
      setState(() {
        _isLoadingProvinces = false;
      });
    }
  }

  Future<void> _loadDistricts(int provinceId) async {
    setState(() {
      _isLoadingDistricts = true;
      _districts = [];
      _municipalities = [];
      _wards = [];
    });

    try {
      final result = await _remoteAuthService.getDistricts(provinceId);
      if (result['success']) {
        setState(() {
          _districts = result['data'];
        });
        if (_selectedDistrictId != null) {
          await _loadMunicipalities(_selectedDistrictId!);
        }
      }
    } catch (e) {
      print('Error loading districts: $e');
    } finally {
      setState(() {
        _isLoadingDistricts = false;
      });
    }
  }

  Future<void> _loadMunicipalities(int districtId) async {
    setState(() {
      _isLoadingMunicipalities = true;
      _municipalities = [];
      _wards = [];
    });

    try {
      final result = await _remoteAuthService.getMunicipalities(districtId);
      if (result['success']) {
        setState(() {
          _municipalities = result['data'];
        });
        if (_selectedMunicipalityId != null) {
          await _loadWards(_selectedMunicipalityId!);
        }
      }
    } catch (e) {
      print('Error loading municipalities: $e');
    } finally {
      setState(() {
        _isLoadingMunicipalities = false;
      });
    }
  }

  Future<void> _loadWards(int municipalityId) async {
    setState(() {
      _isLoadingWards = true;
      _wards = [];
    });

    try {
      final result = await _remoteAuthService.getWards(municipalityId);
      if (result['success']) {
        setState(() {
          _wards = result['data'];
        });
      }
    } catch (e) {
      print('Error loading wards: $e');
    } finally {
      setState(() {
        _isLoadingWards = false;
      });
    }
  }

// Replace the _updateLocation method in UpdateLocationScreen with this:

  Future<void> _updateLocation() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedProvinceId == null ||
        _selectedDistrictId == null ||
        _selectedMunicipalityId == null ||
        _selectedWardId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kErrorColor,
          content: Text(
            'Please select all location fields',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await authController.updateLocation(
        address: _addressController.text.trim(),
        provinceId: _selectedProvinceId!,
        districtId: _selectedDistrictId!,
        municipalityId: _selectedMunicipalityId!,
        wardId: _selectedWardId!,
      );
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'Location updated successfully',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
        // Return true to indicate successful update
        Get.back(result: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'Failed to update location',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kErrorColor,
          content: Text(
            'An error occurred',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = translation(context);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          t.updateLocation,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(20)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),

                // White Card Container
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Province Dropdown
                      Text(
                        t.province,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      _buildDropdown(
                        value: _selectedProvinceId,
                        items: _provinces,
                        hint: t.selectProvince,
                        isLoading: _isLoadingProvinces,
                        onChanged: (value) {
                          setState(() {
                            _selectedProvinceId = value;
                            _selectedDistrictId = null;
                            _selectedMunicipalityId = null;
                            _selectedWardId = null;
                          });
                          if (value != null) {
                            _loadDistricts(value);
                          }
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),

                      // District Dropdown
                      Text(
                        t.district,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      _buildDropdown(
                        value: _selectedDistrictId,
                        items: _districts,
                        hint: t.selectDistrict,
                        isLoading: _isLoadingDistricts,
                        enabled: _selectedProvinceId != null,
                        onChanged: (value) {
                          setState(() {
                            _selectedDistrictId = value;
                            _selectedMunicipalityId = null;
                            _selectedWardId = null;
                          });
                          if (value != null) {
                            _loadMunicipalities(value);
                          }
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),

                      // Municipality Dropdown
                      Text(
                        t.municipality,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      _buildDropdown(
                        value: _selectedMunicipalityId,
                        items: _municipalities,
                        hint: t.selectMunicipality,
                        isLoading: _isLoadingMunicipalities,
                        enabled: _selectedDistrictId != null,
                        onChanged: (value) {
                          setState(() {
                            _selectedMunicipalityId = value;
                            _selectedWardId = null;
                          });
                          if (value != null) {
                            _loadWards(value);
                          }
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),

                      // Ward Dropdown
                      Text(
                        t.ward,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      _buildDropdown(
                        value: _selectedWardId,
                        items: _wards,
                        hint: t.selectWard,
                        isLoading: _isLoadingWards,
                        enabled: _selectedMunicipalityId != null,
                        onChanged: (value) {
                          setState(() {
                            _selectedWardId = value;
                          });
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),

                      // Address Field
                      Text(
                        t.address,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: t.enterAddress,
                          filled: true,
                          fillColor: kBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15),
                            vertical: getProportionateScreenHeight(15),
                          ),
                        ),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return t.pleaseEnterAddress;
                        //   }
                        //   return null;
                        // },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: getProportionateScreenHeight(30)),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(50),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            t.updateLocation,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(16),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required int? value,
    required List<dynamic> items,
    required String hint,
    required bool isLoading,
    bool enabled = true,
    required Function(int?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? kBackgroundColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
      child: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: value,
                hint: Text(hint),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: kPrimaryColor),
                items: items.map<DropdownMenuItem<int>>((item) {
                  return DropdownMenuItem<int>(
                    value: item['id'],
                    child: Text(_getMultilingualName(item)),
                  );
                }).toList(),
                onChanged: enabled ? onChanged : null,
              ),
            ),
    );
  }
}
