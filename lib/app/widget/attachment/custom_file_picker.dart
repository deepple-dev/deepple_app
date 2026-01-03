import 'package:deepple_app/core/state/base_widget_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:io';

class CustomFilePicker extends StatefulWidget {
  final bool readOnly;
  final bool expandLook;
  final Function(List<File> pickedFiles) onFilesPicked;

  const CustomFilePicker({
    super.key,
    this.readOnly = false,
    this.expandLook = true,
    required this.onFilesPicked,
  });

  @override
  FilePickerState createState() => FilePickerState();
}

class FilePickerState extends AppBaseWidgetState<CustomFilePicker> {
  List<PlatformFile>? _pickedFiles;
  List<File> _fileList = []; // 파일 객체를 담아두기 위한 리스트

  Future<void> _pickFiles() async {
    // readOnly가 true면 클릭해도 무반응
    if (widget.readOnly) {
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      // FileType.any를 다른 걸로 교체해 주면 특정 타입으로 제한할 수 있다.
      type: FileType.any,
    );

    if (result != null) {
      safeSetState(() {
        _pickedFiles = result.files;
        // Convert PlatformFile to File and add to _fileList
        _fileList = _pickedFiles!.map((pf) => File(pf.path!)).toList();
      });
      widget.onFilesPicked(_fileList); // Trigger callback with File list
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      color: widget.readOnly ? Colors.grey : palette.onSurface,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('첨부파일', style: style),
            const Gap(20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: palette.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha((0.5 * 255).round()),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${_pickedFiles?.length ?? 0}개',
                        style: style,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.readOnly ? null : _pickFiles,
                      icon: widget.readOnly
                          ? const Icon(Icons.chevron_right, color: Colors.grey)
                          : const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(20),
          ],
        ),
        const Gap(10),
        // Hide the Wrap with Chips if readOnly is true
        if (!widget.readOnly && _pickedFiles != null && !widget.expandLook)
          Wrap(
            spacing: 8.0,
            runSpacing: 5.0,
            children: _pickedFiles!.map((file) {
              return Chip(
                label: Text(file.name),
                onDeleted: () {
                  safeSetState(() {
                    _pickedFiles!.remove(file);
                  });
                },
              );
            }).toList(),
          ),
        if (!widget.readOnly && _pickedFiles != null && widget.expandLook)
          Column(
            children: _pickedFiles!.map((file) {
              return Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: palette.shadow.withAlpha((0.8 * 255).round()),
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(file.name),
                  trailing: widget.readOnly
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            safeSetState(() {
                              _pickedFiles!.remove(file);
                            });
                          },
                        ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
