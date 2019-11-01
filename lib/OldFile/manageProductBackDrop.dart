import 'package:flutter/material.dart';
import 'dart:math' as math;

const _kFlingVelocity = 2.0;

class ManageProducts extends StatefulWidget {
  
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontHeader;
  final double frontPanelOpenHeight;
  final double frontHeaderHeight;
  final bool frontHeaderVisibleClosed;
  final EdgeInsets frontPanelPadding;
  final ValueNotifier<bool> panelVisible;

  ManageProducts(
      {Key key,
     
      @required this.frontLayer,
      @required this.backLayer,
      this.frontPanelOpenHeight = 0.0,
      this.frontHeaderHeight = 48.0,
      this.frontPanelPadding = const EdgeInsets.all(0.0),
      this.frontHeaderVisibleClosed = true,
      this.panelVisible,
      this.frontHeader})
      : assert(frontLayer != null),
        assert(backLayer != null);

  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  // String _selectedCat;
  // List<DropdownMenuItem<String>> _item = [];
  @override
  void initState() {
    super.initState();
    //   loadCatMenuItem();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: (widget.panelVisible?.value ?? true) ? 1.0 : 0.0,
      vsync: this,
    );
    widget.panelVisible?.addListener(_subscribeToValueNotifier);

    ///
    if (widget.panelVisible != null) {
      _controller.addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          widget.panelVisible.value = true;
        } else if (state == AnimationStatus.dismissed)
          widget.panelVisible.value = false;
      });
    }
  }

  void _subscribeToValueNotifier() {
    if (widget.panelVisible.value != _backdropPanelVisible)
      _toggleBackdropPanelVisibility();
  }

  /// Required for resubscribing when hot reload occurs
  @override
  void didUpdateWidget(ManageProducts oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.panelVisible?.removeListener(_subscribeToValueNotifier);
    widget.panelVisible?.addListener(_subscribeToValueNotifier);
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.panelVisible?.dispose();
    super.dispose();
  }

  bool get _backdropPanelVisible =>
      _controller.status == AnimationStatus.completed ||
      _controller.status == AnimationStatus.forward;

  void _toggleBackdropPanelVisibility() => _controller.fling(
      velocity: _backdropPanelVisible ? -_kFlingVelocity : _kFlingVelocity);

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_controller.isAnimating)
      _controller.value -= details.primaryDelta / _backdropHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(_kFlingVelocity, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-_kFlingVelocity, -flingVelocity));
    else
      _controller.fling(
          velocity:
              _controller.value < 0.5 ? -_kFlingVelocity : _kFlingVelocity);
  }

  /// تبدیل Map به List
  // void loadCatMenuItem() {
  //   _item.clear();
  //   widget.model.categoriList.forEach((String catid, String catname) {
  //     _item.add(DropdownMenuItem(
  //       child: Text(catname),
  //       value: catid,
  //     ));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final panelSize = constraints.biggest;
        final closedPercentage = widget.frontHeaderVisibleClosed
            ? (panelSize.height - widget.frontHeaderHeight) / panelSize.height
            : 1.0;
        final openPercentage = widget.frontPanelOpenHeight / panelSize.height;
        final panelDetailsPosition = Tween<Offset>(
          begin: Offset(0.0, closedPercentage),
          end: Offset(0.0, openPercentage),
        ).animate(_controller.view);
        return Container(
          key: _backdropKey,
          child: Stack(
            children: <Widget>[
              widget.backLayer,
              SlideTransition(
                position: panelDetailsPosition,
                child: _BackdropPanel(
                  onTap: _toggleBackdropPanelVisibility,
                  onVerticalDragEnd: _handleDragEnd,
                  onVerticalDragUpdate: _handleDragUpdate,
                  title: widget.frontHeader,
                  titleHeight: widget.frontHeaderHeight,
                  child: widget.frontLayer,
                  padding: widget.frontPanelPadding,
                ),
              )
            ],
          ),
        );
      },
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.transparent,
    //     title: Text(
    //       'مدیریت محصولات',
    //       style: Theme.of(context).textTheme.title,
    //     ),
    //     centerTitle: true,
    //     elevation: 0.0,
    //     actions: <Widget>[
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Material(
    //           color: Colors.transparent,
    //           elevation: 0,
    //           child: DropdownButton<String>(
    //               elevation: 0,
    //               isDense: true,
    //               hint: Text('همه دسته ها'),
    //               value: _selectedCat,
    //               onChanged: (val) {
    //                 setState(() {
    //                   _selectedCat = val;
    //                 });
    //               },
    //               items: _item),
    //         ),
    //       )
    //     ],
    //   ),
    //   body: Center(child: Container()),
    // );
  }
}


class _BackdropPanel extends StatelessWidget {
  const _BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    this.child,
    this.titleHeight,
    this.padding,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;
  final double titleHeight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        elevation: 12.0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: onVerticalDragUpdate,
              onVerticalDragEnd: onVerticalDragEnd,
              onTap: onTap,
              child: Container(height: titleHeight, child: title),
            ),
            Divider(
              height: 1.0,
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
