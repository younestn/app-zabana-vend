import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/order/domain/models/order_model.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_image_widget.dart';


class CustomerContactWidget extends StatelessWidget {
  final Order? orderModel;
  const CustomerContactWidget({super.key, this.orderModel});

  @override
Widget build(BuildContext context) {
  final bool isGuest = orderModel?.isGuest ?? false;

  final String displayName = isGuest
      ? (orderModel?.shippingAddressData?.contactPersonName
              ?? orderModel?.billingAddressData?.contactPersonName
              ?? '')
      : '${orderModel?.customer?.fName ?? ''} ${orderModel?.customer?.lName ?? ''}'.trim();

  final String displayPhone = isGuest
      ? (orderModel?.shippingAddressData?.phone
              ?? orderModel?.billingAddressData?.phone
              ?? '')
      : (orderModel?.customer?.phone ?? '');

  final String displayEmail = isGuest
      ? (orderModel?.shippingAddressData?.email
              ?? orderModel?.billingAddressData?.email
              ?? '')
      : (orderModel?.customer?.email ?? '');

  final trust = orderModel?.customerTrustScore;
  final bool hasTrustHistory = trust?.hasHistory == true;
final String trustLabel = trust?.label?.trim() ?? '';
final String trustBadgeText = hasTrustHistory
    ? 'سجل هذا الزبون عبر المنصة'
    : 'لا يوجد سجل محسوم';

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: Dimensions.paddingSizeDefault,
      vertical: Dimensions.paddingSizeMedium,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      boxShadow: ThemeShadow.getShadow(context),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isGuest
              ? '${getTranslated('customer_information', context)} (${getTranslated('guest_customer', context)})'
              : '${getTranslated('customer_information', context)}',
          style: robotoMedium.copyWith(
            color: ColorHelper.blendColors(
              Colors.white,
              Theme.of(context).textTheme.bodyLarge!.color!,
              0.7,
            ),
            fontSize: Dimensions.fontSizeLarge,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (orderModel?.customer?.imageFullPath?.path != null &&
                    orderModel!.customer!.imageFullPath!.path!.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CustomImageWidget(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      image: '${orderModel?.customer?.imageFullPath?.path}',
                    ),
                  )
                : CircleAvatar(
                    radius: 25,
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: .12),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        displayName,
                        style: titilliumRegular.copyWith(
                          color: ColorHelper.blendColors(
                            Colors.white,
                            Theme.of(context).textTheme.bodyLarge!.color!,
                            0.7,
                          ),
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),

                      if (trust != null)
  Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: hasTrustHistory
          ? Theme.of(context).primaryColor.withValues(alpha: .12)
          : Theme.of(context).hintColor.withValues(alpha: .15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      trustBadgeText,
      style: titilliumRegular.copyWith(
        fontSize: 12,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    ),
  ),
                    ],
                  ),

                if (trustLabel.isNotEmpty) ...[
  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
  Text(
    trustLabel,
    style: titilliumRegular.copyWith(
      color: ColorHelper.blendColors(
        Colors.white,
        Theme.of(context).textTheme.bodyLarge!.color!,
        0.7,
      ),
      fontSize: Dimensions.fontSizeDefault,
    ),
  ),
],

                  if (displayPhone.isNotEmpty) ...[
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Images.phone, width: 15),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              displayPhone,
                              textAlign: TextAlign.left,
                              style: titilliumRegular.copyWith(
                                color: ColorHelper.blendColors(
                                  Colors.white,
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                                  0.7,
                                ),
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (displayEmail.isNotEmpty) ...[
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Images.email, width: 15),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              displayEmail,
                              textAlign: TextAlign.left,
                              style: titilliumRegular.copyWith(
                                color: ColorHelper.blendColors(
                                  Colors.white,
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                                  0.7,
                                ),
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
}
