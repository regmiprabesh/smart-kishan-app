import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class SortProductButtonsheet extends StatefulWidget {
  final Function(String, String code) onOptionSelected;
  final String selectedOption; // Pass the selected option

  const SortProductButtonsheet({
    Key? key,
    required this.onOptionSelected,
    required this.selectedOption,
  }) : super(key: key);

  @override
  _SortProductButtonsheetState createState() => _SortProductButtonsheetState();
}

class _SortProductButtonsheetState extends State<SortProductButtonsheet> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption =
        widget.selectedOption; // Initialize with the selected value
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.sortBy,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: kCardDescColor),
          ),
          SizedBox(height: 8),
          ListView(
            shrinkWrap: true,
            children: [
              _buildSortOption(
                  AppLocalizations.of(context)!.defaultResults, 'Default'),
              _buildSortOption(
                  AppLocalizations.of(context)!.recentlyAdded, 'Newest'),
              _buildSortOption(
                  AppLocalizations.of(context)!.priceLowToHigh, 'LowToHigh'),
              _buildSortOption(
                  AppLocalizations.of(context)!.priceHighToLow, 'HighToLow'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(String title, String code) {
    final isSelected = _selectedOption == code;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      trailing: Radio<String>(
        value: code,
        groupValue: _selectedOption,
        activeColor: kPrimaryColor,
        onChanged: (value) {
          setState(() {
            _selectedOption = value!;
          });
          widget.onOptionSelected(
              value!, code); // Notify parent widget of selection
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: TextStyle(
            color: isSelected ? kPrimaryColor : kCardTitleColor,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 15),
      ),
      onTap: () {
        setState(() {
          _selectedOption = title;
        });
        widget.onOptionSelected(
            title, code); // Notify parent widget of selection
        Navigator.pop(context);
      },
    );
  }
}
