import 'package:flutter/material.dart';

class ExpansionPanelData {
  ExpansionPanelData(
      {required this.header, required this.body, this.isExpanded = false});

  Widget header;
  Widget body;
  bool isExpanded;
}

class MySingleAccordion extends StatefulWidget {
  const MySingleAccordion({
    super.key,
    required this.title,
    required this.child,
  });

  final Widget title;
  final Widget child;

  @override
  _MySingleAccordionState createState() => _MySingleAccordionState();
}

class _MySingleAccordionState extends State<MySingleAccordion> {
  late Widget header = widget.title;
  late Widget body = widget.child;

  late ExpansionPanelData _data;

  @override
  void initState() {
    super.initState();
    header = widget.title;
    body = widget.child;

    _data = ExpansionPanelData(
      header: header,
      body: body,
      isExpanded: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data.isExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          hasIcon: false,
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              onTap: () {
                setState(() {
                  _data.isExpanded = !isExpanded;
                });
              },
              title: _data.header,
            );
          },
          body: _data.body,
          isExpanded: _data.isExpanded,
        ),
      ],
    );
  }
}
