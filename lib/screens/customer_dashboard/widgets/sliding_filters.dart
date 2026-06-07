import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/widgets/custom_filter.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class SlidingFilters extends StatefulWidget {
  const SlidingFilters({super.key});

  @override
  State<SlidingFilters> createState() => _SlidingFiltersState();
}

class _SlidingFiltersState extends State<SlidingFilters> {
  String selectedFiltersText = ''; // Store selected filter names as text

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttonLabels = [
      {
        'icon': HugeIcons.strokeRoundedClean,
        'type': 'clearFilters',
        'code': 'clearFilters'
      },
      {
        'name': AppLocalizations.of(context)!.categories,
        'icon': HugeIcons.strokeRoundedGeometricShapes01,
        'type': 'MultiSelect',
        'code': 'categories'
      },
      {
        'name': AppLocalizations.of(context)!.paymentTypes,
        'icon': HugeIcons.strokeRoundedPayment01,
        'type': 'MultiSelect',
        'code': 'paymentType'
      },

      // Add other filters here
    ];
    return Column(
      children: [
        SizedBox(
          height: 45,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: buttonLabels.length,
            separatorBuilder: (context, index) => SizedBox(width: 10),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            itemBuilder: (context, index) {
              return buttonLabels[index]['code'] == 'clearFilters'
                  ? Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: ShapeDecoration(
                          color: kPrimaryGrey.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: SizedBox(
                          height: 45,
                          width: 45,
                          child: IconButton(
                            iconSize: 20,
                            color: kErrorColor,
                            icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedFilterReset),
                            onPressed: () {
                              buyProductsController.clearFilters();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    )
                  : buttonLabels[index]['code'] == 'paymentType'
                      ? CustomFilter(
                          title: buttonLabels[index]['name'],
                          items: buyProductsController.paymentMethods,
                          selectedItems:
                              buyProductsController.selectedPaymentMethods,
                          itemName: (item) => item.name,
                          itemImage: (item) => item.image,
                          itemId: (item) => item.id.toString(),
                          icon: buttonLabels[index]['icon'],
                          onSelectionChanged: (selected) {
                            buyProductsController.selectedPaymentMethods
                                .clear();
                            buyProductsController.selectedPaymentMethods
                                .addAll(selected);
                            buyProductsController.searchProducts();
                          },
                        )
                      : buttonLabels[index]['code'] == 'categories'
                          ? CustomFilter(
                              title: buttonLabels[index]['name'],
                              items: cropCategoryController.cropCategories,
                              selectedItems:
                                  buyProductsController.selectedCategories,
                              itemName: (item) => '${item.name}',
                              itemImage: (item) => '${item.image}',
                              itemId: (item) => item.id.toString(),
                              icon: buttonLabels[index]['icon'],
                              onSelectionChanged: (selected) {
                                buyProductsController.selectedCategories
                                    .clear();
                                buyProductsController.selectedCategories
                                    .addAll(selected);
                                buyProductsController.searchProducts();
                              },
                            )
                          : null;
            },
          ),
        ),
      ],
    );
  }
}
