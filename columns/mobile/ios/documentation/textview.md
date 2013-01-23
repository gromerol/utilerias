# Ti.Columns.TextView

## Description

Displays columns of text in a scrollableView, you can swipe from left to right, or vice versa, to switch pages

## Properties

### text [string]

The text to be displayed.

### textAlign [string]

Text alignment of the entire text.

- left
- right
- center
- justify
- natural - Default

### portraitColumns [int]

Number of columns in portrait mode

Default: 3

### landscapeColumns [int]

Number of columns in landscape mode

Default: 4

### minFontSize [int]

Minimum font size (for zooming in/out)

Default: 12

### maxFontSize [int]

Meximum font size (for zooming in/out)

Default: 48

### Font [font dicctionary]

Diccionary - normal Titanium font

Sets the font of the text

Default: fontFamily: 'helvica', fontSize: 12

### currentPage [int]

Sets the current page to be displayed

## Methods

### scrollToPage(index ,animated)

Scrolls to a specific page in the scrollable view at 0-based index. The "animted" property is set to "true" by default

* index [int] The index to the page.
* animated [bool, optional] Whether or not to animate the transition. ex: {animate: false}

## Events

### scroll

Fired when the user moves to another page. Handlers will receive one dictionary as their first argument. The following properties will be available:

* index [int]: The 0-based index of the visible page
* source [string]: The TiColumnsTextView Object
* type [string]: The type of event (scroll)