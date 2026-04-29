class CommissionAdjustmentModel {
  int? id;
  String? adjustmentType;
  double amount;
  String? reason;
  String? createdAt;

  CommissionAdjustmentModel({
    this.id,
    this.adjustmentType,
    this.amount = 0,
    this.reason,
    this.createdAt,
  });

  factory CommissionAdjustmentModel.fromJson(Map<String, dynamic> json) {
    return CommissionAdjustmentModel(
      id: json['id'],
      adjustmentType: json['adjustment_type'],
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      reason: json['reason'],
      createdAt: json['created_at'],
    );
  }
}

class CurrentCommissionInvoiceModel {
  int? id;
  int invoiceYear;
  int invoiceMonth;
  String? periodStart;
  String? periodEnd;
  int ordersCount;
  double orderCommissionTotal;
  double manualAdjustmentTotal;
  double totalCommission;
  String paymentStatus;
  String? paidAt;
  String? paymentNote;
  List<CommissionAdjustmentModel> adjustments;

  CurrentCommissionInvoiceModel({
    this.id,
    this.invoiceYear = 0,
    this.invoiceMonth = 0,
    this.periodStart,
    this.periodEnd,
    this.ordersCount = 0,
    this.orderCommissionTotal = 0,
    this.manualAdjustmentTotal = 0,
    this.totalCommission = 0,
    this.paymentStatus = 'unpaid',
    this.paidAt,
    this.paymentNote,
    this.adjustments = const [],
  });

  bool get hasInvoice => id != null;

  factory CurrentCommissionInvoiceModel.fromJson(Map<String, dynamic> json) {
    return CurrentCommissionInvoiceModel(
      id: json['id'],
      invoiceYear: int.tryParse(json['invoice_year'].toString()) ?? 0,
      invoiceMonth: int.tryParse(json['invoice_month'].toString()) ?? 0,
      periodStart: json['period_start'],
      periodEnd: json['period_end'],
      ordersCount: int.tryParse(json['orders_count'].toString()) ?? 0,
      orderCommissionTotal:
          double.tryParse(json['order_commission_total'].toString()) ?? 0,
      manualAdjustmentTotal:
          double.tryParse(json['manual_adjustment_total'].toString()) ?? 0,
      totalCommission:
          double.tryParse(json['total_commission'].toString()) ?? 0,
      paymentStatus: json['payment_status'] ?? 'unpaid',
      paidAt: json['paid_at'],
      paymentNote: json['payment_note'],
      adjustments: (json['adjustments'] as List<dynamic>? ?? [])
          .map((e) => CommissionAdjustmentModel.fromJson(e))
          .toList(),
    );
  }
}
