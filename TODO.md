# Todo

version: 1.2.8
build: 101

- initial
  - [x] default bibleIdentify
  - [x] read local resource
  - [x] remove plugin -> flutter_slidable
  - [x] slidable into single StatefullWidget -> (bookmark)

- [x] Scroll to top

- bottomSheet
  - [x] Offset/visibility(iOS)

- appbar
  - [x] flexible
  - [x] bookName & Chapter alignment Center??

- bottomBar/navBar/menuBar/tabBar
  - [x] flexible
  - [x] fully hide on scale
  - [x] button paddding (iOS-8)

- [x] iOS Launch icon & screen

- [x] collection.bible
  - [ ] detail (count langs, count books)
  - [x] future data before navigation, so it will not struggle the slide
  - [ ] hide bible, send to unwanted list
  - [ ] userHome
  - [ ] agreement
  - [ ] add custom bible
    - [ ] share custom bible

- [x] read -> chapter -> verse
  - [x] chapter list
  - [x] book list
    - [x] collapsible with chapters
    - [x] auto scroll to
  - [x] bookmark chapter
  - [x] Popup Offset/width
  - [x] Offset & Width chapter navigator
  - [x] GestureDetector
  - [ ] Hightlight by quotation marks
    - [ ] Pasian in, “Khuavak om hen,” ci hi; tua ciangin khuavak om pah hi.
    - [ ] And God said, “Let there be light,” and there was light.
  - option
    - [x] sheet show/hide toggle
    - [x] auto close sheet if selectedVerse.isEmpty
    - custom
      - [x] fontSize
      - [x] fontColor
    - [ ] sharing

- [x] note -> library
  - [ ] improve
  - bookmarks
    - [x] chapter
    - [x] view list/orderByBook
  - [ ] bookmark verse

- [x] search -> verse
  - [ ] improve
  - [x] result
    - option
      - [ ] type -> Exact phrase, all words, any words
      - [ ] scope -> all, ot, nt, selection
    - [ ] header sticky
    - [x] keyword highlight
    - [ ] count(book,chapter,verse)
    - [x] no match found in ???
  - [x] suggestion
    - [ ] count
    - [x] keyword highlight
    - [x] delete(Dismissible)

- [ ] more -> info
  - [ ] about
    - [ ] detail (count langs, count books)
    - [ ] update notes
    - [ ] version

- [ ] E/EnhancedIntentService(12713): binding to the service failed

- api
  - [x] look for AnimatedSwitcher???
  - [ ] Mock http

## Feature

- [x] share
- [ ] Category
- [x] Title
- [ ] Quiz

## temporary

- [ ] search nav to reading
- [ ] note nav to reading
- [ ] parallel
- [ ] sync
- [ ] home current status of reading and search
- [ ] Parallel bottom clean

select_content
content_type: New International Version (NIV), item_id

I was looking for the answer too, it has turned out pretty easy.

```dart
void _onReorder(int oldIndex, int newIndex) {
  if (oldIndex < newIndex) {
    newIndex -= 1;
  }
  setState(() {
    // this is required, before you modified your box;
    final oldItem = itemsBox.getAt(oldIndex);
    final newItem = itemsBox.getAt(newIndex);

    // here you just swap this box item, oldIndex <> newIndex
    itemsBox.putAt(oldIndex, newItem);
    itemsBox.putAt(newIndex, oldItem);
  });
}
```
