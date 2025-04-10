class InvoiceModel {
  final String companyName;
  final String companyTagline;
  final String companyEmail;
  final String invoiceNumber;
  final String issueDate;
  final String clientName;
  final String clientAddress;
  final String clientPhone;
  final String clientEmail;
  final String accountNumber;
  final String bankCode;
  final String branchName;
  final String description;
  final List<InvoiceItem> items;
  final String termsAndConditions;
  final String signatureName;
  final String signatureTitle;

  InvoiceModel({
    required this.companyName,
    required this.companyTagline,
    required this.companyEmail,
    required this.invoiceNumber,
    required this.issueDate,
    required this.clientName,
    required this.clientAddress,
    required this.clientPhone,
    required this.clientEmail,
    required this.accountNumber,
    required this.bankCode,
    required this.branchName,
    required this.description,
    required this.items,
    required this.termsAndConditions,
    required this.signatureName,
    required this.signatureTitle,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get tax => 0; // Modify if you want tax
  double get total => subtotal + tax;
}

class InvoiceItem {
  final String description;
  final double price;
  final int quantity;

  InvoiceItem({
    required this.description,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;
}