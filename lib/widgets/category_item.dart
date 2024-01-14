import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
    this._imageUrl,
    this._title,
    this._color, {
    this.fit,
    this.alignment,
    super.key,
  });

  final String _imageUrl;
  final String _title;
  final Color _color;
  final AlignmentGeometry? alignment;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      // height: 210,
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 250),
      width: double.infinity,
      child: Card(
        color: ColorScheme.fromSeed(seedColor: _color, brightness: Theme.of(context).brightness).secondaryContainer,
        elevation: 6,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  _imageUrl,
                  fit: fit ?? BoxFit.cover,
                  alignment: alignment ?? Alignment.topCenter,
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
                  color: ColorScheme.fromSeed(seedColor: _color, brightness: Theme.of(context).brightness).secondary),
            ),
          ),
        ]),
      ),
    );
  }
}
