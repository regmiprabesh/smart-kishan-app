import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class CustomFilter<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemName;
  final String? Function(T)? itemImage;
  final String? Function(T)? itemType;
  final String Function(T) itemId; // Unique identifier extractor
  final void Function(List<T>) onSelectionChanged;
  final List<T> selectedItems;
  final List<List<dynamic>> icon;
  const CustomFilter(
      {super.key,
      required this.title,
      required this.items,
      required this.itemName,
      required this.itemId, // Add this parameter
      this.itemType,
      this.itemImage,
      required this.onSelectionChanged,
      required this.selectedItems,
      required this.icon});

  @override
  State<CustomFilter<T>> createState() => _CustomFilterState<T>();
}

class _CustomFilterState<T> extends State<CustomFilter<T>> {
  List<T> selectedItems = [];
  List<T> temporarySelectedItems = []; // Temporary storage for selections
  late List<T> filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedItems = widget.selectedItems;
    filteredItems = widget.items;
    temporarySelectedItems = List.from(selectedItems); // Initialize temp list
  }

  @override
  void didUpdateWidget(covariant CustomFilter<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems != oldWidget.selectedItems) {
      setState(() {
        selectedItems = widget.selectedItems;
        temporarySelectedItems = List.from(selectedItems);
      });
    }
  }

  void toggleSelection(T item) {
    setState(() {
      final itemId = widget.itemId(item);
      if (temporarySelectedItems
          .any((selected) => widget.itemId(selected) == itemId)) {
        temporarySelectedItems
            .removeWhere((selected) => widget.itemId(selected) == itemId);
      } else {
        temporarySelectedItems.add(item);
      }
    });
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
      builder: (FormFieldState<List<T>> state) {
        return Material(
          color: Colors.transparent, // To prevent material color overlay
          child: InkWell(
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
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SizedBox(
                            // Adjust the height here (e.g., 60% of the screen height)
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 20,
                                      bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .filterTitle(widget.title),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: kCardDescColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 0),
                                  child: SizedBox(
                                    height: 47,
                                    child: TextField(
                                      controller: _searchController,
                                      cursorColor: kPrimaryColor,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search),
                                        fillColor:
                                            kPrimaryGrey.withOpacity(0.4),
                                        filled: true,
                                        hintText: AppLocalizations.of(context)!
                                            .searchHint,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide:
                                              BorderSide(color: kPrimaryGrey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide:
                                              BorderSide(color: kPrimaryGrey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide:
                                              BorderSide(color: kPrimaryGrey),
                                        ),
                                      ),
                                      onChanged: (query) {
                                        setState(() {
                                          filterItems(query);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredItems.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredItems[index];
                                      final isSelected = temporarySelectedItems
                                          .any((selected) =>
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
                                        widget.onSelectionChanged(
                                            temporarySelectedItems);
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(AppLocalizations.of(context)!
                                          .confirm),
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
              ).whenComplete(() {
                setState(() {
                  temporarySelectedItems.clear();
                  temporarySelectedItems.addAll(selectedItems);
                });
              });
            },
            splashColor: kPrimaryColor.withOpacity(0.3), // Ripple color
            highlightColor: kPrimaryColor.withOpacity(0.1), // Highlight color
            borderRadius:
                BorderRadius.circular(10), // Rounded corners for ripple effect
            child: Container(
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: kPrimaryGrey.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HugeIcon(
                    icon: widget.icon,
                    size: 20,
                    color: kPrimaryColor, // Green color for the icon
                  ),
                  SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Text(
                      temporarySelectedItems.isNotEmpty
                          ? temporarySelectedItems
                              .map((item) => widget.itemName(item))
                              .join(', ')
                          : widget.title,
                      overflow:
                          TextOverflow.ellipsis, // Handle long names gracefully
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
