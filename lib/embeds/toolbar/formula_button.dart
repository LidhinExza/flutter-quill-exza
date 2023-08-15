import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:math_keyboard/math_keyboard.dart';
import '../custom_embed.dart';

class FormulaButton extends StatelessWidget {
  const FormulaButton({
    required this.icon,
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.fillColor,
    this.iconTheme,
    this.dialogTheme,
    this.tooltip,
    this.focusNode,
    Key? key,
  }) : super(key: key);

  final IconData icon;

  final double iconSize;

  final Color? fillColor;

  final QuillController controller;

  final QuillIconTheme? iconTheme;
  final FocusNode? focusNode;
  final QuillDialogTheme? dialogTheme;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor =
        iconTheme?.iconUnselectedFillColor ?? (fillColor ?? theme.canvasColor);

    return QuillIconButton(
      icon: Icon(icon, size: iconSize, color: iconColor),
      tooltip: tooltip,
      highlightElevation: 0,
      hoverElevation: 0,
      size: iconSize * 1.77,
      fillColor: iconFillColor,
      borderRadius: iconTheme?.borderRadius ?? 2,
      onPressed: () => _returnPopup(context),
    );
  }

  MathField _mathField() {
    final mathcontroller = MathFieldEditingController();
    final _focus = FocusNode();
    _focus.requestFocus();
    return MathField(
      focusNode: _focus,
      controller: mathcontroller,
      autofocus: true,
      variables: const ['x', 'y', 'z'],
      decoration: InputDecoration(
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(),
        disabledBorder: _border(),
        errorBorder: _border(),
      ),
      onChanged: (value) {
        final offset =
            getEmbedNode(controller, controller.selection.start).offset;
        controller.replaceText(
          offset,
          1,
          RewiseTexBlockEmbed.fromString(value),
          TextSelection.collapsed(offset: offset),
        );
        debugPrint(
            'SELECTION NEW OLD ${mathcontroller.currentNode.courserPosition}');
      },
      onSubmitted: (value) {
        final offset =
            getEmbedNode(controller, controller.selection.start).offset;
        controller.replaceText(
          offset,
          1,
          RewiseTexBlockEmbed.fromString(value),
          TextSelection.collapsed(offset: offset),
        );
      },
    );
  }

  Future _returnPopup(BuildContext context) {
    final mathcontroller = MathFieldEditingController();
    final _focus = FocusNode();
    var values = '';
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        minHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      elevation: 3,
      builder: (context) => Container(
        height: MediaQuery.sizeOf(context).height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  debugPrint('ALL THE VALUE $values');
                  if (values != '') {
                    final offset = getEmbedNode(
                            controller, controller.selection.affinity.index)
                        .offset;
                    debugPrint('SELECTION NEW $offset');

                    controller.replaceText(
                        offset,
                        1,
                        RewiseTexBlockEmbed.fromString(values),
                        TextSelection.collapsed(offset: offset));
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              MathField(
                focusNode: _focus,
                controller: mathcontroller,
                autofocus: true,
                variables: const ['x', 'y', 'z'],
                decoration: InputDecoration(
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                  disabledBorder: _border(),
                  errorBorder: _border(),
                ),
                onChanged: (value) {
                  values = value;
                },
                onSubmitted: (value) {
                  values = value;
                  try {
                    final offset =
                        getEmbedNode(controller, controller.selection.start)
                            .offset;
                    debugPrint('OFFSET VALUES $offset');
                    controller.replaceText(
                      offset,
                      1,
                      RewiseTexBlockEmbed.fromString(value),
                      TextSelection.collapsed(offset: offset),
                    );
                  } catch (e) {
                    controller.document.insert(
                      0,
                      RewiseTexBlockEmbed.fromString(value),
                    );
                    controller.updateSelection(
                        const TextSelection.collapsed(offset: 0),
                        ChangeSource.LOCAL);
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border() {
    return const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    controller.document.insert(index, '\n');
    controller.replaceText(
      index,
      length,
      RewiseTexBlockEmbed.fromString(''),
      null,
    );
    final offset = getEmbedNode(controller, controller.selection.start).offset;
  }
}
