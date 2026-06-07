import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemName;
  final String? Function(T)? itemImage;
  final String? Function(T)? itemType;
  final String Function(T) itemId; // Unique identifier extractor
  final void Function(List<T>) onSelectionChanged;
  final FormFieldValidator<List<T>>? validator;
  final List<T> selectedItems;

  const CustomDropdown({
    Key? key,
    required this.title,
    required this.items,
    required this.itemName,
    required this.itemId, // Add this parameter
    this.itemType,
    this.itemImage,
    required this.onSelectionChanged,
    this.validator,
    required this.selectedItems,
  }) : super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  List<T> selectedItems = [];
  late List<T> filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedItems = widget.selectedItems;
    filteredItems = widget.items;
  }

  void toggleSelection(T item) {
    setState(() {
      final itemId = widget.itemId(item);
      if (selectedItems.any((selected) => widget.itemId(selected) == itemId)) {
        selectedItems
            .removeWhere((selected) => widget.itemId(selected) == itemId);
      } else {
        selectedItems.add(item);
      }
    });
    widget.onSelectionChanged(selectedItems);
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems = widget.items
            .where((item) => widget
                .itemName(item)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      initialValue: selectedItems,
      validator: widget.validator,
      builder: (FormFieldState<List<T>> state) {
        bool hasError = state.hasError && selectedItems.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.title}हरू चयन गर्नुहोस्',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 10),
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search),
                                        hintText: "खोज्नुहोस्...",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.green.shade200),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: Colors.green.shade200),
                                        ),
                                      ),
                                      onChanged: (query) {
                                        setState(() {
                                          filterItems(query);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: filteredItems.length,
                                      itemBuilder: (context, index) {
                                        final item = filteredItems[index];
                                        final isSelected = selectedItems.any(
                                            (selected) =>
                                                widget.itemId(selected) ==
                                                widget.itemId(item));
                                        return ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 13),
                                          leading: widget.itemImage != null
                                              ? ClipOval(
                                                  child: Image.network(
                                                    widget.itemImage!(item) !=
                                                            null
                                                        ? '$imgUrl${widget.itemImage!(item)}'
                                                        : '',
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : null,
                                          title: Text(
                                            widget.itemName(item),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: widget.itemType != null
                                              ? Text(
                                                  widget.itemType!(item)!
                                                          .substring(0, 1)
                                                          .toUpperCase() +
                                                      widget.itemType!(item)!
                                                          .substring(1)
                                                          .toLowerCase(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              : null,
                                          trailing: SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: Checkbox(
                                              activeColor: Colors.green,
                                              value: isSelected,
                                              onChanged: (value) {
                                                setState(() {
                                                  toggleSelection(item);
                                                });
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              toggleSelection(item);
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                        ),
                                        child: const Text("पुष्टि गर्नुहोस्"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 9, vertical: selectedItems.isEmpty ? 12 : 0),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: hasError ? Colors.red : Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        selectedItems.isNotEmpty
                            ? Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (var item in selectedItems)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Chip(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            label: Text(
                                              widget.itemName(item),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 8.0),
                                            backgroundColor:
                                                Colors.green.withOpacity(0.2),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                              bottom: selectedItems.isEmpty ? 0 : 5),
                          child: Text(
                            selectedItems.isEmpty
                                ? "${widget.title} चयन गर्नुहोस्।"
                                : "(${selectedItems.length})",
                            style: TextStyle(
                                fontWeight: selectedItems.isNotEmpty
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                color: Theme.of(context).hintColor,
                                fontSize: 14),
                          ),
                        ),
                        selectedItems.isEmpty ? Spacer() : SizedBox(),
                        Icon(
                          CupertinoIcons.chevron_down,
                          size: 20,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Only show error if no item is selected
            if (state.hasError && selectedItems.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
