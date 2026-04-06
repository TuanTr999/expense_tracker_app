import 'package:expense_tracker_app/core/utils/current_date.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({super.key, required this.selected});

  final int selected;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  DateTime currentDate = DateTime.now();

  int currentOffset = 0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFF5F5F5),
      title: Row(
        mainAxisAlignment: (widget.selected != 3 && widget.selected != 4)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (widget.selected != 3 && widget.selected != 4)
            Material(
              color: Colors.white,
              shape: CircleBorder(),
              child: InkWell(
                onTap: () {
                  setState(() {
                    currentOffset = 1;
                  });
                  switch (widget.selected) {
                    case 0:
                      setState(() {
                        currentDate = currentDate.subtract(Duration(days: 1));
                        currentOffset = 1;
                      });
                      break;
                    case 1:
                      setState(() {
                        currentDate = DateTime(
                          currentDate.year,
                          currentDate.month - 1,
                          currentDate.day,
                        );
                        currentOffset = 1;
                      });
                      break;
                    case 2:
                      setState(() {
                        currentDate = DateTime(
                          currentDate.year - 1,
                          currentDate.month,
                          currentDate.day,
                        );
                        currentOffset = 1;
                      });
                      break;
                  }
                },
                customBorder: CircleBorder(),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
            ),
          Padding(
            padding: (currentOffset == 0)
                ? EdgeInsets.zero
                : EdgeInsets.only(left: 50),
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Center(
                child: Text(
                  currentDateString(widget.selected, currentDate),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              if (currentOffset != 0)
                Material(
                  color: Colors.white,
                  shape: CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentOffset = 0;
                        currentDate = DateTime.now();
                      });
                    },
                    customBorder: CircleBorder(),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.refresh),
                    ),
                  ),
                ),
              SizedBox(width: 10),
              if (widget.selected != 3 && widget.selected != 4)
                Material(
                  color: Colors.white,
                  shape: CircleBorder(),
                  child: InkWell(
                    onTap: () {
                      switch (widget.selected) {
                        case 0:
                          setState(() {
                            currentDate = currentDate.add(Duration(days: 1));
                            currentOffset = 1;
                          });
                          break;
                        case 1:
                          setState(() {
                            currentDate = DateTime(
                              currentDate.year,
                              currentDate.month + 1,
                              currentDate.day,
                            );
                            currentOffset = 1;
                          });
                          break;
                        case 2:
                          setState(() {
                            currentDate = DateTime(
                              currentDate.year + 1,
                              currentDate.month,
                              currentDate.day,
                            );
                            currentOffset = 1;
                          });
                          break;
                      }
                    },
                    customBorder: CircleBorder(),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(child: Icon(Icons.arrow_forward_ios)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
