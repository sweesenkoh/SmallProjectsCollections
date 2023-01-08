# Basic MVVM setup with provider package

Mainly three steps:
- Create ViewModel
- Create View (Widget)
- Integrate them together

<br />

## 0. Update pubspec.yaml
```dart
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
```

<br />

## 1. Create ViewModel
```dart
class HomePageModel extends ChangeNotifier {
  // we make _items private, modification should only be done through
  // `addItem` function
  final List<String> _items = [];

  // get method to for public to access _items;
  List<String> get items => _items;

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }
}
```

<br />

## 2. Create View (Widget)
```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageModel>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            value.addItem("new item");
          }),
          child: const Text("+"),
        ),
        body: ListView(
          children: value.items.map((e) => Text(e)).toList(),
        ),
      ),
    );
  }
}
```
- Use `Consumer<HomePageModel>` to access the view model, via the `value` param
- Access list of items through `value.items`
- Add item to list through `value.addItem`

<br />

## 3. Integrate them together
Wrap the HomePage widget with the `ChangeNotifierProvider`
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider(
          create: (context) => HomePageModel(),
          child: const HomePage(),
        ));
  }
}
```
- Wrap `HomePage` widget with `ChangeNotifierProvider`.
- Inject an instance of `HomePageModel` as the view model
