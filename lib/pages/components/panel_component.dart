// ignore_for_file: prefer_const_constructors

import 'package:auto_character_chooser/themes/images.dart';
import 'package:flutter/material.dart';

class MyPanelController {
  late VoidCallback openPanel;
  late VoidCallback closePanel;

  void dispose() {
    //Remove any data that's will cause a memory leak/render errors in here
  }
}

class MyPanel extends StatefulWidget {
  final MyPanelController? controller;
  final Function()? floatButtonPressed;
  final ImageProvider<Object>? profileImage;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? child;

  const MyPanel({
    Key? key,
    this.controller,
    this.floatButtonPressed,
    this.profileImage,
    this.title,
    this.subtitle,
    this.trailing,
    this.child,
  }) : super(key: key);

  @override
  State<MyPanel> createState() => _MyPanelState();
}

class _MyPanelState extends State<MyPanel> with TickerProviderStateMixin {
  DraggableScrollableController dragController =
      DraggableScrollableController();
  late AnimationController panelButtonController;
  double initialSize = 0;
  double minSize = 0;
  double maxChildSize = 0.5;

  @override
  void dispose() {
    super.dispose();

    panelButtonController.dispose();
  }

  @override
  void initState() {
    super.initState();

    panelButtonController =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);

    if (widget.controller != null) {
      MyPanelController controller = widget.controller!;
      controller.openPanel = openPanel;
      controller.closePanel = closePanel;
    }
  }

  double calculatePanelHeightRatio() {
    var OldRange = (maxChildSize - 0.15);
    var NewRange = 1;
    var NewValue = (((dragController.size - 0.15) * NewRange) / OldRange);
    return NewValue;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: dragController,
      initialChildSize: initialSize,
      maxChildSize: maxChildSize,
      minChildSize: minSize,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                controller: scrollController,
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () => {
                      openPanel(full: dragController.size < 0.2),
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: widget.profileImage,
                            ),
                            title: widget.title,
                            subtitle: widget.subtitle,
                            trailing: widget.trailing,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: AnimatedIcon(
                            icon: AnimatedIcons.close_menu,
                            progress: AnimationController(
                              value: 1 - calculatePanelHeightRatio(),
                              vsync: this,
                            ),
                            semanticLabel: 'Show menu',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: widget.child,
                  )
                ],
              ),
              FloatingActionButton(
                child: ImageIcon(
                  AssetImage(MyImages.shuffle),
                ),
                onPressed: widget.floatButtonPressed,
              ),
            ],
          ),
        );
      },
    );
  }

  void openPanel({bool full = false}) {
    var temp = 0.15;
    if (full) {
      temp = maxChildSize;
    }
    dragController
        .animateTo(temp,
            duration: Duration(milliseconds: 200), curve: Curves.easeInCubic)
        .then((value) => setState(() => {
              initialSize = temp,
              minSize = 0.15,
            }));
  }

  void closePanel() {
    minSize = 0;
    setState(() {});
    dragController
        .animateTo(0.00,
            duration: Duration(milliseconds: 200), curve: Curves.easeInCubic)
        .then((value) => setState(() => initialSize = 0));
  }
}
