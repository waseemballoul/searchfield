# [searchfield: ^0.7.6](https://pub.dev/packages/searchfield)

 <a href="https://pub.dev/packages/searchfield"><img src="https://img.shields.io/pub/v/searchfield.svg" alt="Pub"></a>


A highly customizable simple and easy to use flutter searchfield widget. This Widget allows you to search and select a suggestion from list of suggestions.

Think of this widget like a dropdownButton field with an ability

- to Search 🔍.
- to position and define height of each Suggestion Item
- to show dynamic suggestions as an overlay above the widgets or in the widget tree.
- to define max number of items visible in the viewport 📱
- to filter out the suggestions with a custom logic.
- to visually customize the input and the suggestions

list of all the properties mentioned below

## Getting Started

### Installation

- Add the dependency

```yaml
 flutter pub add searchfield
```

- Import the package

```
import 'package:searchfield/searchfield.dart';
```

Use the Widget

#### Example1

```dart
SearchField<Country>(
   suggestions: countries
     .map(
     (e) => SearchFieldListItem<Country>(
        e.name,
        item: e,
        // Use child to show Custom Widgets in the suggestions
        // defaults to Text widget
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(e.flag),
              ),
              SizedBox(
                width: 10,
              ),
              Text(e.name),
            ],
          ),
        ),
    ),
  )
  .toList(),
),
```

 <img src="https://user-images.githubusercontent.com/31410839/101930194-d74f5f80-3bfd-11eb-8f08-ca8f593cdb01.gif" width="210"/>

#### Example2 (Validation)

```dart
Form(
   key: _formKey,
   child: SearchField(
            suggestions: _statesOfIndia.map((e) =>
               SearchFieldListItem(e)).toList(),
            suggestionState: Suggestion.expand,
            textInputAction: TextInputAction.next,
            hint: 'SearchField Example 2',
            searchStyle: TextStyle(
              fontSize: 18,
              color: Colors.black.withOpacity(0.8),
            ),
            validator: (x) {
              if (!_statesOfIndia.contains(x) || x!.isEmpty) {
               return 'Please Enter a valid State';
              }
            return null;
            },
            searchInputDecoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
               borderSide: BorderSide(
               color: Colors.black.withOpacity(0.8),
               ),
              ),
              border: OutlineInputBorder(
               borderSide: BorderSide(color: Colors.red),
              ),
            ),
            maxSuggestionsInViewPort: 6,
            itemHeight: 50,
            onTap: (x) {},
         )
   )

```

<img src="https://user-images.githubusercontent.com/31410839/104081674-2ec10980-5256-11eb-9712-6b18e3e67f4a.gif" width="360"/>

## Customize the suggestions the way you want

<p float="left;padding=10px">
  <img src ="https://user-images.githubusercontent.com/31410839/115071426-ddd74600-9f13-11eb-8401-c4055344eff2.png" width="210"/>
  <img src = "https://user-images.githubusercontent.com/31410839/115071441-e29bfa00-9f13-11eb-8143-5e183a502df4.png" width="170"/>
  <img src = "https://user-images.githubusercontent.com/31410839/115071445-e3349080-9f13-11eb-8d9b-e4dc81d3e7a7.png"" width="232"/>
  <img src="https://user-images.githubusercontent.com/31410839/154835349-3d06376c-98ec-45ca-bede-10f9e2f69589.png" width="215"/>
</p>

### Support for Overlays

- With v0.5.0 Searchfield now adds support for Overlays which shows the suggestions floating on top of the Ui.
- The position of suggestions is dynamic based on the space available for the suggestions to expand within the viewport.

<p float="left;padding=10px">
<img src = "https://user-images.githubusercontent.com/31410839/114541712-b31b9200-9c74-11eb-90be-dee7ef8a4e4b.gif" width="400">
<img src = "https://user-images.githubusercontent.com/31410839/115070269-5a692500-9f12-11eb-9de9-73ae970bf337.gif" width="300">
</p>


## Properties

- `autoCorrect`: Defines whether to enable autoCorrect defaults to `true`
- `controller`: TextEditing Controller to interact with the searchfield.
- `comparator` property to filter out the suggestions with a custom logic.
- `emptyWidget`: Custom Widget to show when search returns empty Results (defaults to `SizedBox.shrink`)
- `enabled`: Defines whether to enable the searchfield defaults to `true`
- `focusNode` : FocusNode to interact with the searchfield.
- `hint` : hint for the search Input.
- `readOnly` : Defines whether to enable the searchfield defaults to `false`
- `initialValue` : The initial value to be set in searchfield when its rendered, if not specified it will be empty.
- `inputType`: Keyboard Type for SearchField
- `inputFormatters`: Input Formatter for SearchField
- `itemHeight` : height of each suggestion Item, (defaults to 35.0).
- `marginColor` : Color for the margin between the suggestions.
- `maxSuggestionsInViewPort` : The max number of suggestions that can be shown in a viewport.
- `offset` : suggestion List offset from the searchfield, The top left corner of the searchfield is the origin (0,0).
- `onSuggestionTap` : callback when a sugestion is tapped it also returns the tapped value.
- `onSubmit` : callback when the searchfield is submitted, it returns the current text in the searchfield.
- `scrollbarAlwaysVisible`: Defines whether to show the scrollbar always or only when scrolling.
- `suggestions`**(required)** : List of SearchFieldListItem to search from.
each `SearchFieldListItem` in the list requires a unique searchKey, which is used to search the list and an optional Widget, Custom Object to display custom widget and to associate a object with the suggestion list.
- `SuggestionState`: enum to hide/show the suggestion on focusing the searchfield defaults to `SuggestionState.expand`.
- `searchStyle` : textStyle for the search Input.
- `searchInputDecoration` : decoration for the search Input similar to built in textfield widget.
- `suggestionsDecoration` : decoration for suggestions List with ability to add box shadow background color and much more.
- `suggestionDirection` : direction of the suggestions list, defaults to `SuggestionDirection.down`.
- `suggestionItemDecoration` : decoration for suggestionItem with ability to add color and gradient in the background.
- `SuggestionAction` : enum to control focus of the searchfield on suggestion tap.
- `suggestionStyle`:Specifies `TextStyle` for suggestions when no child is provided.
- `textInputAction` : An action the user has requested the text input control to perform throgh the submit button on keyboard.

### You can find all the [code samples here](https://github.com/maheshmnj/searchfield/tree/master/example)

### Contributing

You are welcome to contribute to this package, to contribute please read the [contributing guidelines](CONTRIBUTING.md).


