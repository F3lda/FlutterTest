import 'package:flutter/material.dart';

import 'package:mendelupp/Common/change_notifiers.dart';
import 'package:mendelupp/Common/localization.dart';
import 'package:provider/provider.dart';

import 'language.dart';
import 'listview_infinite.dart';
import 'listview_test.dart';
import 'web_view_test_page.dart';
import 'package:mendelupp/Menus/main_menu.dart';

import 'package:flutter/foundation.dart';

import 'package:mendelupp/main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.callback});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  final void Function() callback;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter(BuildContext context) {
    var counter = context.read<Counter>();
    counter.increment();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result)  async {
        if (didPop) {
          var counter = context.read<PageLevelCounter>();
          if (counter.getValue() != 0) {
            counter.decrement();
          }
        } else {
          _showToast(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(DemoLocalization().translate("home_page")),//Text(widget.title),
          actions: const <Widget>[Menu2()]
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: SingleChildScrollView(
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              //
              // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
              // action in the IDE, or press "p" in the console), to see the
              // wireframe for each widget.
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Consumer<Counter>(
                  builder: (context, counter, child) => Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Consumer<PageLevelCounter>(
                  builder: (context, counter, child) => Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _showToast(context),
                  child: const Text('Show toast'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {var counter = context.read<PageLevelCounter>();
                    counter.increment();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Page ${counter.getValue()}", callback: widget.callback)));},
                  child: const Text('NextPage'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    var counter = context.read<PageLevelCounter>();
                    if (counter.getValue() != 0) {
                      //counter.decrement();
                      Navigator.pop(context);
                    }
                    if (counter.getValue() != 0) {
                      //counter.decrement();
                      Navigator.pop(context);
                    }},
                  child: const Text('Back'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (kIsWeb) {
                      // Some web specific code there
                    }
                    else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
                      // Some android/ios specific code
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WebViewApp()));
                    }
                    else if (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS || defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.fuchsia) {
                      // Some desktop specific code there
                    }

                    },
                  child: const Text('WebView'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListsWithCards()));
                    },
                  child: const Text('ListView'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ListViewInfinite(title: "Infinite ListView")));
                    },
                  child: const Text('ListView Infinite Scroll'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagesPage())).then((value) => setState(() {}));
                  },
                  child: const Text('Languages'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _incrementCounter(context),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      )
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
