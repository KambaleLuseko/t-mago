import 'package:flutter/material.dart';

import '../../Resources/Components/texts.dart';
import '../../Resources/Constants/global_variables.dart';
import 'empty_model.dart';

class SearchableTextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final Color textColor;
  final Color backColor;
  final Color? overlayColor;
  final bool? isEnabled;
  final bool? isObsCured;
  final TextEditingController editCtrller;
  int? maxLines = 1;
  int maxLength = 255;
  Function callback;
  List data;
  final String displayColumn, indexColumn;
  String? secondDisplayColumn, errorText = "Aucune donnée trouvée";

  SearchableTextFormFieldWidget(
      {Key? key,
      required this.hintText,
      required this.textColor,
      required this.backColor,
      required this.editCtrller,
      this.overlayColor,
      TextInputType? inputType,
      maxLength,
      this.maxLines,
      this.isEnabled,
      this.isObsCured,
      required this.callback,
      required this.data,
      required this.displayColumn,
      this.secondDisplayColumn,
      required this.indexColumn,
      this.errorText})
      : super(key: key);

  @override
  _SearchableTextFormFieldWidgetState createState() =>
      _SearchableTextFormFieldWidgetState();
}

class _SearchableTextFormFieldWidgetState
    extends State<SearchableTextFormFieldWidget> {
  List searchedData = [];
  final layerLink = LayerLink();
  final focusNode = FocusNode();

  @override
  void initState() {
    searchedData =
        widget.data.length > 20 ? widget.data.sublist(0, 20) : widget.data;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // showOverlay();
      widget.editCtrller.addListener(() {
        if (widget.editCtrller.text.isEmpty) {
          searchedData = widget.data;
        } else {
          if (widget.secondDisplayColumn != null) {
            searchedData = widget.data.where((element) {
              return element[widget.displayColumn]
                      .toString()
                      .toLowerCase()
                      .contains(widget.editCtrller.text.toLowerCase().trim()) ||
                  element[widget.secondDisplayColumn!]
                      .toString()
                      .toLowerCase()
                      .contains(widget.editCtrller.text.toLowerCase().trim());
            }).toList();
            return;
          }
          searchedData = widget.data.where((element) {
            return element[widget.displayColumn]
                .toString()
                .toLowerCase()
                .contains(widget.editCtrller.text.toLowerCase().trim());
          }).toList();
        }
      });
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          searchedData = widget.data;
          showOverlay();
        } else {
          removeOverlay();
        }
      });
    });
  }

  OverlayEntry? entry;

  showOverlay() {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    // print(offset.dy);
    // print(MediaQuery.of(context).size.height);
    entry = OverlayEntry(
        builder: (context) => Positioned(
            // left: offset.dx,
            // top: offset.dy + size.height + 8,
            // bottom: 0,
            width: size.width - 20,
            // height: ((MediaQuery.of(context).size.height - offset.dy) - 72),
            child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: const Offset(0, 48),
                link: layerLink,
                child: buildOverlay(
                  height: ((MediaQuery.of(context).size.height - offset.dy) -
                              72) <
                          100
                      ? 100
                      : ((MediaQuery.of(context).size.height - offset.dy) - 72),
                ))));
    overlay.insert(entry!);
  }

  buildOverlay({double? height = 100}) {
    return Material(
      elevation: 8,
      color: widget.overlayColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 10, maxHeight: height!),
        child: widget.data.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: searchedData.length,
                itemBuilder: (context, int index) {
                  return Card(
                    color: AppColors.kScaffoldColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      onTap: () {
                        // print(searchedData);
                        widget.callback(searchedData[index]);
                        widget.editCtrller.text =
                            "${searchedData[index][widget.displayColumn]} ${widget.secondDisplayColumn != null ? " - ${searchedData[index][widget.secondDisplayColumn]}" : ''}";

                        removeOverlay();
                        focusNode.unfocus();
                      },
                      title: TextWidgets.textBold(
                          maxLines: 2,
                          title:
                              "${searchedData[index][widget.displayColumn]} ${widget.secondDisplayColumn != null ? " - ${searchedData[index][widget.secondDisplayColumn]}" : ''}",
                          fontSize: 14,
                          textColor: widget.textColor),
                    ),
                  );
                })
            : EmptyModel(
                color: widget.textColor.withOpacity(0.5),
                text: widget.errorText,
              ),
      ),
    );
  }

  removeOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  void dispose() {
    super.dispose();
    entry?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   widget.hintText,
          //   style: TextStyle(color: widget.textColor.withOpacity(0.6)),
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
          Container(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            decoration: BoxDecoration(
                color: widget.backColor,
                borderRadius: BorderRadius.circular(kDefaultPadding / 4)),
            child: CompositedTransformTarget(
              link: layerLink,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kDefaultPadding / 4),
                child: TextFormField(
                  focusNode: focusNode,
                  maxLines: widget.maxLines,
                  style: TextStyle(color: widget.textColor),
                  textAlign: TextAlign.left,
                  controller: widget.editCtrller,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    hintText: widget.hintText,
                    hintStyle:
                        TextStyle(color: widget.textColor.withOpacity(0.5)),
                    label: TextWidgets.text300(
                        title: widget.hintText,
                        fontSize: 12,
                        textColor: widget.textColor.withOpacity(1)),
                    border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: widget.textColor, width: 1)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: widget.textColor, width: 3)),
                    // hintText: widget.hintText,
                    // hintStyle:
                    //     TextStyle(color: widget.textColor.withOpacity(0.5))
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
