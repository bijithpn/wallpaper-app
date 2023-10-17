import 'package:flutter/material.dart';

class WallpaperItemWIdget extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final VoidCallback function;
  const WallpaperItemWIdget({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        child: InkWell(
            onTap: function,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color.withOpacity(.5)),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
