part of '../style.dart';

class _NIXOThemeFont {
  final TextStyle body = GoogleFonts.roboto().copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 14 * Responsive.fontResize,
    height: 25.2 / 14,
    //color: theme.color.b20,
  );

  final TextStyle bodyBold = GoogleFonts.roboto().copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 14 * Responsive.fontResize,
    height: 22.4 / 14,
    //color: theme.color.b20,
  );

  final TextStyle bigBold = GoogleFonts.roboto().copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 16 * Responsive.fontResize,
    height: 22.8 / 16,
    //color: theme.color.b20,
  );

  final TextStyle subTitle = GoogleFonts.roboto().copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 18 * Responsive.fontResize,
    height: 25.7 / 18,
    //color: theme.color.b20,
  );

  final TextStyle subTitleBold = GoogleFonts.roboto().copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 20 * Responsive.fontResize,
    height: 28.6 / 20,
    //color: theme.color.b20,
  );

  final TextStyle title = GoogleFonts.roboto().copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 24 * Responsive.fontResize,
    height: 34.3 / 24,
    //color: theme.color.b20,
  );

  final TextStyle note = GoogleFonts.roboto().copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 12 * Responsive.fontResize,
    height: 18 / 12,
    //color: theme.color.b20,
  );
}
