part of '../infinite_widgets.dart';

/// GridView that once the bottom is reach call [nextData] to load more element until [hasNext] is false
/// Use [loadingWidget] to have a custom loading widget
class InfiniteGridView extends StatefulWidget {
  final double scrollThreshold;
  final Function nextData;
  final bool hasNext;
  final Widget? loadingWidget;
  final Widget Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final SliverGridDelegate gridDelegate;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;

  /// GridView that once the bottom is reach call [nextData] to load more element until [hasNext] is false
  /// Use [loadingWidget] to have a custom loading widget
  const InfiniteGridView({
    required this.nextData,
    required this.itemBuilder,
    required this.itemCount,
    required this.gridDelegate,
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.scrollThreshold = 300,
    this.hasNext = false,
    this.loadingWidget,
  }) : super(key: key);

  @override
  _InfiniteGridViewState createState() {
    return new _InfiniteGridViewState();
  }
}

class _InfiniteGridViewState extends State<InfiniteGridView> {
  late ScrollController _scrollController;
  int? _lastLoadedEvent;

  @override
  void initState() {
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(InfiniteGridView oldWidget) {
    if (oldWidget.itemCount != widget.itemCount) {
      _lastLoadedEvent = null;
    }
    if (oldWidget.controller != widget.controller) {
      _scrollController.removeListener(_onScroll);
      if (oldWidget.controller == null) {
        _scrollController.dispose();
      }
      _scrollController = widget.controller ?? ScrollController();
      _scrollController.addListener(_onScroll);
    }
    super.didUpdateWidget(oldWidget);
  }

  bool _hasScroll() {
    return _scrollController.position.haveDimensions &&
        _scrollController.position.maxScrollExtent > 0;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.hasNext ? widget.itemCount + 1 : widget.itemCount,
      gridDelegate: widget.gridDelegate,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      padding: widget.padding,
      physics: widget.physics,
      primary: widget.primary,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      semanticChildCount: widget.semanticChildCount,
      shrinkWrap: widget.shrinkWrap,
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (!_hasScroll() &&
            index == widget.itemCount &&
            _lastLoadedEvent == null &&
            widget.hasNext) {
          _lastLoadedEvent = widget.itemCount;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => widget.nextData());
        }
        if (index == widget.itemCount) {
          return widget.loadingWidget ??
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
        }
        return widget.itemBuilder(context, index);
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= widget.scrollThreshold &&
        _lastLoadedEvent == null &&
        widget.hasNext) {
      _lastLoadedEvent = widget.itemCount;
      widget.nextData();
    }
  }
}
