import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_kishan/constant.dart';

class SingleSelectSearch<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemName;
  final String? Function(T)? itemImage;
  final String? Function(T)? itemType;
  final String Function(T) itemId; // Unique identifier extractor
  final void Function(T) onSelectionChanged;
  final FormFieldValidator<T>? validator;
  final T? selectedItem;

  const SingleSelectSearch({
    Key? key,
    required this.title,
    required this.items,
    required this.itemName,
    required this.itemId,
    this.itemType,
    this.itemImage,
    required this.onSelectionChanged,
    this.validator,
    this.selectedItem,
  }) : super(key: key);

  @override
  State<SingleSelectSearch<T>> createState() => _SingleSelectSearchState<T>();
}

class _SingleSelectSearchState<T> extends State<SingleSelectSearch<T>> {
  T? selectedItem; // Variable to hold the selected item
  late List<T> filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem != null
        ? selectedItem
        : null; // Initialize with pre-selected item, if any
    filteredItems = widget.items;
  }

  void toggleSelection(T item) {
    setState(() {
      selectedItem = item; // Update selected item
    });
    widget.onSelectionChanged(item); // Call the callback with the selected item
    Navigator.pop(context); // Dismiss the modal on selection
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
    return FormField<T>(
      initialValue: selectedItem,
      validator: (value) {
        if (selectedItem == null) {
          return "Please select a ${widget.title}.";
        }
        return null;
      },
      builder: (FormFieldState<T> state) {
        bool hasError = state.hasError && selectedItem == null;

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
                                          '${widget.title} चयन गर्नुहोस्',
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
                                        final isSelected = widget
                                                .itemId(item) ==
                                            (selectedItem != null
                                                ? widget.itemId(selectedItem!)
                                                : null);
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
                                          trailing: Radio<T>(
                                            activeColor: Colors.green,
                                            value: item,
                                            groupValue: selectedItem,
                                            onChanged: (value) {
                                              if (value != null) {
                                                toggleSelection(value);
                                              }
                                            },
                                          ),
                                          onTap: () {
                                            toggleSelection(item);
                                          },
                                        );
                                      },
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
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 12),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: hasError ? Colors.red : Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      selectedItem == null
                          ? "${widget.title} चयन गर्नुहोस्।"
                          : widget.itemName(selectedItem!),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor,
                          fontSize: 14),
                    ),
                    Spacer(),
                    Icon(
                      CupertinoIcons.chevron_down,
                      size: 20,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
            if (state.hasError && selectedItem == null)
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
