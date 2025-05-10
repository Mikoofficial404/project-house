import 'package:flutter/material.dart';

class CustomFloatingSearchBar extends StatefulWidget {
  final Widget Function(BuildContext, Animation<double>)? builder;
  final CustomSearchBarController? controller;
  final String? hint;
  final List<Widget>? actions;
  final Widget? leading;
  final bool autocorrect;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margins;
  final double? width;
  final double? height;
  final Function(String)? onQueryChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onFocusChanged;
  final ScrollController? scrollController;
  final Duration? transitionDuration;
  final Curve? transitionCurve;

  const CustomFloatingSearchBar({
    Key? key,
    this.builder,
    this.controller,
    this.hint,
    this.actions,
    this.leading,
    this.autocorrect = true,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margins,
    this.width,
    this.height,
    this.onQueryChanged,
    this.onSubmitted,
    this.onFocusChanged,
    this.scrollController,
    this.transitionDuration,
    this.transitionCurve,
  }) : super(key: key);

  @override
  State<CustomFloatingSearchBar> createState() => _CustomFloatingSearchBarState();
}

class _CustomFloatingSearchBarState extends State<CustomFloatingSearchBar> with SingleTickerProviderStateMixin {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    // Use the internal TextEditingController from our custom controller
    _textController = widget.controller?._textController ?? TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    
    // Add a close listener to our custom controller if provided
    if (widget.controller != null) {
      widget.controller!.addCloseListener(_closeSearchBar);
    }
    
    _animationController = AnimationController(
      vsync: this,
      duration: widget.transitionDuration ?? const Duration(milliseconds: 300),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.transitionCurve ?? Curves.easeInOut,
    );
  }
  
  void _closeSearchBar() {
    if (_isOpen) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _textController.dispose();
    }
    if (widget.controller != null) {
      widget.controller!.removeCloseListener(_closeSearchBar);
    }
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && !_isOpen) {
      _animationController.forward();
      _isOpen = true;
    } else if (!_focusNode.hasFocus && _isOpen) {
      _animationController.reverse();
      _isOpen = false;
    }
    
    if (widget.onFocusChanged != null) {
      widget.onFocusChanged!();
    }
  }

  void _onQueryChanged(String query) {
    if (widget.onQueryChanged != null) {
      widget.onQueryChanged!(query);
    }
  }

  void _onSubmitted(String query) {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
            height: widget.height ?? 56,
            margin: widget.margins ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? theme.cardColor,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 8),
                  ] else ...[
                    const Icon(Icons.search),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: widget.hint ?? 'Search...',
                        border: InputBorder.none,
                        hintStyle: theme.textTheme.titleMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      style: theme.textTheme.titleMedium,
                      autocorrect: widget.autocorrect,
                      onChanged: _onQueryChanged,
                      onSubmitted: _onSubmitted,
                    ),
                  ),
                  if (widget.actions != null && widget.actions!.isNotEmpty) ...[
                    ...widget.actions!,
                  ],
                  if (_textController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _textController.clear();
                        _onQueryChanged('');
                      },
                    ),
                ],
              ),
            ),
          ),
          if (widget.builder != null && _isOpen)
            Container(
              constraints: BoxConstraints(
                maxHeight: 300, // Fixed height for suggestions
                maxWidth: widget.width ?? MediaQuery.of(context).size.width * 0.9,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: (widget.margins as EdgeInsets?)?.horizontal ?? 16,
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return widget.builder!(context, _animation);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class CustomSearchBarController {
  final TextEditingController _textController = TextEditingController();
  final List<VoidCallback> _closeListeners = [];
  
  String get query => _textController.text;
  
  set query(String value) {
    _textController.text = value;
  }
  
  void clear() {
    _textController.clear();
  }
  
  void close() {
    for (final listener in _closeListeners) {
      listener();
    }
  }
  
  void addCloseListener(VoidCallback listener) {
    _closeListeners.add(listener);
  }
  
  void removeCloseListener(VoidCallback listener) {
    _closeListeners.remove(listener);
  }
  
  void dispose() {
    _textController.dispose();
    _closeListeners.clear();
  }
}

class CustomCircularButton extends StatelessWidget {
  final Widget? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  
  const CustomCircularButton({
    Key? key,
    this.icon,
    this.onPressed,
    this.color,
    this.size = 40.0,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: color ?? Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: icon ?? const Icon(Icons.search, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
