import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jueves/theme/nothing_theme.dart';

class BackgroundWidget extends StatefulWidget {
  BackgroundWidget({Key? key}) : super(key: key);

  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: DotGridPainter())),
        Positioned.fill(
          child: Center(
            child: Opacity(
              opacity: 0.3,
              child: Text(
                'JUEVES',
                style: GoogleFonts.doto(
                  fontSize: 120,
                  fontWeight: FontWeight.w400,
                  color: NothingTheme.textDisplay,
                  letterSpacing: 8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NothingTheme.border
      ..style = PaintingStyle.fill;

    const spacing = 16.0;
    const dotRadius = 0.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
