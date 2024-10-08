import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ParallaxSwiper extends StatefulWidget {
  const ParallaxSwiper({
    super.key,
    required this.images,
    this.dragToScroll = true,
    this.viewPortFraction = 1,
    this.padding = const EdgeInsets.all(8.0),
    this.parallaxFactor = 10.0,
    this.foregroundFadeEnabled = true,
    this.backgroundZoomEnabled = true,
  });

  final List<String> images;

  final bool dragToScroll;

  final double viewPortFraction;

  final EdgeInsets padding;

  final double parallaxFactor;

  final bool foregroundFadeEnabled;

  final bool backgroundZoomEnabled;

  @override
  State<ParallaxSwiper> createState() => _ParallaxSwiperState();
}

class _ParallaxSwiperState extends State<ParallaxSwiper> {
  late final PageController controller;

  double pageIndex = 0.0;

  void _indexChangeListener() {
    setState(() => pageIndex = controller.page!);
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(
      viewportFraction: widget.viewPortFraction,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addListener(_indexChangeListener);
    });
  }

  @override
  void dispose() {
    controller
      ..removeListener(_indexChangeListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior:
          widget.dragToScroll ? DragScrollBehavior() : const ScrollBehavior(),
      child: PageView.builder(
        controller: controller,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          double value =
              controller.position.haveDimensions ? pageIndex - index : 0;

          return InkWell(
            onTap: () {},
            child: _SwiperItem(
              image: widget.images[index],
              value: value,
              padding: widget.padding,
              parallaxFactor: widget.parallaxFactor,
              foregroundFadeEnabled: widget.foregroundFadeEnabled,
              backgroundZoomEnabled: widget.backgroundZoomEnabled,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Item $index',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SwiperItem extends StatelessWidget {
  const _SwiperItem({
    required this.image,
    required this.parallaxFactor,
    required this.value,
    required this.padding,
    this.child,
    this.foregroundFadeEnabled = true,
    this.backgroundZoomEnabled = true,
  });

  final String image;

  final double parallaxFactor;

  final double value;

  final EdgeInsets padding;

  final Widget? child;

  final bool foregroundFadeEnabled;

  final bool backgroundZoomEnabled;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(200.0, 500.0);

    final tween = Tween<double>(begin: 0.0, end: 1.0).transform(value);

    final foregroundOffset = Offset(-(tween * pow(parallaxFactor, 2.2)), 0);

    final foregroundOpacity =
        foregroundFadeEnabled ? 1 - tween.clamp(0.0, 1.0) : 1.0;

    final backgroundOffset = Offset(tween * pow(parallaxFactor, 2), 0);

    final scale =
        backgroundZoomEnabled ? 1.0 + (value.abs() * 0.15) * 1.1 : 1.0;

    return Container(
      padding: padding,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Transform.translate(
              offset: backgroundOffset,
              child: Transform.scale(
                scale: 1.2 * scale,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Image.network(
                    image,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    fit: BoxFit.cover,
                  );
                }),
              ),
            ),
            if (child != null)
              AnimatedOpacity(
                opacity: foregroundOpacity,
                duration: const Duration(milliseconds: 100),
                child: Transform.translate(
                  offset: foregroundOffset,
                  child: child,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
