import 'package:flutter/material.dart';
import 'package:practical_test/core/strings.dart';
import '../../core/app_color.dart';
import 'Signature_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allItemsList;
  const OrderDetailsScreen({super.key, required this.allItemsList});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Text(
          appStrings.orderDetails,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appStrings.coastHolywood,
                  style: TextStyle(fontWeight: FontWeight.bold,),
                ),
                Text(
                  appStrings.discount4,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: AppColor.primaryColor),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              defaultColumnWidth: IntrinsicColumnWidth(),
              border: TableBorder.all(),
              children: [
                _buildTableHeader(),
                ..._buildDataRows(),
                _buildTotalRow(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBarWidget(),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.black54,
      ),
      children: [
        _buildCell(appStrings.name, isHeader: true,),
        _buildCell(appStrings.qty, isHeader: true),
        _buildCell(appStrings.unitPrice, isHeader: true),
        _buildCell(appStrings.totalPrice, isHeader: true),
        _buildCell(appStrings.netPrice, isHeader: true),
      ],
    );
  }

  List<TableRow> _buildDataRows() {
    return widget.allItemsList.map((item) {
      // Extracting values from the Map
      String name = item['name'] ?? 'Unknown';
      int qty = item['qty'] ?? 0;
      double price = item['price'] ?? 0.0;
      double netPrice = item['price'] != null ? item['price'] * qty - item['price'] * 0.04 : 0.0;

      return TableRow(
        children: [
          _buildCell(name),
          _buildCell(qty.toString()),
          _buildCell('${price.toStringAsFixed(2)}'),
          _buildCell('${(qty * price).toStringAsFixed(2)}'),  // Total Price
          _buildCell('${netPrice.toStringAsFixed(2)}'),
        ],
      );
    }).toList();
  }

  TableRow _buildTotalRow() {
    final totalQty = widget.allItemsList.fold<dynamic>(0, (sum, item) {
      return sum + (item['qty'] ?? 0);
    });

    final totalInitPrice = widget.allItemsList.fold<double>(0.0, (sum, item) {
      return sum + (item['price'] ?? 0.0);
    });

    final totalPrice = widget.allItemsList.fold<double>(0.0, (sum, item) {
      double price = item['price'] ?? 0.0;
      int qty = item['qty'] ?? 0;

      return sum + (price * qty);
    });

    final totalNetPrice = widget.allItemsList.fold<double>(0.0, (sum, item) {
      double price = item['price'] ?? 0.0;
      int qty = item['qty'] ?? 0;

      double discountAmount = price * 0.04;

      double netPrice = price - discountAmount;

      return sum + (netPrice * qty);
    });


    return TableRow(
      children: [
        _buildCell(appStrings.total, isHeader: true),
        _buildCell(totalQty.toString()),
        _buildCell('${totalInitPrice.toStringAsFixed(2)}'),
        _buildCell('${totalPrice.toStringAsFixed(2)}'),
        _buildCell('${totalNetPrice.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildCell(String text, {bool isHeader = false}) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget bottomNavigationBarWidget() {
    return BottomAppBar(
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignatureScreen()));
              },
              child: Text(appStrings.signature, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey))),
          GestureDetector(
              onTap: () {},
              child: signature == null ?
              Container(
                width: 100,
                color: Colors.white,
              ) :
              Image.memory(signature)
          ),
        ],
      ),
    );
  }
}

