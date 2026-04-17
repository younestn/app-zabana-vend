import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/dropdown_decorator_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/addProduct/controllers/add_product_controller.dart';
import 'package:sixvalley_vendor_app/features/product/controllers/category_controller.dart';
import 'package:sixvalley_vendor_app/features/product/domain/models/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class SelectCategoryWidget extends StatefulWidget {
  final Product? product;
  const SelectCategoryWidget({super.key, required this.product});

  @override
  SelectCategoryWidgetState createState() => SelectCategoryWidgetState();
}

class SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductController>(
      builder: (context, addProductController, child) {
        return Consumer<CategoryController>(
          builder: (context, categoryController, child) {
            if (categoryController.categoryList == null) {
              return const SizedBox.shrink();
            }

            if (categoryController.categoryList!.isEmpty) {
              return const NoDataScreen(title: 'no_category_found');
            }

            final String? selectedCategoryName =
                (categoryController.categoryIndex != null &&
                        categoryController.categoryIndex! > 0 &&
                        categoryController.categoryList!.length >=
                            categoryController.categoryIndex!)
                    ? categoryController
                        .categoryList![categoryController.categoryIndex! - 1].name
                    : null;

            final String? selectedSubCategoryName =
                (categoryController.subCategoryList != null &&
                        categoryController.subCategoryIndex != null &&
                        categoryController.subCategoryIndex! > 0 &&
                        categoryController.subCategoryList!.length >=
                            categoryController.subCategoryIndex!)
                    ? categoryController
                        .subCategoryList![categoryController.subCategoryIndex! - 1].name
                    : null;

            final String? selectedSubSubCategoryName =
                (categoryController.subSubCategoryList != null &&
                        categoryController.subSubCategoryIndex != null &&
                        categoryController.subSubCategoryIndex! > 0 &&
                        categoryController.subSubCategoryList!.length >=
                            categoryController.subSubCategoryIndex!)
                    ? categoryController.subSubCategoryList![
                            categoryController.subSubCategoryIndex! - 1]
                        .name
                    : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),

                _buildSelectorField(
                  title: getTranslated('category', context) ?? 'الفئة',
                  placeholder:
                      getTranslated('select_category', context) ?? 'اختر الفئة',
                  value: selectedCategoryName,
                  onTap: () async {
                    await _showPickerBottomSheet(
                      title: getTranslated('select_category', context) ??
                          'اختر الفئة',
                      items: categoryController.categoryList!
                          .map((e) => e.name ?? '')
                          .toList(),
                      selectedIndex:
                          categoryController.categoryIndex != null &&
                                  categoryController.categoryIndex! > 0
                              ? categoryController.categoryIndex! - 1
                              : null,
                      onSelect: (int index) {
                        final int selectedValue = index + 1;
                        categoryController.setCategoryIndex(selectedValue, true);
                        categoryController.getSubCategoryList(
                          context,
                          categoryController.categorySelectedIndex,
                          true,
                          widget.product,
                        );
                        setState(() {});
                      },
                    );
                  },
                ),

                addProductController.productTypeIndex == 0
                    ? const SizedBox(height: Dimensions.paddingSizeMedium)
                    : const SizedBox.shrink(),

                if (categoryController.subCategoryList != null &&
                    categoryController.subCategoryList!.isNotEmpty)
                  Column(
                    children: [
                      _buildSelectorField(
                        title:
                            getTranslated('sub_category', context) ?? 'الفئة الفرعية',
                        placeholder: getTranslated('sub_category', context) ??
                            'الفئة الفرعية',
                        value: selectedSubCategoryName,
                        onTap: () async {
                          await _showPickerBottomSheet(
                            title: getTranslated('sub_category', context) ??
                                'الفئة الفرعية',
                            items: categoryController.subCategoryList!
                                .map((e) => e.name ?? '')
                                .toList(),
                            selectedIndex:
                                categoryController.subCategoryIndex != null &&
                                        categoryController.subCategoryIndex! > 0
                                    ? categoryController.subCategoryIndex! - 1
                                    : null,
                            onSelect: (int index) {
                              final int selectedValue = index + 1;
                              categoryController.setSubCategoryIndex(
                                  selectedValue, true);
                              categoryController.getSubSubCategoryList(
                                categoryController.subCategorySelectedIndex,
                                true,
                              );
                              setState(() {});
                            },
                          );
                        },
                      ),

                      addProductController.productTypeIndex == 0
                          ? const SizedBox(
                              height: Dimensions.paddingSizeMedium)
                          : const SizedBox.shrink(),
                    ],
                  ),

                if (categoryController.subSubCategoryList != null &&
                    categoryController.subSubCategoryList!.isNotEmpty)
                  Column(
                    children: [
                      _buildSelectorField(
                        title: getTranslated('sub_sub_category', context) ??
                            'الفئة الفرعية جدًا',
                        placeholder: getTranslated('sub_sub_category', context) ??
                            'الفئة الفرعية جدًا',
                        value: selectedSubSubCategoryName,
                        onTap: () async {
                          await _showPickerBottomSheet(
                            title: getTranslated('sub_sub_category', context) ??
                                'الفئة الفرعية جدًا',
                            items: categoryController.subSubCategoryList!
                                .map((e) => e.name ?? '')
                                .toList(),
                            selectedIndex:
                                categoryController.subSubCategoryIndex != null &&
                                        categoryController.subSubCategoryIndex! > 0
                                    ? categoryController.subSubCategoryIndex! - 1
                                    : null,
                            onSelect: (int index) {
                              final int selectedValue = index + 1;
                              categoryController.setSubSubCategoryIndex(
                                  selectedValue, true);
                              setState(() {});
                            },
                          );
                        },
                      ),

                      addProductController.productTypeIndex == 0
                          ? const SizedBox(
                              height: Dimensions.paddingSizeMedium)
                          : const SizedBox.shrink(),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSelectorField({
    required String title,
    required String placeholder,
    required String? value,
    required VoidCallback onTap,
  }) {
    return DropdownDecoratorWidget(
      title: title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (value == null || value.isEmpty) ? placeholder : value,
                  style: robotoMedium.copyWith(
                    color: (value == null || value.isEmpty)
                        ? Theme.of(context).hintColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ),
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: .08),
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPickerBottomSheet({
    required String title,
    required List<String> items,
    required Function(int index) onSelect,
    int? selectedIndex,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .72,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withValues(alpha: .35),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        child: Container(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(
                                Dimensions.radiusDefault),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Dimensions.paddingSizeDefault),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeLarge,
                      0,
                      Dimensions.paddingSizeLarge,
                      Dimensions.paddingSizeLarge,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                    itemBuilder: (context, index) {
                      final bool isSelected = selectedIndex == index;

                      return InkWell(
                        onTap: () {
                          onSelect(index);
                          Navigator.pop(context);
                        },
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeDefault,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: .10)
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(
                                Dimensions.radiusDefault),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: .10),
                              width: isSelected ? 1.2 : .8,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withValues(alpha: .08),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  items[index],
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  height: 26,
                                  width: 26,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}