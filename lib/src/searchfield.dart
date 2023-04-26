import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
//==============================================================//
//Edited by waseem
import 'package:outline_search_bar/src/debouncer.dart';
import 'package:simple_text_field/simple_text_field.dart';

/// The minimum height of the search bar.
const double _kSearchBarMinimumHeight = 48.0;

/// The size of action buttons, such as search and clear buttons.
const Size _kActionButtonSize = Size(36.0, 36.0);

//==============================================================//



enum Suggestion {
  /// shows suggestions when searchfield is brought into focus
  expand,

  /// keeps the suggestion overlay hidden until
  /// first letter is entered
  hidden,
}

// enum to define the Focus of the searchfield when a suggestion is tapped
enum SuggestionAction {
  /// shift to next focus
  next,

  /// close keyboard and unfocus
  unfocus,
}

enum SuggestionDirection {
  /// show suggestions below the searchfield
  down,

  /// show suggestions above the searchfield
  up,
}



class SearchFieldListItem<T> {
  Key? key;

  /// the text based on which the search happens
  final String searchKey;

  /// Custom Object to be associated with each ListItem
  /// see example in [example/lib/country_search.dart](https://github.com/maheshmnj/searchfield/tree/master/example/lib/country_search.dart)
  final T? item;

  /// The widget to be shown in the searchField
  /// if not specified, Text widget with default styling will be used
  final Widget? child;

  /// The widget to be shown in the suggestion list
  /// if not specified, Text widget with default styling will be used
  /// to show a custom widget, use [child] instead
  /// see example in [example/lib/country_search.dart]()
  SearchFieldListItem(this.searchKey, {this.child, this.item, this.key});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SearchFieldListItem &&
            runtimeType == other.runtimeType &&
            searchKey == other.searchKey;
  }

  @override
  int get hashCode => searchKey.hashCode;
}

/// extension to check if a Object is present in List<Object>
extension ListContainsObject<T> on List {
  bool containsObject(T object) {
    for (var item in this) {
      if (object == item) {
        return true;
      }
    }
    return false;
  }
}

/// A widget that displays a searchfield and a list of suggestions
/// when the searchfield is brought into focus
/// see [example/lib/country_search.dart]
///
class SearchField<T> extends StatefulWidget {
  final FocusNode? focusNode;

  /// List of suggestions for the searchfield.
  /// each suggestion should have a unique searchKey
  ///
  /// ```dart
  /// ['ABC', 'DEF', 'GHI', 'JKL']
  ///   .map((e) => SearchFieldListItem(e, child: Text(e)))
  ///   .toList(),
  /// ```
  final List<SearchFieldListItem<T>> suggestions;

  //Edited by waseem
  //==============================================================//
  /// Set the icon of [OutlineSearchBar].
  final Icon? icon;

  /// Set the color of [OutlineSearchBar].
  /// Default value is `Theme.of(context).scaffoldBackgroundColor`.
  final Color? backgroundColor;

  /// Set the border color of [OutlineSearchBar].
  /// If value is null and theme brightness is light, use primaryColor, if dark, use accentColor.
  final Color? borderColor;

  /// Set the border thickness of [OutlineSearchBar].
  /// Default value is `1.0`.
  final double borderWidth;

  /// Set the border radius of [OutlineSearchBar].
  /// Default value is `const BorderRadius.all(const Radius.circular(4.0))`.
  final BorderRadius borderRadius;

  /// Set the margin value of [OutlineSearchBar].
  /// Default value is `const EdgeInsets.only()`.
  final EdgeInsetsGeometry margin;

  /// Set the padding value of [OutlineSearchBar].
  /// Default value is `const EdgeInsets.symmetric(horizontal: 5.0)`.
  final EdgeInsetsGeometry padding;

  /// Set the text padding value of [OutlineSearchBar].
  /// Default value is `const EdgeInsets.symmetric(horizontal: 5.0)`.
  final EdgeInsetsGeometry textPadding;

  /// Set the elevation of [OutlineSearchBar].
  /// Default value is `0.0`.
  final double elevation;

  /// Set the keyword to be initially entered.
  /// If initial text is set in [textEditingController], this value is ignored.
  final String? initText;

  /// Set the text to be displayed when the keyword is empty.
  final String? hintText;

  /// Set the input text style.
  final TextStyle? textStyle;

  /// Set the style of [hintText].
  final TextStyle? hintStyle;

  /// Set the maximum length of text to be entered.
  final int? maxLength;

  /// Set the color of cursor.
  final Color? cursorColor;

  /// Set the width of cursor.
  /// Default value is `2.0`.
  final double cursorWidth;

  /// Set the height of cursor.
  final double? cursorHeight;

  /// Set the radius of cursor.
  final Radius? cursorRadius;

  /// Set the background color of the clear button.
  /// Default value is `const Color(0xFFDDDDDD)`.
  final Color clearButtonColor;

  /// Set the icon color inside the clear button.
  /// Default value is `const Color(0xFFFEFEFE)`.
  final Color clearButtonIconColor;

  /// Set the splash color that appears when the search button is pressed.
  final Color? searchButtonSplashColor;

  /// Set the icon color inside the search button.
  /// If value is null and theme brightness is light, use primaryColor, if dark, use accentColor.
  final Color? searchButtonIconColor;

  /// Set the position of the search button.
  /// Default value is [SearchButtonPosition.trailing].
  final SearchButtonPosition searchButtonPosition;

  /// The delay between when the user stops typing a keyword and receives the onTypingFinished event.
  /// Default value is `500`.
  final int debounceDelay;

  /// The keyword of [OutlineSearchBar] can be controlled with a [TextEditingController].
  final TextEditingController? textEditingController;

  /// Set keyboard type.
  /// Default value is [TextInputType.text].
  final TextInputType keyboardType;

  /// Set keyboard action.
  /// Default value is [TextInputAction.search].
  final TextInputAction textInputAction;

  /// Set the maximum height of [OutlineSearchBar].
  final double? maxHeight;

  /// Whether to use enableSuggestions option.
  /// Default value is `true`.
  final bool enableSuggestions;

  /// Whether to hide the search button.
  /// Default value is `false`.
  final bool hideSearchButton;

  /// Whether to ignore input of white space.
  /// Default value is `false`.
  final bool ignoreWhiteSpace;

  /// Whether to ignore input of special characters.
  /// Default value is `false`.
  final bool ignoreSpecialChar;

  /// Called when [OutlineSearchBar] is tapped.
  final GestureTapCallback? onTap;

  /// Called whenever a keyword is changed.
  final ValueChanged<String>? onKeywordChanged;

  /// Called when keyword typing is finished.
  final ValueChanged<String>? onTypingFinished;

  /// When the clear button is pressed, it is called with the previous keyword.
  final ValueChanged<String>? onClearButtonPressed;

  /// When the search button is pressed, it is called with the entered keyword.
  final ValueChanged<String>? onSearchButtonPressed;

  //==============================================================//

  /// Callback when the suggestion is selected.
  final Function(SearchFieldListItem<T>)? onSuggestionTap;

  /// Defines whether to enable the searchfield defaults to `true`
  final bool? enabled;

  /// Defines whether to show the searchfield as readOnly
  final bool readOnly;

  /// Callback when the Searchfield is submitted
  ///  it returns the text from the searchfield
  final Function(String)? onSubmit;

  /// Hint for the [SearchField].
  final String? hint;

  /// Define a [TextInputAction] that is called when the field is submitted
  //final TextInputAction? textInputAction;

  /// The initial value to be selected for [SearchField]. The value
  /// must be present in [suggestions].
  ///
  /// When not specified, [hint] is shown instead of `initialValue`.
  final SearchFieldListItem<T>? initialValue;

  // /// Specifies [TextStyle] for search input.
  // final TextStyle? searchStyle;

  // /// Specifies [TextStyle] for suggestions when no child is provided.
  final TextStyle? suggestionStyle;

  /// Specifies [InputDecoration] for search input [TextField].
  ///
  /// When not specified, the default value is [InputDecoration] initialized
  /// with [hint].
  final InputDecoration? searchInputDecoration;

  /// defaults to SuggestionState.expand
  final Suggestion suggestionState;

  /// Specifies the [SuggestionAction] called on suggestion tap.
  final SuggestionAction? suggestionAction;

  /// Specifies [BoxDecoration] for suggestion list. The property can be used to add [BoxShadow], [BoxBorder]
  /// and much more. For more information, checkout [BoxDecoration].
  ///
  /// Default value,
  ///
  /// ```dart
  /// BoxDecoration(
  ///   color: Theme.of(context).colorScheme.surface,
  ///   boxShadow: [
  ///     BoxShadow(
  ///       color: onSurfaceColor.withOpacity(0.1),
  ///       blurRadius: 8.0, // soften the shadow
  ///       spreadRadius: 2.0, //extend the shadow
  ///       offset: Offset(
  ///         2.0,
  ///         5.0,
  ///       ),
  ///     ),
  ///   ],
  /// )
  /// ```
  final BoxDecoration? suggestionsDecoration;

  /// Specifies [BoxDecoration] for items in suggestion list. The property can be used to add [BoxShadow],
  /// and much more. For more information, checkout [BoxDecoration].
  ///
  /// Default value,
  ///
  /// ```dart
  /// BoxDecoration(
  ///   border: Border(
  ///     bottom: BorderSide(
  ///       color: widget.marginColor ??
  ///         onSurfaceColor.withOpacity(0.1),
  ///     ),
  ///   ),
  /// )
  /// ```
  final BoxDecoration? suggestionItemDecoration;

  /// Specifies height for each suggestion item in the list.
  ///
  /// When not specified, the default value is `35.0`.
  final double itemHeight;

  /// Specifies the color of margin between items in suggestions list.
  ///
  /// When not specified, the default value is `Theme.of(context).colorScheme.onSurface.withOpacity(0.1)`.
  final Color? marginColor;

  /// Specifies the number of suggestions that can be shown in viewport.
  ///
  /// When not specified, the default value is `5`.
  /// if the number of suggestions is less than 5, then [maxSuggestionsInViewPort]
  /// will be the length of [suggestions]
  final int maxSuggestionsInViewPort;

  /// Specifies the `TextEditingController` for [SearchField].
  final TextEditingController? controller;

  /// Keyboard Type for SearchField
  final TextInputType? inputType;

  /// `validator` for the [SearchField]
  /// to make use of this validator, The
  /// SearchField widget needs to be wrapped in a Form
  /// and pass it a Global key
  /// and write your validation logic in the validator
  /// you can define a global key
  ///
  ///  ```dart
  ///  Form(
  ///   key: _formKey,
  ///   child: SearchField(
  ///     suggestions: _statesOfIndia,
  ///     validator: (state) {
  ///       if (!_statesOfIndia.contains(state) || state.isEmpty) {
  ///         return 'Please Enter a valid State';
  ///       }
  ///       return null;
  ///     },
  ///   )
  /// ```
  /// You can then validate the form by calling
  /// the validate function of the form
  ///
  /// `_formKey.currentState.validate();`
  ///
  ///
  ///
  final String? Function(String?)? validator;

  /// Defines whether to show the scrollbar always or only when scrolling.
  /// defaults to `true`
  final bool scrollbarAlwaysVisible;

  /// suggestion List offset from the searchfield
  /// The top left corner of the searchfield is the origin (0,0)
  final Offset? offset;

  /// Widget to show when the search returns
  /// empty results.
  /// defaults to [SizedBox.shrink]
  final Widget emptyWidget;

  /// Function that implements the comparison criteria to filter out suggestions.
  /// The 2 parameters are the input text and the `suggestionKey` passed to each `SearchFieldListItem`
  /// which should return true or false to filter out the suggestion.
  /// by default the comparator shows the suggestions that contain the input text
  /// in the `suggestionKey`
  final bool Function(String inputText, String suggestionKey)? comparator;

  /// Defines whether to enable autoCorrect defaults to `true`
  final bool autoCorrect;

  /// input formatter for the searchfield
  final List<TextInputFormatter>? inputFormatters;

  /// suggestion direction defaults to [SuggestionDirection.up]
  final SuggestionDirection suggestionDirection;

  SearchField(
      {Key? key,
      required this.suggestions,
      //this.autoCorrect = true,
      this.controller,
      this.emptyWidget = const SizedBox.shrink(),
      this.focusNode,
      this.hint,
      this.initialValue,
      this.inputFormatters,
      this.inputType,
      this.itemHeight = 35.0,
      this.marginColor,
      this.maxSuggestionsInViewPort = 5,
      this.enabled,
      this.readOnly = false,
      this.onSubmit,
      this.offset,
      this.onSuggestionTap,
      this.searchInputDecoration,
      //Edited by waseem
      //this.searchStyle,
      this.scrollbarAlwaysVisible = true,
      this.suggestionStyle,
      this.suggestionsDecoration,
      this.suggestionDirection = SuggestionDirection.down,
      this.suggestionState = Suggestion.expand,
      this.suggestionItemDecoration,
      this.suggestionAction,
      //this.textInputAction,
      this.validator,
      this.comparator,
      

  //Edited by waseem
  //==============================================================//      
    this.textEditingController,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.search,
    this.maxHeight,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.margin = const EdgeInsets.only(),
    this.padding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.textPadding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.elevation = 0.0,
    this.initText,
    this.hintText,
    this.textStyle,
    this.hintStyle,
    this.maxLength,
    this.cursorColor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.clearButtonColor = const Color(0xFFDDDDDD),
    this.clearButtonIconColor = const Color(0xFFFEFEFE),
    this.searchButtonSplashColor,
    this.searchButtonIconColor,
    this.searchButtonPosition = SearchButtonPosition.trailing,
    this.debounceDelay = 500,
    this.autoCorrect = false,
    this.enableSuggestions = true,
    this.hideSearchButton = false,
    this.ignoreWhiteSpace = false,
    this.ignoreSpecialChar = false,
    this.onTap,
    this.onKeywordChanged,
    this.onTypingFinished,
    this.onClearButtonPressed,
    this.onSearchButtonPressed,
 //==============================================================//

      })
      //Edited by waseem
      //==============================================================//  
      :assert(borderWidth >= 0.0),
       assert(elevation >= 0.0),
       assert(cursorWidth >= 0.0),
       assert(debounceDelay >= 0),
       //==============================================================//  
       assert(
            (initialValue != null &&
                    suggestions.containsObject(initialValue)) ||
                initialValue == null,
            'Initial value should either be null or should be present in suggestions list.'),
        super(key: key);

  @override
  _SearchFieldState<T> createState() => _SearchFieldState();
}

class _SearchFieldState<T> extends State<SearchField<T>> {
  
  //Edited by waseem
  //==============================================================// 
  late TextEditingController _textEditingController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Debouncer _debouncer;
  // Whether to show the clear button.
  bool _isShowingClearButton = false;

  // The color that represents the app.
  // If the color value of the content inside the search bar is null,
  // this color value is used as the default.
  late Color _themeColor;

  void _textEditingControllerListener() {
    if (_textEditingController.text.isEmpty && _isShowingClearButton) {
      _isShowingClearButton = false;
      _animationController.reverse();
    } else if (_textEditingController.text.isNotEmpty && !_isShowingClearButton) {
      _isShowingClearButton = true;
      _animationController.forward();
    }
  }

  //==============================================================// 
  


  final StreamController<List<SearchFieldListItem<T>?>?> suggestionStream =
      StreamController<List<SearchFieldListItem<T>?>?>.broadcast();
  FocusNode? _focus;
  bool isSuggestionExpanded = false;

  //Edited by waseem
  TextEditingController? searchController;

  @override
  void dispose() {
    suggestionStream.close();
    _scrollController.dispose();
    if (widget.controller == null) {
      searchController!.dispose();
    }
    if (widget.focusNode == null) {
      _focus!.dispose();
    }

    //Edited by waseem
    _textEditingController.removeListener(_textEditingControllerListener);

    super.dispose();
  }

  void initialize() {
    if (widget.focusNode != null) {
      _focus = widget.focusNode;
    } else {
      _focus = FocusNode();
    }
    _focus!.addListener(() {
      if (mounted) {
        setState(() {
          isSuggestionExpanded = _focus!.hasFocus;
        });
      }
      if (isSuggestionExpanded) {
        if (widget.initialValue == null) {
          if (widget.suggestionState == Suggestion.expand) {
            Future.delayed(Duration(milliseconds: 100), () {
              suggestionStream.sink.add(widget.suggestions);
            });
          }
        }
        Overlay.of(context).insert(_overlayEntry!);
      } else {
        if (_overlayEntry != null && _overlayEntry!.mounted) {
          _overlayEntry?.remove();
        }
      }
    });




  }

  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    searchController = widget.controller ?? TextEditingController();
    initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _overlayEntry = _createOverlay();
        if (widget.initialValue == null ||
            widget.initialValue!.searchKey.isEmpty) {
          suggestionStream.sink.add(null);
        } else {
          searchController!.text = widget.initialValue!.searchKey;
          suggestionStream.sink.add([widget.initialValue]);
        }
      }
    });

    //Edited by waseem
    //==============================================================// 
    _debouncer = Debouncer(milliseconds: widget.debounceDelay);

    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 250),
    //   reverseDuration: const Duration(milliseconds: 200),
    // );

    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _animationController.reverse();

    _textEditingController = widget.textEditingController ?? TextEditingController();
    _textEditingController.addListener(_textEditingControllerListener);

    if (_textEditingController.text.isEmpty && (widget.initText != null && widget.initText!.isNotEmpty)) {
      _textEditingController.text = widget.initText!;
    }
    //==============================================================// 
  }

  @override
  void didUpdateWidget(covariant SearchField<T> oldWidget) {
    if (oldWidget.controller != widget.controller) {
      searchController = widget.controller ?? TextEditingController();
    }
    if (oldWidget.suggestions != widget.suggestions) {
      suggestionStream.sink.add(widget.suggestions);
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _suggestionsBuilder() {
    return StreamBuilder<List<SearchFieldListItem<T>?>?>(
      stream: suggestionStream.stream,
      builder: (BuildContext context,
          AsyncSnapshot<List<SearchFieldListItem<T>?>?> snapshot) {
        if (snapshot.data == null || !isSuggestionExpanded) {
          return SizedBox();
        } else if (snapshot.data!.isEmpty) {
          return widget.emptyWidget;
        } else {
          if (snapshot.data!.length > widget.maxSuggestionsInViewPort) {
            _totalHeight = widget.itemHeight * widget.maxSuggestionsInViewPort;
          } else if (snapshot.data!.length == 1) {
            _totalHeight = widget.itemHeight;
          } else {
            _totalHeight = snapshot.data!.length * widget.itemHeight;
          }
          final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

          final Widget listView = ListView.builder(
            reverse: widget.suggestionDirection == SuggestionDirection.up,
            padding: EdgeInsets.zero,
            controller: _scrollController,
            itemCount: snapshot.data!.length,
            physics: snapshot.data!.length == 1
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            itemBuilder: (context, index) => TextFieldTapRegion(
                child: InkWell(
              onTap: () {
                searchController!.text = snapshot.data![index]!.searchKey;
                searchController!.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: searchController!.text.length,
                  ),
                );

                // suggestion action to switch focus to next focus node
                if (widget.suggestionAction != null) {
                  if (widget.suggestionAction == SuggestionAction.next) {
                    _focus!.nextFocus();
                  } else if (widget.suggestionAction ==
                      SuggestionAction.unfocus) {
                    _focus!.unfocus();
                  }
                }

                // hide the suggestions
                suggestionStream.sink.add(null);
                if (widget.onSuggestionTap != null) {
                  widget.onSuggestionTap!(snapshot.data![index]!);
                }
              },
              child: Container(
                height: widget.itemHeight,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                decoration: widget.suggestionItemDecoration?.copyWith(
                      border: widget.suggestionItemDecoration?.border ??
                          Border(
                            bottom: BorderSide(
                              color: widget.marginColor ??
                                  onSurfaceColor.withOpacity(0.1),
                            ),
                          ),
                    ) ??
                    BoxDecoration(
                      border: index == snapshot.data!.length - 1
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: widget.marginColor ??
                                    onSurfaceColor.withOpacity(0.1),
                              ),
                            ),
                    ),
                child: snapshot.data![index]!.child ??
                    Text(
                      snapshot.data![index]!.searchKey,
                      style: widget.suggestionStyle,
                    ),
              ),
            )),
          );

          return AnimatedContainer(
            duration: widget.suggestionDirection == SuggestionDirection.up
                ? Duration.zero
                : Duration(milliseconds: 300),
            height: _totalHeight,
            alignment: Alignment.centerLeft,
            decoration: widget.suggestionsDecoration ??
                BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                        color: onSurfaceColor.withOpacity(0.1),
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                        offset: Offset(
                          2.0,
                          5.0,
                        )),
                  ],
                ),
            child: RawScrollbar(
                thumbVisibility: widget.scrollbarAlwaysVisible,
                controller: _scrollController,
                padding: EdgeInsets.zero,
                child: listView),
          );
        }
      },
    );
  }

  /// Decides whether to show the suggestions
  /// on top or bottom of Searchfield
  /// User can have more control by manually specifying the offset
  Offset? getYOffset(
      Offset textFieldOffset, Size textFieldSize, int suggestionsCount) {
    if (mounted) {
      final size = MediaQuery.of(context).size;
      final isSpaceAvailable = size.height >
          textFieldOffset.dy + textFieldSize.height + _totalHeight;
      if (widget.suggestionDirection == SuggestionDirection.down) {
        return Offset(0, textFieldSize.height);
      } else if (widget.suggestionDirection == SuggestionDirection.up) {
        // search results should not exceed maxSuggestionsInViewPort
        if (suggestionsCount > widget.maxSuggestionsInViewPort) {
          return Offset(
              0, -(widget.itemHeight * widget.maxSuggestionsInViewPort));
        } else {
          return Offset(0, -(widget.itemHeight * suggestionsCount));
        }
      } else {
        if (!_isDirectionCalculated) {
          _isDirectionCalculated = true;
          if (isSpaceAvailable) {
            _offset = Offset(0, textFieldSize.height);
            return _offset;
          } else {
            if (suggestionsCount > widget.maxSuggestionsInViewPort) {
              _offset = Offset(
                  0, -(widget.itemHeight * widget.maxSuggestionsInViewPort));
              return _offset;
            } else {
              _offset = Offset(0, -(widget.itemHeight * suggestionsCount));
              return _offset;
            }
          }
        } else {
          return _offset;
        }
      }
    }
    return null;
  }

  OverlayEntry _createOverlay() {
    
    //edied by waseem
    final textFieldRenderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final textFieldsize = textFieldRenderBox.size;
    final offset = textFieldRenderBox.localToGlobal(Offset.zero);
    var yOffset = Offset.zero;
    return OverlayEntry(
        builder: (context) => StreamBuilder<List<SearchFieldListItem?>?>(
            stream: suggestionStream.stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<SearchFieldListItem?>?> snapshot) {

              //Edited by waseem
              if (Theme.of(context).brightness == Brightness.light) {
              _themeColor = Theme.of(context).primaryColor;
             } else {
             _themeColor = Theme.of(context).colorScheme.secondary;
             }


              late var count = widget.maxSuggestionsInViewPort;
              if (snapshot.data != null) {
                count = snapshot.data!.length;
              }
              yOffset = getYOffset(offset, textFieldsize, count) ?? Offset.zero;
              return Positioned(
                left: offset.dx,
                width: textFieldsize.width,
                child: CompositedTransformFollower(
                    offset: widget.offset ?? yOffset,
                    link: _layerLink,
                    child: Material(child: _suggestionsBuilder())),
              );
            }));
  }

  final LayerLink _layerLink = LayerLink();
  late double _totalHeight;
  GlobalKey key = GlobalKey();
  bool _isDirectionCalculated = false;
  Offset _offset = Offset.zero;
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {

    //Edited by waseem
      if (Theme.of(context).brightness == Brightness.light) {
      _themeColor = Theme.of(context).primaryColor;
    } else {
    _themeColor = Theme.of(context).colorScheme.secondary;
    }
  //==============================================================// 

    if (widget.suggestions.length > widget.maxSuggestionsInViewPort) {
      _totalHeight = widget.itemHeight * widget.maxSuggestionsInViewPort;
    } else {
      _totalHeight = widget.suggestions.length * widget.itemHeight;
    }

    // return Padding(
    //   padding: widget.margin,
    //   child: Material(
    //     elevation: widget.elevation,
    //     borderRadius: widget.borderRadius,
    //     color: Colors.transparent,
    //     child: _buildSearchBar(),
    //   ),


    //);

    return CompositedTransformTarget(

      //Edited by waseem
      //padding: widget.margin,
      link: _layerLink,
      child: TextFormField(

        key: key,
        enabled: widget.enabled,
        autocorrect: widget.autoCorrect,
        readOnly: widget.readOnly,

        onFieldSubmitted: (x) {
          if (widget.onSubmit != null) widget.onSubmit!(x);
        },
        onTap: () {
          /// only call if SuggestionState = [Suggestion.expand]
          if (!isSuggestionExpanded &&
              widget.suggestionState == Suggestion.expand) {
            suggestionStream.sink.add(widget.suggestions);
            if (mounted) {
              setState(() {
                isSuggestionExpanded = true;
              });
            }
          }
        },

        //elevation: widget.elevation,
        //borderRadius: widget.borderRadius,
        //color: Colors.transparent,
        //child: _buildSearchBar(),


        

        controller: widget.controller ?? searchController,
        focusNode: _focus,
        validator: widget.validator,

        onChanged: (query) {
          final searchResult = <SearchFieldListItem<T>>[];
          if (query.isEmpty) {
            _createOverlay();
            suggestionStream.sink.add(widget.suggestions);
            return;
          }
          for (final suggestion in widget.suggestions) {
            if (widget.comparator != null) {
              if (widget.comparator!(query, suggestion.searchKey)) {
                searchResult.add(suggestion);
              }
            } else if (suggestion.searchKey
                .toLowerCase()
                .contains(query.toLowerCase())) {
              searchResult.add(suggestion);
            }
          }
          suggestionStream.sink.add(searchResult);
        },
      ),
      //=================================//

      // link: _layerLink,
      // child: TextFormField(
      //   key: key,
      //   enabled: widget.enabled,
      //   autocorrect: widget.autoCorrect,
      //   readOnly: widget.readOnly,
      //   onFieldSubmitted: (x) {
      //     if (widget.onSubmit != null) widget.onSubmit!(x);
      //   },
      //   onTap: () {
      //     /// only call if SuggestionState = [Suggestion.expand]
      //     if (!isSuggestionExpanded &&
      //         widget.suggestionState == Suggestion.expand) {
      //       suggestionStream.sink.add(widget.suggestions);
      //       if (mounted) {
      //         setState(() {
      //           isSuggestionExpanded = true;
      //         });
      //       }
      //     }
      //   },
        //inputFormatters: widget.inputFormatters,
        // controller: widget.controller ?? searchController,
        // focusNode: _focus,
        // validator: widget.validator,
        //Edited by waseem
        //style: widget.searchStyle,
        //textInputAction: widget.textInputAction,
        // keyboardType: widget.inputType,
        // decoration:
        //     widget.searchInputDecoration?.copyWith(hintText: widget.hint) ??
        //         InputDecoration(hintText: widget.hint),
        // onChanged: (query) {
        //   final searchResult = <SearchFieldListItem<T>>[];
        //   if (query.isEmpty) {
        //     _createOverlay();
        //     suggestionStream.sink.add(widget.suggestions);
        //     return;
        //   }
        //   for (final suggestion in widget.suggestions) {
        //     if (widget.comparator != null) {
        //       if (widget.comparator!(query, suggestion.searchKey)) {
        //         searchResult.add(suggestion);
        //       }
        //     } else if (suggestion.searchKey
        //         .toLowerCase()
        //         .contains(query.toLowerCase())) {
        //       searchResult.add(suggestion);
        //     }
        //   }
        //   suggestionStream.sink.add(searchResult);
        // },
      //),
    );
  }

  //Edited by waseem
  //========================================================//
  Widget _buildTextField() {
    return SimpleTextField(
      focusNode: widget.focusNode,
      controller: _textEditingController,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.textStyle,
      maxLength: widget.maxLength,
      cursorColor: widget.cursorColor,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      autocorrect: widget.autoCorrect,
      enableSuggestions: widget.enableSuggestions,
      ignoreWhiteSpace: widget.ignoreWhiteSpace,
      ignoreSpecialChar: widget.ignoreSpecialChar,
      decoration: SimpleInputDecoration(
        icon: widget.icon,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        counterText: '',
        contentPadding: widget.textPadding,
        // isDense: true,
        // removeBorder: true,
        simpleBorder: true,
        borderWidth: 0.0,
        focusedBorderWidth: 0.0,
        borderColor: Colors.transparent,
        errorBorderColor: Colors.transparent,
        focusedBorderColor: Colors.transparent,
        focusedErrorBorderColor: Colors.transparent,
      ),
      onTap: widget.onTap,
      onChanged: (String value) {
        widget.onKeywordChanged?.call(value);

        _debouncer.run(() => widget.onTypingFinished?.call(value));
      },
      onSubmitted: (String value) {
        widget.onSearchButtonPressed?.call(value);
      },
    );
  }

  Widget _buildClearButton() {
    final clearIcon = Icon(Icons.clear, size: 18.0, color: widget.clearButtonIconColor);

    return ConstrainedBox(
      constraints: BoxConstraints.tight(_kActionButtonSize),
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: widget.clearButtonColor,
            borderRadius: BorderRadius.circular(clearIcon.size!),
          ),
          child: clearIcon,
        ),
        onTap: () async {
          widget.onClearButtonPressed?.call(_textEditingController.text);

          await Future.microtask(_textEditingController.clear);

          if (widget.onKeywordChanged != null) widget.onKeywordChanged!('');
        },
      ),
    );
  }

  Widget _buildSearchButton() {
    final searchIcon = Icon(Icons.search, size: 30.0, color: widget.searchButtonIconColor ?? _themeColor);

    return ConstrainedBox(
      constraints: BoxConstraints.tight(_kActionButtonSize),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: widget.searchButtonSplashColor,
          borderRadius: BorderRadius.circular(searchIcon.size!),
          child: searchIcon,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            widget.onSearchButtonPressed?.call(_textEditingController.text);
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final children = <Widget>[];
    children.add(Expanded(child: _buildTextField()));
    children.add(FadeTransition(opacity: _fadeAnimation, child: _buildClearButton()));

    if (widget.hideSearchButton == false) {
      if (widget.searchButtonPosition == SearchButtonPosition.leading) {
        children.insert(0, _buildSearchButton());
      } else {
        children.insert(children.length, _buildSearchButton());
      }
    }

    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: _kSearchBarMinimumHeight,
        maxHeight: widget.maxHeight ?? double.infinity,
      ),
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: widget.borderColor ?? _themeColor,
          width: widget.borderWidth,
        ),
        borderRadius: widget.borderRadius,
      ),
      child: Row(children: children),
    );
  }
  //========================================================//

}
