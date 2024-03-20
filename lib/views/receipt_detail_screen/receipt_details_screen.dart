import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/models/transaction_model.dart';
import 'package:ppocket/controllers/receipt_details_controller.dart';
import 'package:ppocket/views/components/loading_widget.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  final TransactionModel transaction;

  const ReceiptDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final receiptDetailsController = Get.put(ReceiptDetailsController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Receipt Details',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Receipt Details'),
          ),
          FutureBuilder<String>(
            future: receiptDetailsController.getReceiptImageLink(
              transaction,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              }
              if (snapshot.hasError) {
                return const Text('Error');
              }
              return SizedBox(
                height: 300,
                width: 200,
                child: CachedNetworkImage(
                  imageUrl: snapshot.data!,
                  placeholder: (context, url) => const LoadingWidget(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
