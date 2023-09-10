import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModifiedText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final FontWeight fontWeight;
  const ModifiedText({
    super.key,
    required this.text,
    required this.color,
    required this.size,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      overflow: TextOverflow.fade,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: size,
      ),
      maxLines: 2,
    );
  }
}

class HeaderText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  const HeaderText({
    super.key,
    required this.text,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      overflow: TextOverflow.fade,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: size,
      ),
    );
  }
}
