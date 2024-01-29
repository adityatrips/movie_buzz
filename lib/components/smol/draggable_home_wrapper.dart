import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';

class DraggableHomeWrapper extends StatefulWidget {
  const DraggableHomeWrapper({
    super.key,
    required this.expandedBody,
    required this.fullyStretchable,
    required this.body,
    required this.title,
    required this.image,
    required this.headerBottomBar,
  });

  final Widget expandedBody;
  final bool fullyStretchable;
  final String image;
  final List<Widget> body;
  final String title;
  final List<Widget> headerBottomBar;

  @override
  State<DraggableHomeWrapper> createState() => _DraggableHomeWrapperState();
}

class _DraggableHomeWrapperState extends State<DraggableHomeWrapper> {
  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      expandedBody: widget.expandedBody,
      fullyStretchable: widget.fullyStretchable,
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: const Icon(Icons.menu_rounded),
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      headerBottomBar: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.headerBottomBar.isEmpty
            ? [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: widget.image.isNotEmpty
                        ? BorderRadius.circular(25)
                        : null,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu_rounded),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: widget.image.isNotEmpty
                            ? BorderRadius.circular(25)
                            : null,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: widget.image.isNotEmpty
                            ? BorderRadius.circular(25)
                            : null,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    )
                  ],
                ),
              ]
            : widget.headerBottomBar,
      ),
      headerWidget: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Center(
          child: widget.image.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) => Icon(
                      Icons.error_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: 50,
                    ),
                    fadeOutDuration: const Duration(milliseconds: 250),
                    fadeInDuration: const Duration(milliseconds: 250),
                    placeholderFadeInDuration: const Duration(
                      milliseconds: 250,
                    ),
                    imageUrl: widget.image,
                    placeholder: (context, url) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary),
                      );
                    },
                    fit: BoxFit.fitHeight,
                  ),
                ),
        ),
      ),
      body: widget.body,
    );
  }
}
