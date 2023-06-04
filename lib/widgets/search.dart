import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchDialog extends StatelessWidget {
  SearchDialog({required this.onSearch, this.hintText, this.initValue, super.key});

  Function(String) onSearch;
  String? hintText;
  String? initValue;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (initValue != null) _searchController.text = initValue!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(50)),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              onFieldSubmitted: (value) {
                onSearch(_searchController.text);
              },
              textInputAction: TextInputAction.search,
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration.collapsed(
                  hintText: hintText ?? 'Search here...',
                  hintStyle: GoogleFonts.raleway(fontWeight: FontWeight.bold)),
            ),
          ),
          Transform.translate(
            offset: const Offset(10, 0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                onSearch(_searchController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
