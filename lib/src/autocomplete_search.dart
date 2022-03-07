import 'dart:async';

import 'package:flutter/material.dart';
import '../google_maps_places_picker_refractored.dart';
import '../providers/place_provider.dart';
import '../providers/search_provider.dart';
import '../src/components/prediction_tile.dart';
import '../src/components/rounded_frame.dart';
import '../src/controllers/autocomplete_search_controller.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

class AutoCompleteSearch extends StatefulWidget {
  const AutoCompleteSearch({
    Key? key,
    required this.sessionToken,
    required this.onPicked,
    required this.appBarKey,
    this.hintText,
    this.searchingText = "Searching...",
    this.height = 40,
    this.contentPadding = EdgeInsets.zero,
    this.debounceMilliseconds,
    this.onSearchFailed,
    required this.searchBarController,
    this.autocompleteOffset,
    this.autocompleteRadius,
    this.autocompleteLanguage,
    this.autocompleteComponents,
    this.autocompleteTypes,
    this.strictbounds,
    this.region,
    this.initialSearchString,
    this.searchForInitialValue,
    this.autocompleteOnTrailingWhitespace,
    this.icon,
    this.iconColor,
    this.label,
    this.labelText,
    this.labelStyle,
    this.floatingLabelStyle,
    this.helperText,
    this.helperStyle,
    this.helperMaxLines,
    this.hintStyle,
    this.hintTextDirection,
    this.hintMaxLines,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
    this.floatingLabelBehavior,
    this.floatingLabelAlignment,
    this.isCollapsed = false,
    this.isDense,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.prefix,
    this.prefixText,
    this.prefixStyle,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.suffixStyle,
    this.suffixIconColor,
    this.suffixIconConstraints,
    this.counter,
    this.counterText,
    this.counterStyle,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.border,
    this.enabled = true,
    this.semanticCounterText,
    this.alignLabelWithHint,
    this.constraints,
    this.inputHeight,
    this.borderRadius,
    this.isInScaffoldBodyAndHasAppBar = true,
  }) : super(key: key);
  final bool isInScaffoldBodyAndHasAppBar;
  final String? sessionToken;
  final BorderRadiusGeometry? borderRadius;
  final String? hintText;
  final String? searchingText;
  final double height;
  final double? inputHeight;
  final EdgeInsetsGeometry contentPadding;
  final int? debounceMilliseconds;
  final ValueChanged<Prediction> onPicked;
  final ValueChanged<String>? onSearchFailed;
  final SearchBarController searchBarController;
  final num? autocompleteOffset;
  final num? autocompleteRadius;
  final String? autocompleteLanguage;
  final List<String>? autocompleteTypes;
  final List<Component>? autocompleteComponents;
  final bool? strictbounds;
  final String? region;
  final GlobalKey appBarKey;
  final String? initialSearchString;
  final bool? searchForInitialValue;
  final bool? autocompleteOnTrailingWhitespace;
  final Widget? icon;

  final Color? iconColor;

  final Widget? label;

  final String? labelText;

  final TextStyle? labelStyle;

  final TextStyle? floatingLabelStyle;

  final String? helperText;

  final TextStyle? helperStyle;

  final int? helperMaxLines;

  final TextStyle? hintStyle;

  final TextDirection? hintTextDirection;

  final int? hintMaxLines;

  final String? errorText;

  final TextStyle? errorStyle;

  final int? errorMaxLines;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final FloatingLabelAlignment? floatingLabelAlignment;

  final bool? isDense;

  final bool isCollapsed;

  final Widget? prefixIcon;

  final BoxConstraints? prefixIconConstraints;

  final Widget? prefix;

  final String? prefixText;

  final TextStyle? prefixStyle;

  final Color? prefixIconColor;

  final Widget? suffixIcon;

  final Widget? suffix;

  final String? suffixText;

  final TextStyle? suffixStyle;

  final Color? suffixIconColor;

  final BoxConstraints? suffixIconConstraints;

  final String? counterText;

  final Widget? counter;

  final TextStyle? counterStyle;

  final bool? filled;

  final Color? fillColor;

  final Color? focusColor;

  final Color? hoverColor;

  final InputBorder? errorBorder;

  final InputBorder? focusedBorder;

  final InputBorder? focusedErrorBorder;

  final InputBorder? disabledBorder;

  final InputBorder? enabledBorder;

  final InputBorder? border;

  final bool enabled;

  final String? semanticCounterText;

  final bool? alignLabelWithHint;

  final BoxConstraints? constraints;

  @override
  AutoCompleteSearchState createState() => AutoCompleteSearchState();
}

class AutoCompleteSearchState extends State<AutoCompleteSearch> {
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  OverlayEntry? overlayEntry;
  SearchProvider provider = SearchProvider();

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchString != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.text = widget.initialSearchString!;
        if (widget.searchForInitialValue!) {
          _onSearchInputChange();
        }
      });
    }
    controller.addListener(_onSearchInputChange);
    focus.addListener(_onFocusChanged);

    widget.searchBarController.attach(this);
  }

  @override
  void dispose() {
    controller.removeListener(_onSearchInputChange);
    controller.dispose();

    focus.removeListener(_onFocusChanged);
    focus.dispose();
    _clearOverlay();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Container(
        height: widget.inputHeight ?? widget.height,
        margin: const EdgeInsets.only(
          right: 10,
          // bottom: 10.0,
          // top: 10.0,
        ),
        // RoundedFrame(
        // height: widget.height,
        // padding: const EdgeInsets.only(right: 10),

        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black54
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
          borderRadius: widget.borderRadius ??
              BorderRadius.circular(widget.inputHeight ?? 20),
        ),

        // elevation: 8.0,
        child: Row(
          children: <Widget>[
            // SizedBox(width: 10),
            // Icon(Icons.search),
            // SizedBox(width: 10),
            Expanded(
              child: _buildSearchTextField(),
            ),
            // _buildTextClearIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return TextField(
      controller: controller,
      focusNode: focus,
      decoration: InputDecoration(
        hintText: widget.hintText,
        // border: widget.border ?? InputBorder.none,
        border:
            widget.border ?? OutlineInputBorder(borderSide: BorderSide.none),
        isDense: true,
        contentPadding: widget.contentPadding,
        alignLabelWithHint: widget.alignLabelWithHint,
        constraints: widget.constraints,
        hintStyle: widget.hintStyle,
        hintTextDirection: widget.hintTextDirection,
        hintMaxLines: widget.hintMaxLines,
        errorText: widget.errorText,
        errorStyle: widget.errorStyle,
        errorMaxLines: widget.errorMaxLines,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        floatingLabelAlignment: widget.floatingLabelAlignment,
        floatingLabelStyle: widget.floatingLabelStyle,
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        helperText: widget.helperText,
        helperStyle: widget.helperStyle,
        helperMaxLines: widget.helperMaxLines,
        suffixIcon: _buildTextClearIcon(),
        suffixText: widget.suffixText,
        suffixStyle: widget.suffixStyle,
        suffixIconColor: widget.suffixIconColor,
        suffixIconConstraints: widget.suffixIconConstraints,
        prefixIcon: widget.prefixIcon ?? Icon(Icons.search),
        prefixText: widget.prefixText,
        prefixStyle: widget.prefixStyle,
        prefixIconColor: widget.prefixIconColor,
        prefixIconConstraints: widget.prefixIconConstraints,
        counterText: widget.counterText,
        counterStyle: widget.counterStyle,
        filled: widget.filled,
        fillColor: widget.fillColor,
        focusColor: widget.focusColor,
        hoverColor: widget.hoverColor,
        errorBorder: widget.errorBorder,
        focusedBorder: widget.focusedBorder,
        focusedErrorBorder: widget.focusedErrorBorder,
        disabledBorder: widget.disabledBorder,
        enabledBorder: widget.enabledBorder,
        counter: widget.counter,
        enabled: widget.enabled,
        icon: widget.icon,
        iconColor: widget.iconColor,
        label: widget.label,
        prefix: widget.prefix,
        suffix: widget.suffix,
        isCollapsed: widget.isCollapsed,
        semanticCounterText: widget.semanticCounterText,
      ),
    );
  }

  Widget _buildTextClearIcon() {
    return Selector<SearchProvider, String>(
        selector: (_, provider) => provider.searchTerm,
        builder: (_, data, __) {
          if (data.length > 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                child: widget.suffixIcon ??
                    Icon(
                      Icons.clear,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                onTap: () {
                  clearText();
                },
              ),
            );
          } else {
            return SizedBox(width: 10);
          }
        });
  }

  _onSearchInputChange() {
    if (!mounted) return;
    this.provider.searchTerm = controller.text;

    PlaceProvider provider = PlaceProvider.of(context, listen: false);

    if (controller.text.isEmpty) {
      provider.debounceTimer?.cancel();
      _searchPlace(controller.text);
      return;
    }

    if (controller.text.trim() == this.provider.prevSearchTerm.trim()) {
      provider.debounceTimer?.cancel();
      return;
    }

    if (!widget.autocompleteOnTrailingWhitespace! &&
        controller.text.substring(controller.text.length - 1) == " ") {
      provider.debounceTimer?.cancel();
      return;
    }

    if (provider.debounceTimer?.isActive ?? false) {
      provider.debounceTimer!.cancel();
    }

    provider.debounceTimer =
        Timer(Duration(milliseconds: widget.debounceMilliseconds!), () {
      _searchPlace(controller.text.trim());
    });
  }

  _onFocusChanged() {
    PlaceProvider provider = PlaceProvider.of(context, listen: false);
    provider.isSearchBarFocused = focus.hasFocus;
    provider.debounceTimer?.cancel();
    provider.placeSearchingState = SearchingState.Idle;
  }

  _searchPlace(String searchTerm) {
    this.provider.prevSearchTerm = searchTerm;

    // ignore: unnecessary_null_comparison
    if (context == null) return;

    _clearOverlay();

    if (searchTerm.length < 1) return;

    _displayOverlay(_buildSearchingOverlay());

    _performAutoCompleteSearch(searchTerm);
  }

  _clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  _displayOverlay(Widget overlayChild) {
    _clearOverlay();

    // final RenderBox? appBarRenderBox =
    //     widget.appBarKey.currentContext!.findRenderObject() as RenderBox?;
    final screenWidth = MediaQuery.of(context).size.width;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // ignore: unnecessary_null_comparison
        top: widget.isInScaffoldBodyAndHasAppBar
            ? MediaQuery.of(context).size.height * widget.height / 20 * 0.1
            : MediaQuery.of(context).size.height * widget.height / 30 * 0.1,
        // widget.height != null
        //     ? MediaQuery.of(context).size.height * widget.height / 50 * 0.1
        //     : MediaQuery.of(context).size.height * 0.10,
        // appBarRenderBox!.size.height,
        left: screenWidth * 0.025,
        right: screenWidth * 0.025,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          child: overlayChild,
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry!);
  }

  Widget _buildSearchingOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(width: 24),
          Expanded(
            child: Text(
              widget.searchingText ?? "Searching...",
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPredictionOverlay(List<Prediction> predictions) {
    return ListBody(
      children: predictions
          .map(
            (p) => PredictionTile(
              prediction: p,
              onTap: (selectedPrediction) {
                resetSearchBar();
                widget.onPicked(selectedPrediction);
              },
            ),
          )
          .toList(),
    );
  }

  _performAutoCompleteSearch(String searchTerm) async {
    PlaceProvider provider = PlaceProvider.of(context, listen: false);

    if (searchTerm.isNotEmpty) {
      final PlacesAutocompleteResponse response =
          await provider.places.autocomplete(
        searchTerm,
        sessionToken: widget.sessionToken,
        location: provider.currentPosition == null
            ? null
            : Location(
                lat: provider.currentPosition!.latitude,
                lng: provider.currentPosition!.longitude,
              ),
        offset: widget.autocompleteOffset,
        radius: widget.autocompleteRadius,
        language: widget.autocompleteLanguage,
        types: widget.autocompleteTypes ?? const [],
        components: widget.autocompleteComponents ?? const [],
        strictbounds: widget.strictbounds ?? false,
        region: widget.region,
      );

      if (response.errorMessage?.isNotEmpty == true ||
          response.status == "REQUEST_DENIED") {
        if (widget.onSearchFailed != null) {
          widget.onSearchFailed!(response.status);
        }
        return;
      }

      _displayOverlay(_buildPredictionOverlay(response.predictions));
    }
  }

  clearText() {
    provider.searchTerm = "";
    controller.clear();
  }

  resetSearchBar() {
    clearText();
    focus.unfocus();
  }

  clearOverlay() {
    _clearOverlay();
  }
}
