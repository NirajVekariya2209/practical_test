import 'package:flutter/material.dart';

class CommonDropdown<T> extends StatelessWidget {
  final String label;
  final List<T> items; // List of dropdown items
  final T? selectedItem; // Currently selected item
  final String hintText; // Placeholder text
  final void Function(T?) onChanged; // Callback when item is selected
  final String Function(T) itemToString; // Convert item to string for display

  const CommonDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.itemToString,
    this.selectedItem,
    this.hintText = "Select an option",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
          ),
          child: DropdownButton<T>(
            isExpanded: true,
            value: selectedItem,
            hint: Text(hintText),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                value: value,
                child: Text(itemToString(value), style: TextStyle(fontWeight: FontWeight.w600),),
              );
            }).toList(),
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }
}
