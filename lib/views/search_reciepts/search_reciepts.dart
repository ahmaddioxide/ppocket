import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/reciept_controller.dart';
import 'package:ppocket/theme/app_colors.dart';
import 'package:ppocket/views/components/loading_widget.dart';
import 'package:ppocket/views/receipt_detail_screen/receipt_details_screen.dart';

import '../../controllers/models/transaction_model.dart';

class SearchReceipts extends StatelessWidget {
  final SearchReceiptController _searchController =
      Get.put(SearchReceiptController());

  SearchReceipts({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController();

    Future<void> selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.blue, // Adjust primary color as needed
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedDate != null) {
        dateController.text = pickedDate.toString().substring(0, 10);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Search Receipts',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Select Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
              ),
              onPressed: () {
                _searchController.searchReceiptsByDate(
                  searchText: dateController.text,
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 8.0),
                  Icon(Icons.search, color: Colors.white, size: 20.0),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 2,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Obx(() {
                if (_searchController.loading) {
                  return const Center(child: LoadingWidget());
                } else if (_searchController.error.isNotEmpty) {
                  return Center(child: Text(_searchController.error));
                } else {
                  return _buildSearchResults();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    List<TransactionModel> searchResults = _searchController.searchResults;
    if (searchResults.isEmpty) {
      return const Center(child: Text('No results found.'));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 4,
            child: ListTile(
              onTap: () {
                Get.to(
                  () => ReceiptDetailsScreen(
                    transaction: searchResults[index],
                  ),
                );
              },
              title: Text('Receipt ${index + 1}'),
              subtitle: Text(
                'Total: ${searchResults[index].amount.toString()}',
              ),
              trailing: Text(
                searchResults[index].date.toDate().toString().substring(0, 10),
              ),
            ),
          );
        },
      );
    }
  }
}
