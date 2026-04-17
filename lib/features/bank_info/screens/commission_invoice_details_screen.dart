import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/features/bank_info/controllers/bank_info_controller.dart';
import 'package:sixvalley_vendor_app/features/bank_info/domain/models/current_commission_invoice_model.dart';
import 'package:sixvalley_vendor_app/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_vendor_app/features/chat/screens/chat_screen.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CommissionInvoiceDetailsScreen extends StatefulWidget {
  final CurrentCommissionInvoiceModel invoice;
  const CommissionInvoiceDetailsScreen({super.key, required this.invoice});

  @override
  State<CommissionInvoiceDetailsScreen> createState() =>
      _CommissionInvoiceDetailsScreenState();
}

class _CommissionInvoiceDetailsScreenState
    extends State<CommissionInvoiceDetailsScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BankInfoController>(
        builder: (context, bankInfoController, _) {
          final invoice =
              bankInfoController.currentMonthCommissionInvoice ?? widget.invoice;

          return Column(
            children: [
              const CustomAppBarWidget(title: 'تفاصيل فاتورة العمولة'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _heroCard(context, invoice),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Row(
                        children: [
                          Expanded(
                            child: _miniInfoCard(
                              context,
                              title: 'عدد الطلبات',
                              value: '${invoice.ordersCount}',
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                            child: _miniInfoCard(
                              context,
                              title: 'الحالة',
                              value: invoice.paymentStatus == 'paid'
                                  ? 'مدفوعة'
                                  : 'غير مدفوعة',
                              valueColor: invoice.paymentStatus == 'paid'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      _summaryCard(context, invoice),

                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      _adjustmentsCard(context, invoice),

                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      if (invoice.hasInvoice && invoice.paymentStatus != 'paid')
                        _receiptUploadCard(context, invoice),

                      if (invoice.paymentStatus == 'paid')
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(
                            Dimensions.paddingSizeDefault,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusDefault,
                            ),
                          ),
                          child: Text(
                            'تم تأكيد هذه الفاتورة كمدفوعة.',
                            style: robotoMedium.copyWith(color: Colors.green),
                          ),
                        ),

                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Provider.of<ChatController>(
                              context,
                              listen: false,
                            ).setUserTypeIndex(context, 2, isUpdate: false);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChatScreen(
                                  userId: 0,
                                  name: 'الإدارة',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('ارسال نموذج لاثبات الدفع '),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _heroCard(BuildContext context, CurrentCommissionInvoiceModel invoice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: .72),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: .20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الفاتورة الشهرية',
            style: robotoBold.copyWith(
              color: Colors.white,
              fontSize: Dimensions.fontSizeExtraLarge,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          Text(
            'من ${invoice.periodStart ?? '-'} إلى ${invoice.periodEnd ?? '-'}',
            style: robotoRegular.copyWith(
              color: Colors.white.withValues(alpha: .95),
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Text(
            PriceConverter.convertPrice(context, invoice.totalCommission),
            style: robotoBold.copyWith(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            invoice.paymentStatus == 'paid' ? 'حالة الفاتورة: مدفوعة' : 'حالة الفاتورة: غير مدفوعة',
            style: robotoMedium.copyWith(
              color: Colors.white.withValues(alpha: .96),
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: .05),
            spreadRadius: -3,
            blurRadius: 12,
            offset: Offset.fromDirection(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text(
            value,
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(BuildContext context, CurrentCommissionInvoiceModel invoice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: .05),
            spreadRadius: -3,
            blurRadius: 12,
            offset: Offset.fromDirection(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ملخص العمولة', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          _summaryRow(
            context,
            'عمولات الطلبات',
            PriceConverter.convertPrice(context, invoice.orderCommissionTotal),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          _summaryRow(
            context,
            'التسويات اليدوية',
            PriceConverter.convertPrice(context, invoice.manualAdjustmentTotal),
          ),
          const Divider(height: Dimensions.paddingSizeLarge),

          _summaryRow(
            context,
            'الإجمالي',
            PriceConverter.convertPrice(context, invoice.totalCommission),
            isTotal: true,
          ),

          if ((invoice.paymentNote ?? '').isNotEmpty) ...[
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Text(
                invoice.paymentNote!,
                style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: isTotal
                ? robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)
                : robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).hintColor,
                  ),
          ),
        ),
        Text(
          value,
          style: isTotal
              ? robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).primaryColor,
                )
              : robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                ),
        ),
      ],
    );
  }

  Widget _adjustmentsCard(BuildContext context, CurrentCommissionInvoiceModel invoice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: .05),
            spreadRadius: -3,
            blurRadius: 12,
            offset: Offset.fromDirection(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('التسويات اليدوية', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          if (invoice.adjustments.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeLarge,
                ),
                child: Text(
                  'لا توجد تسويات على هذه الفاتورة',
                  style: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            ),

          ...invoice.adjustments.map((adjustment) {
            final bool isAdd = adjustment.adjustmentType == 'add';

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: isAdd
                    ? Colors.green.withValues(alpha: .08)
                    : Colors.red.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAdd ? 'إضافة' : 'خصم',
                    style: robotoBold.copyWith(
                      color: isAdd ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text(PriceConverter.convertPrice(context, adjustment.amount)),
                  if ((adjustment.reason ?? '').isNotEmpty) ...[
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(adjustment.reason!),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _receiptUploadCard(BuildContext context, CurrentCommissionInvoiceModel invoice) {
    return Consumer<BankInfoController>(
      builder: (context, bankInfoController, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: .05),
                spreadRadius: -3,
                blurRadius: 12,
                offset: Offset.fromDirection(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إرسال وصل الدفع', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'أضف ملاحظة اختيارية مع الوصل',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              InkWell(
                onTap: bankInfoController.isSendingReceipt
                    ? null
                    : () => bankInfoController.pickCommissionReceiptImage(),
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: .04),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withValues(alpha: .18),
                    ),
                  ),
                  child: bankInfoController.selectedCommissionReceiptImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: Image.file(
                            File(bankInfoController.selectedCommissionReceiptImage!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 42,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            Text(
                              'اضغط لاختيار صورة الوصل',
                              style: robotoMedium.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              CustomButtonWidget(
                btnTxt: bankInfoController.isSendingReceipt ? 'جاري الإرسال...' : 'إرسال الوصل للإدارة',
                onTap: bankInfoController.isSendingReceipt
                    ? null
                    : () async {
                        if (!invoice.hasInvoice) {
                          showCustomSnackBarWidget('لا توجد فاتورة حالية للإرسال', context);
                          return;
                        }

                        final response = await bankInfoController.sendCommissionReceipt(
                          context,
                          invoiceId: invoice.id!,
                          note: _noteController.text.trim(),
                        );

                        if (response.isSuccess) {
                          _noteController.clear();
                          showCustomSnackBarWidget(
                            response.message ?? 'تم الإرسال',
                            context,
                            isError: false,
                          );
                        } else {
                          showCustomSnackBarWidget(
                            response.message ?? 'فشل الإرسال',
                            context,
                          );
                        }
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}