import 'package:flutter/material.dart';

class MyPanel extends StatefulWidget {
  const MyPanel({Key? key}) : super(key: key);

  @override
  State<MyPanel> createState() => _MyPanelState();
}

class _MyPanelState extends State<MyPanel> with TickerProviderStateMixin {
  DraggableScrollableController dragController =
      DraggableScrollableController();
  late TabController _tabController;

  @override
  void dispose() {
    super.dispose();

    panelButtonController.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    panelButtonController =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);
  }

  late AnimationController panelButtonController;
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
                physics: AlwaysScrollableScrollPhysics(),
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
                              backgroundImage: CachedNetworkImageProvider(
                                agent.displayIcon,
                                maxHeight: 100,
                                maxWidth: 100,
                              ),
                            ),
                            title: Text(agent.displayName),
                            subtitle: Text(agent.role.displayName),
                            trailing: Icon(Icons.more_vert),
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
                    alignment: Alignment.centerLeft,
                    width: 100,
                    height: 5,
                    color: Colors.amber,
                  ),
                  // give the tab bar a height [can change hheight to preferred height]
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: BoxDecoration(
                        color: Colors.amber,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          icon: CachedNetworkImage(
                            imageUrl: agent.role.displayIcon,
                          ),
                        ),

                        // second tab [you can add an icon using the icon property]
                        for (var i in agent.ability)
                          Tab(
                            icon: CachedNetworkImage(
                              imageUrl: i.displayIcon,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // tab bar view here
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5))),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // first tab bar view widget
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                agent.description,
                              ),
                            ),
                            Text(
                              agent.role.displayName,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                agent.role.description,
                              ),
                            ),
                          ],
                        ),

                        for (var i in agent.ability)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                i.displayName,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  i.description,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              FloatingActionButton(
                  child: ImageIcon(
                    AssetImage(MyImages.shuffle),
                  ),
                  onPressed: () {
                    spinWheel();
                  }),
            ],
          ),
        );
      },
    );
  }
}
