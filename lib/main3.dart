import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'package:flutter_web_plugins/url_strategy.dart';



void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(null); //https://github.com/flutter/flutter/issues/108114#issuecomment-1642097114

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  void initState() {
    print('INIT2 search URL: ${html.window.location.pathname}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean URL Navigation Test',
      home: NavigationManager(),
      /*html.window.history.pushState(
            {'page': 2},
            'Page 2',
            '/page2'
        );Navigator.of(context).pushNamed('/page2');*/

    );
  }
}

class NavigationManager extends StatefulWidget {
  @override
  _NavigationManagerState createState() => _NavigationManagerState();
}

class _NavigationManagerState extends State<NavigationManager> {
  int currentPage = 1;
  int historyPosition = 1;
  //int onPopStateLastHistoryPosition = 1;
  String onPopStateLastState = '_';


  @override
  void initState() {
    super.initState();

    print('START URL: ${html.window.location.pathname}');

    if (html.window.location.pathname == '' || html.window.location.pathname == '/') {
      html.window.history.replaceState({'page': 1}, 'Page 1', '/page11'); // default url
    }

    //BuildContext contxt = context;

    html.window.onPopState.listen((event) {
      if (onPopStateLastState != (html.window.location.pathname??'')) {
        onPopStateLastState = html.window.location.pathname??'';


        //print('Event state: ${event.toString()}');
        print('🌐 Browser Back/Forward pressed - using default behavior');
        //print('onPopStateLastState: ${onPopStateLastState}');
        /*print('Event state: ${event.state}');
        print('Current URL: ${html.window.location.href}');
        print('search URL: ${html.window.location.pathname}');*/
        //Navigator.of(event.context).pushNamed('/page3');
        // Let browser handle it normally
        /*setState(() {});*/

        //TODO check if forward or back button was pressed
        // save all push urls and check if current is second last item in history -> back else forward
        // remove last inserted item when pop
        // when forward -> history push state with same url as current and history back
        // (maybe try support forward by navigator push page)
        // or do nothing and show message that forward is not supported
        // or RELOAD CURRENT PAGE (reload forwarded page so it displays right content)

        if (historyPosition > 1) {

          historyPosition--;
          print("POP");

          Navigator.pop(context);
        }

        print("POPSTATE END");
      } else {
        // should never be reach because of Navigator.pop(context);
        print("TWICE");
      }
    });

    // Set initial URL without hash
    //html.window.history.replaceState({'serialCount' : 0, 'page': 1}, 'Page 1', '/page112');
    print(html.window.history.state);
    print('search URL: ${html.window.location.pathname}');
    print("initState");
  }

  void navigateToPage(int pageNumber) {
    print('📱 Navigating to Page $pageNumber using history.pushState');

    setState(() {
      currentPage = pageNumber;
    });

    historyPosition++;

    // Push new state to browser history with clean URL
    html.window.history.pushState(
        {'page': pageNumber},
        'Page $pageNumber',
        '/page$pageNumber'
    );
    onPopStateLastState = '_';
  }

  void goBack() {
    if (historyPosition > 1) {
      print('📱 Flutter back button - using history.back()');

      currentPage--;

      /*setState(() {
      });*/

      print('History position: $historyPosition');

      // Use browser's history.back()
      html.window.history.back();
    } else {
      print('📱 No history to go back - history position: $historyPosition');
    }
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
          print("BACKBUTTON");
        },
        child: Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            title: Text('Page 11'),
            backgroundColor: Colors.red,
            automaticallyImplyLeading: true, // Remove default back button
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  html.window.location.pathname ?? '',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('This is the first page'),
                Text('Clean URL: /page11'),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {navigateToPage(1); Navigator.push(context, MaterialPageRoute(builder: (context) => Page1(onNavigateToPage: navigateToPage, onGoBack: goBack))).then((onValue) {setState(() {

                  });});},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'PAGE 1',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => navigateToPage(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Go to Page 1',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => navigateToPage(2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Go to Page 2',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => navigateToPage(3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Go to Page 3',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('Current URL:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        html.window.location.href,
                        style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                      ),
                      SizedBox(height: 8),
                      Text('Pathname:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        html.window.location.pathname!,
                        style: TextStyle(fontSize: 12, color: Colors.green[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));

  }
}

class Page1 extends StatelessWidget {
  final Function(int) onNavigateToPage;
  final VoidCallback onGoBack;

  const Page1({Key? key, required this.onNavigateToPage, required this.onGoBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
        },
        child: Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            title: Text('Page 1'),
            backgroundColor: Colors.red,
            //automaticallyImplyLeading: true, // Remove default back button
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onGoBack,
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PAGE 1',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('This is the first page'),
                Text('Clean URL: /page1'),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {onNavigateToPage(2); Navigator.push(context, MaterialPageRoute(builder: (context) => Page2(onNavigateToPage: onNavigateToPage, onGoBack: onGoBack)));},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    'Go to Page 2',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('Current URL:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        html.window.location.href,
                        style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                      ),
                      SizedBox(height: 8),
                      Text('Pathname:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        html.window.location.pathname!,
                        style: TextStyle(fontSize: 12, color: Colors.green[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Page2 extends StatelessWidget {
  final Function(int) onNavigateToPage;
  final VoidCallback onGoBack;

  const Page2({Key? key, required this.onNavigateToPage, required this.onGoBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
        },
        child: Scaffold(
          backgroundColor: Colors.green[100],
          appBar: AppBar(
            title: Text('Page 2'),
            backgroundColor: Colors.green,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onGoBack,
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PAGE 2',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('This is the second page'),
                Text('Clean URL: /page2'),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: onGoBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('← Flutter Back', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {onNavigateToPage(3); Navigator.push(context, MaterialPageRoute(builder: (context) => Page3(onNavigateToPage: onNavigateToPage, onGoBack: onGoBack)));},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Page 3 →', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {onNavigateToPage(1); Navigator.push(context, MaterialPageRoute(builder: (context) => Page1(onNavigateToPage: onNavigateToPage, onGoBack: onGoBack)));},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Jump to Page 1', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('Current URL:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        html.window.location.href,
                        style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                      ),
                      SizedBox(height: 8),
                      Text('Pathname:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        html.window.location.pathname!,
                        style: TextStyle(fontSize: 12, color: Colors.green[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Page3 extends StatelessWidget {
  final Function(int) onNavigateToPage;
  final VoidCallback onGoBack;

  const Page3({Key? key, required this.onNavigateToPage, required this.onGoBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
        },
        child: Scaffold(
          backgroundColor: Colors.blue[100],
          appBar: AppBar(
            title: Text('Page 3'),
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onGoBack,
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PAGE 3',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('This is the third page (deepest level)'),
                Text('Clean URL: /page3'),
                SizedBox(height: 40),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: onGoBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('← Flutter Back', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => onNavigateToPage(1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Jump to Page 1', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => onNavigateToPage(2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Jump to Page 2', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('Current URL:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        html.window.location.href,
                        style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                      ),
                      SizedBox(height: 8),
                      Text('Pathname:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        html.window.location.pathname!,
                        style: TextStyle(fontSize: 12, color: Colors.green[800]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text('Clean URL Navigation:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('✅ Flutter buttons: history.back()', style: TextStyle(fontSize: 12)),
                      Text('✅ Forward: history.pushState()', style: TextStyle(fontSize: 12)),
                      Text('🌐 Browser back: default behavior', style: TextStyle(fontSize: 12)),
                      Text('🚫 No hash (#) in URLs', style: TextStyle(fontSize: 12)),
                      Text('🚫 No Flutter router used', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}