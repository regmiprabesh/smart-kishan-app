import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/size_config.dart';

class PeriodDropdown extends StatelessWidget {
  const PeriodDropdown({
    super.key,
    required this.onUpdate,
    required this.selectedFilter,
  });

  final Function onUpdate;
  final String selectedFilter;

  // Maps the internal English key to its localised label
  String _label(String filter, AppLocalizations l10n) {
    switch (filter) {
      case 'Monthly':
        return l10n.filterMonthly;
      case 'Yearly':
        return l10n.filterYearly;
      case 'Daily':
      default:
        return l10n.filterDaily;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const List<String> items = ['Daily', 'Monthly', 'Yearly'];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kCardDescColor),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(
            Icons.timelapse,
            size: getProportionateScreenWidth(12),
            color: kPrimaryColor,
          ),
          const SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Row(
                children: [
                  Expanded(
                    child: Text(
                      _label(selectedFilter, l10n),
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(10),
                        fontWeight: FontWeight.w600,
                        color: kCardTitleColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          _label(item, l10n),
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(10),
                            fontWeight: FontWeight.w600,
                            color: kCardTitleColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: null,
              onChanged: (String? value) => onUpdate(value),
              buttonStyleData: const ButtonStyleData(
                height: 30,
                width: 80,
                padding: EdgeInsets.only(left: 6, right: 10),
                elevation: 0,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.arrow_forward_ios_outlined),
                iconSize: 14,
                iconEnabledColor: kPrimaryColor,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 110,
                decoration: const BoxDecoration(color: kPrimaryLightColor),
                offset: const Offset(-28, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all<double>(6),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
