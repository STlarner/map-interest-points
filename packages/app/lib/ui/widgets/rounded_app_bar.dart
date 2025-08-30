import "package:flutter/material.dart";

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RoundedAppBar({
    super.key,
    this.height = 120,
    this.backgroundColor = Colors.grey,
    this.title,
  });

  final double height;
  final Color backgroundColor;
  final Widget? title;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RoundPainter(),
      child: Container(
        height: height,
        alignment: Alignment.center,
        child: title,
      ),
    );
  }
}

class _RoundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double cornerRadius = 24;

    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0); // top-left
    path.lineTo(size.width, 0); // top-right

    path.lineTo(
      size.width,
      size.height + cornerRadius,
    ); // down to end of bottom-right curve

    path.quadraticBezierTo(
      size.width - cornerRadius / 2,
      size.height,
      size.width - cornerRadius,
      size.height,
    ); // bottom-right curve

    path.lineTo(cornerRadius, size.height); //start of bottom-left curve
    path.quadraticBezierTo(
      cornerRadius / 2,
      size.height,
      0,
      size.height + cornerRadius,
    ); // bottom-left curve

    path.lineTo(0, 0); // back up to start of left side

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
