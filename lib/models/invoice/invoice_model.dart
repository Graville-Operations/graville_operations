// models/invoice/invoice_model.dart

class InvoiceItemModel {
  final int id;
  final String particular;
  final double quantity;
  final double unitPrice;
  final double totalPrice;

  InvoiceItemModel({
    required this.id,
    required this.particular,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id'] ?? 0,
      particular: json['particular'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
    );
  }
}

class InvoiceModel {
  final int id;
  final String invoiceNumber;
  final String lpoNumber;
  final String deliveryNumber;
  final String supplierName;
  final String invoiceDate;
  final double totalAmount;
  final double amountPaid;
  final double balance;
  final String status;
  final String? site;
  final String? submittedBy;
  final int submittedById;
  final String? notes;
  final String? createdAt;
  final List<InvoiceItemModel> items;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.lpoNumber,
    required this.deliveryNumber,
    required this.supplierName,
    required this.invoiceDate,
    required this.totalAmount,
    required this.amountPaid,
    required this.balance,
    required this.status,
    this.site,
    this.submittedBy,
    required this.submittedById,
    this.notes,
    this.createdAt,
    required this.items,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] ?? 0,
      invoiceNumber: json['invoice_number'] ?? '',
      lpoNumber: json['lpo_number'] ?? '',
      deliveryNumber: json['delivery_number'] ?? '',
      supplierName: json['supplier_name'] ?? '',
      invoiceDate: json['invoice_date'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      amountPaid: (json['amount_paid'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
      site: json['site'],
      submittedBy: json['submitted_by'],
      submittedById: json['submitted_by_id'] ?? 0,
      notes: json['notes'],
      createdAt: json['created_at'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => InvoiceItemModel.fromJson(e))
          .toList(),
    );
  }
}