import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/controllers/models/receipt_model.dart';
import 'package:ppocket/controllers/reciept_controller.dart';

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
        title: const Text('Search Receipts'),
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
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                _searchController.searchReceiptsByDate(
                  userId: 'user_id_here', // Replace with actual user ID
                  searchText: dateController.text,
                );
              },
              child: const Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Obx(() {
                if (_searchController.loading) {
                  return const Center(child: CircularProgressIndicator());
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
    List<ReceiptModel> searchResults = _searchController.searchResults;
    if (searchResults.isEmpty) {
      return const Center(child: Text('No results found.'));
    } else {
      return ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Receipt ${index + 1}'),
            leading: Image.network(searchResults[index].imageUrl),
            // You can customize how you want to display the receipt details
          );
        },
      );
    }
  }
}