import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryItem extends StatelessWidget {
  final String _imageUrl;
  final String _title;
  final Color _color;
  const CategoryItem(this._imageUrl, this._title, this._color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      // height: 210,
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 250),
      width: double.infinity,
      child: Card(
        color: ColorScheme.fromSeed(seedColor: _color).secondaryContainer,
        elevation: 6,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: 150,
            width: double.infinity,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  _imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              _title,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ColorScheme.fromSeed(seedColor: _color).secondary),
            ),
          ),
        ]),
      ),
    );
  }
}
