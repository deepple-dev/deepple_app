import 'package:image_picker/image_picker.dart';

List<XFile?> compactPhotos(List<XFile?> photos) {
  final nonNullPhotos = photos.where((photo) => photo != null).toList();
  final nullCount = photos.length - nonNullPhotos.length;
  return [...nonNullPhotos, ...List.filled(nullCount, null)];
}
