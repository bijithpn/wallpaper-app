import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../utils/image_classifcation_helper.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  ImageClassificationHelper? imageClassificationHelper;
  final imagePicker = ImagePicker();
  String? imagePath;
  img.Image? image;
  Map<String, double>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    onPageLoad();
    super.initState();
  }

  // Clean old results when press some take picture button
  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    setState(() {});
  }

  // Process picked image
  Future<void> processImage() async {
    if (imagePath != null) {
      // Read image bytes from file
      final imageData = File(imagePath!).readAsBytesSync();

      // Decode image using package:image/image.dart (https://pub.dev/image)
      image = img.decodeImage(imageData);
      setState(() {});
      classification = await imageClassificationHelper?.inferenceImage(image!);
      setState(() {});
    }
  }

  onPageLoad() async {
    cleanResult();
    final result = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    imagePath = result?.path;
    setState(() {});
    processImage();
  }

  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Divider(color: Colors.black),
          Expanded(
              child: Stack(
            alignment: Alignment.center,
            children: [
              if (imagePath != null) Image.file(File(imagePath!)),
              if (image == null)
                TextButton.icon(
                  onPressed: () async {
                    cleanResult();
                    final result = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );

                    imagePath = result?.path;
                    setState(() {});
                    processImage();
                  },
                  icon: const Icon(
                    Icons.photo,
                    size: 48,
                  ),
                  label: const Text("Pick from gallery"),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(),
                  if (image != null) ...[
                    // Show model information
                    if (imageClassificationHelper?.inputTensor != null)
                      Text(
                        'Input: (shape: ${imageClassificationHelper?.inputTensor.shape} type: '
                        '${imageClassificationHelper?.inputTensor.type})',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    if (imageClassificationHelper?.outputTensor != null)
                      Text(
                        'Output: (shape: ${imageClassificationHelper?.outputTensor.shape} '
                        'type: ${imageClassificationHelper?.outputTensor.type})',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: 8),
                    // Show picked image information
                    Text(
                      'Num channels: ${image?.numChannels}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Bits per channel: ${image?.bitsPerChannel}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Height: ${image?.height}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Width: ${image?.width}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const Spacer(),
                  // Show classification result
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        if (classification != null)
                          ...(classification!.entries.toList()
                                ..sort(
                                  (a, b) => a.value.compareTo(b.value),
                                ))
                              .reversed
                              .take(3)
                              .map(
                                (e) => Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Theme.of(context).primaryColorDark,
                                  child: Row(
                                    children: [
                                      Text(
                                        e.key,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const Spacer(),
                                      Text(
                                        e.value.toStringAsFixed(2),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }
}
