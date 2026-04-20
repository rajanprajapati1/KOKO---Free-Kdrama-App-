import 'dart:io';
import 'package:image/image.dart' as img;

void main(List<String> args) {
  final inputPath = 'ui/5f5bd00e-0027-42fb-9c91-fa55de3488fa.jpg';
  final outputPath = 'ui/koko_icon.png';

  print('Starting background removal process...');
  final file = File(inputPath);
  if (!file.existsSync()) {
    print('File not found: $inputPath');
    return;
  }

  final imageBytes = file.readAsBytesSync();
  final image = img.decodeImage(imageBytes);

  if (image == null) {
    print('Could not decode image');
    return;
  }

  // Convert to an image that supports an alpha channel if it doesn't already
  if (image.numChannels < 4) {
    // Already has alpha or needs conversion
  }

  for (final pixel in image) {
    final r = pixel.r;
    final g = pixel.g;
    final b = pixel.b;

    // Tolerance for white background
    if (r > 230 && g > 230 && b > 230) {
      // Set alpha to 0 (transparent) for white-ish pixels
      pixel.setRgba(r, g, b, 0);
    }
  }

  final pngBytes = img.encodePng(image);
  File(outputPath).writeAsBytesSync(pngBytes);
  print('Successfully saved transparent icon to $outputPath');
}
