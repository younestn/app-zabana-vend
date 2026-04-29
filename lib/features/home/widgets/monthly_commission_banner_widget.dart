import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:sixvalley_vendor_app/features/bank_info/screens/commission_invoice_details_screen.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/controllers/localization_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class MonthlyCommissionBannerWidget extends StatelessWidget {
  const MonthlyCommissionBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BankInfoController>(
      builder: (context, bankInfoController, _) {
        final invoice = bankInfoController.currentMonthCommissionInvoice;

        if (bankInfoController.isCommissionLoading && invoice == null) {
          return Container(
            height: 108,
            margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeExtraSmall,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
          );
        }

        if (invoice == null) {
          return const SizedBox();
        }

        final Color cardColor = invoice.paymentStatus == 'paid'
            ? Theme.of(context).colorScheme.onTertiaryContainer
            : ColorHelper.blendColors(
                Colors.white,
                Theme.of(context).primaryColor,
                0.72,
              );

        final bool isLtr =
            Provider.of<LocalizationController>(context, listen: false).isLtr;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CommissionInvoiceDetailsScreen(invoice: invoice),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeExtraSmall,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            ),
            color: cardColor,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge,
                    vertical: Dimensions.paddingSizeDefault,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'فاتورة العمولة الشهرية',
                              style: robotoBold.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),
                            Text(
                              'من ${invoice.periodStart ?? '-'} إلى ${invoice.periodEnd ?? '-'}',
                              style: robotoRegular.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall),
                            Text(
                              invoice.paymentStatus == 'paid'
                                  ? 'مدفوعة'
                                  : 'غير مدفوعة',
                              style: robotoMedium.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            PriceConverter.convertPrice(
                                context, invoice.totalCommission),
                            style: robotoBold.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              fontSize: Dimensions.fontSizeOverlarge,
                            ),
                          ),
                          const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall),
                          Text(
                            'اضغط للتفاصيل',
                            style: robotoRegular.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withValues(alpha: .9),
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    isLtr ? const SizedBox.shrink() : const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.2,
                      height: 120,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).cardColor.withValues(alpha: .10),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(120),
                        ),
                      ),
                    ),
                    isLtr ? const Spacer() : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
