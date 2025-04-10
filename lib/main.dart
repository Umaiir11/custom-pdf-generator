import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'model.dart';

void main() {
  Get.put(InvoiceController()); // Initialize the controller
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Modern PDF Invoice Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const InvoiceInputScreen(),
    );
  }
}

class InvoiceInputScreen extends StatelessWidget {
  const InvoiceInputScreen({Key? key}) : super(key: key);

  // Define _buildTextField as a class method
  Widget _buildTextField(
      String label,
      Function(String) onChanged, {
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  // Define _buildItemFields as a class method
  Widget _buildItemFields(InvoiceItem item, InvoiceController controller) {
    return Column(
      children: [
        _buildTextField(
          'Description',
              (value) {
            final index = controller.items.indexOf(item);
            controller.items[index] = InvoiceItem(
                description: value, price: item.price, quantity: item.quantity);
            controller.updateInvoice();
          },
          maxLines: 2,
          validator: (value) =>
          value!.isEmpty ? 'Please enter Description' : null,
        ),
        _buildTextField(
          'Price',
              (value) {
            final index = controller.items.indexOf(item);
            controller.items[index] = InvoiceItem(
                description: item.description,
                price: double.tryParse(value) ?? 0.0,
                quantity: item.quantity);
            controller.updateInvoice();
          },
          keyboardType: TextInputType.number,
          validator: (value) => value!.isEmpty
              ? 'Please enter Price'
              : double.tryParse(value) == null
              ? 'Please enter a valid number'
              : null,
        ),
        _buildTextField(
          'Quantity',
              (value) {
            final index = controller.items.indexOf(item);
            controller.items[index] = InvoiceItem(
                description: item.description,
                price: item.price,
                quantity: int.tryParse(value) ?? 0);
            controller.updateInvoice();
          },
          keyboardType: TextInputType.number,
          validator: (value) => value!.isEmpty
              ? 'Please enter Quantity'
              : int.tryParse(value) == null
              ? 'Please enter a valid integer'
              : null,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final InvoiceController controller = Get.find();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade800,
              Colors.indigo.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Invoice Details',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Company Name',
                        (value) => controller.updateInvoice(companyName: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Company Name' : null,
                  ),
                  _buildTextField(
                    'Company Tagline',
                        (value) => controller.updateInvoice(companyTagline: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Company Tagline' : null,
                  ),
                  _buildTextField(
                    'Company Email',
                        (value) => controller.updateInvoice(companyEmail: value),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter Company Email'
                        : !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
                        ? 'Please enter a valid email'
                        : null,
                  ),
                  _buildTextField(
                    'Invoice Number',
                        (value) => controller.updateInvoice(invoiceNumber: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Invoice Number' : null,
                  ),
                  _buildTextField(
                    'Issue Date (YYYY-MM-DD)',
                        (value) => controller.updateInvoice(issueDate: value),
                    keyboardType: TextInputType.datetime,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter Issue Date'
                        : !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)
                        ? 'Please enter date in YYYY-MM-DD format'
                        : null,
                  ),
                  _buildTextField(
                    'Client Name',
                        (value) => controller.updateInvoice(clientName: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Client Name' : null,
                  ),
                  _buildTextField(
                    'Client Address',
                        (value) => controller.updateInvoice(clientAddress: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Client Address' : null,
                  ),
                  _buildTextField(
                    'Client Phone',
                        (value) => controller.updateInvoice(clientPhone: value),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Client Phone' : null,
                  ),
                  _buildTextField(
                    'Client Email',
                        (value) => controller.updateInvoice(clientEmail: value),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter Client Email'
                        : !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
                        ? 'Please enter a valid email'
                        : null,
                  ),
                  _buildTextField(
                    'Account Number',
                        (value) => controller.updateInvoice(accountNumber: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Account Number' : null,
                  ),
                  _buildTextField(
                    'Bank Code',
                        (value) => controller.updateInvoice(bankCode: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Bank Code' : null,
                  ),
                  _buildTextField(
                    'Branch Name',
                        (value) => controller.updateInvoice(branchName: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Branch Name' : null,
                  ),
                  _buildTextField(
                    'Description',
                        (value) => controller.updateInvoice(description: value),
                    maxLines: 3,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Description' : null,
                  ),
                  const SizedBox(height: 20),
                  const Text('Items',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Obx(() => Column(
                    children: controller.items
                        .map((item) => _buildItemFields(item, controller))
                        .toList(),
                  )),
                  TextButton.icon(
                    onPressed: () {
                      controller.addItem('', 0.0, 0); // Add empty item
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Item',
                        style: TextStyle(color: Colors.white)),
                  ),
                  _buildTextField(
                    'Terms & Conditions',
                        (value) =>
                        controller.updateInvoice(termsAndConditions: value),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter Terms & Conditions'
                        : null,
                  ),
                  _buildTextField(
                    'Signature Name',
                        (value) => controller.updateInvoice(signatureName: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Signature Name' : null,
                  ),
                  _buildTextField(
                    'Signature Title',
                        (value) => controller.updateInvoice(signatureTitle: value),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter Signature Title' : null,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          controller.generatePDF();
                        }
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('GENERATE INVOICE'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.indigo.shade800,
                        backgroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        elevation: 8,
                        shadowColor: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}