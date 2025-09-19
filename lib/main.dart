import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'package:flutter_web_plugins/url_strategy.dart';


/*class RouteTracker extends StatelessWidget {
  final Widget child;
  static Widget? currentPage;

  const RouteTracker({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    currentPage = child;
    return child;
  }

  static void rebuildCurrent(BuildContext context) {
    if (currentPage != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => currentPage!),
      );
    }
  }
}

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }
  (context as Element).visitChildren(rebuild);
}*/


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


late State<dynamic> lastPageState;

String lastPathName = ''; // currentUrl

class _NavigationManagerState extends State<NavigationManager> {
  int historyPosition = 1;

  String startPath = '';


  @override
  void initState() {
    super.initState();

    lastPageState = this;

    print('START URL: ${html.window.location.pathname}');

    if (html.window.location.pathname == '' || html.window.location.pathname == '/') {
      //html.window.history.replaceState({'page': 1}, 'Page 1', '/start'); // default url
    }


    html.window.onPopState.listen((event) {
      if (lastPathName != (html.window.location.pathname??'')) {

        print('🌐 Browser Back/Forward pressed - using default behavior');
        print('Event state: ${event.state}');
        print('Current URL: ${html.window.location.href}');
        print('search URL: ${html.window.location.pathname}');
        print('last patname: ${lastPathName}');
        //Navigator.of(event.context).pushNamed('/page3');
        // Let browser handle it normally
        if (lastPathName.startsWith(html.window.location.pathname??'')) {//back
          if (lastPathName != '' && lastPathName != '/') { // pop only when its not in the root
            historyPosition--;
            print("POPSTATE BACK");
            Navigator.pop(context);
          }
        } else {// forward
          historyPosition++;
          print("POPSTATE FORWARD");
          // TODO rebuild current widget page and show next page
          // or pop until root and rebuild all
          //https://stackoverflow.com/questions/43778488/how-to-force-flutter-to-rebuild-redraw-all-widgets
          lastPageState.setState(() {

          });
          //RouteTracker.rebuildCurrent(context);

          //rebuildAllChildren(context);
        }
        print('History position: $historyPosition');

        lastPathName = html.window.location.pathname??'';
      } else {
        print("TWICE");
      }
    });

    // Set initial URL without hash
    print('search URL: ${html.window.location.pathname}');
    //html.window.history.replaceState({'serialCount' : 0, 'page': 1}, 'Page 1', '/page112');
    print(html.window.history.state);
    print('search URL: ${html.window.location.pathname}');
    print("initState");
    print('History position: $historyPosition');


    //currentUrl = html.window.location.pathname?? '';
    startPath = html.window.location.pathname?? '';
    lastPathName = html.window.location.pathname??'';

    // run only once
    html.window.history.replaceState({'serialCount' : 0, 'page': 0}, 'Page 0', '/');
    if (startPath.startsWith('/page1')) {
      navigateToPage('/page1', () {setState(() {});});
    }

  }

  void navigateToPage(String pagePath, VoidCallback setStateCallback) {
    print('📱 Navigating to Page $pagePath using history.pushState');


    historyPosition++;

    // Push new state to browser history with clean URL
    html.window.history.pushState(
        {'page': pagePath},
        'Page $pagePath',
        pagePath
    );

    lastPathName = html.window.location.pathname??'';



    //setState(() {});
    //RouteTracker.rebuildCurrent(context);
    setStateCallback();
  }

  bool goBack() {
    if (html.window.location.pathname != '' && html.window.location.pathname != '/') {
    //if (historyPosition > 1) {
      print('📱 Flutter back button - using history.back()');

      /*setState(() {
      });*/

      print('History position: $historyPosition');

      // Use browser's history.back()
      html.window.history.back();
      return true;
    } else {
      print('📱 No history to go back - history position: $historyPosition');
      return false;
    }
  }

  String thisPagePath = '';
  String childPageActive = '';

  @override
  Widget build(BuildContext context) {
    if (lastPathName == '/'){

    } else if (lastPathName.startsWith('/page1')) {
      if (childPageActive != '/page1') {
        childPageActive = '/page1';
        Future.microtask(() {//navigateToPage(1);
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                Page1(onNavigateToPage: navigateToPage,
                    onGoBack: goBack,
                    parentPath: thisPagePath, startPath: startPath))).then((onValue) {
              childPageActive = '';
              lastPageState = this;
              print("PAGE1 END");
            });});
      }
    }

    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
          print("BACKBUTTON");
        },
        child: Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            title: Text('Page 0'),
            backgroundColor: Colors.red,
            automaticallyImplyLeading: true, // Remove default back button
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  html.window.location.pathname?? '',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('This is the first page'),
                Text('Clean URL: /page1'),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => navigateToPage('/page1', () {setState(() {});}),
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
                  onPressed: () => navigateToPage('', () {setState(() {});}),
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
                  onPressed: () => navigateToPage('', () {setState(() {});}),
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


class Page1 extends StatefulWidget {

  final Function(String, VoidCallback) onNavigateToPage;
  final bool Function() onGoBack;
  final String parentPath; // url till parent page
  final String startPath;

  const Page1({super.key, required this.onNavigateToPage, required this.onGoBack, required this.parentPath, required this.startPath}); // url when app loaded

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {


  //Page1({Key? key, required this.onNavigateToPage, required this.onGoBack, required this.parentPath, required this.startPath}) : super(key: key);

  String thisPagePath = '/page1';
  String childPageActive = '';
  static bool pathStarted = false;

  @override
  void initState() {

    lastPageState = this;
    //super.initState();

    thisPagePath = widget.parentPath+thisPagePath;

    /*
    routes = {
      thisPagePath + '/page2' : Page2(parentPath: thisPagePath),
      thisPagePath + '/page3' : Page2(parentPath: thisPagePath),
    };

    */

    // pathStarted = WebRouter.pathInit(routes) //{return 1;}

    if (!pathStarted) { // run only once
      pathStarted = true;
      if (widget.startPath.startsWith(thisPagePath + '/page2')) {
        widget.onNavigateToPage(thisPagePath + '/page2', () {setState(() {});});
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    //childPageActive = WebRouter.navigatePath(routes);

    if (lastPathName.startsWith(thisPagePath+'/page2')) {
      if (childPageActive != '/page2') {
        childPageActive = '/page2';
        Future.microtask(() {//navigateToPage(1);
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              Page2(onNavigateToPage: widget.onNavigateToPage,
                  onGoBack: widget.onGoBack,
                  parentPath: thisPagePath, startPath: widget.startPath))).then((onValue) {
            childPageActive = '';
            lastPageState = this;
            print("PAGE1 END");
          });});
      }
    }

    return PopScope(
        canPop: true, //When false, blocks the current route from being popped.
        onPopInvokedWithResult: (didPop, result) {
          //onGoBack();
        },
        child: Scaffold(
          backgroundColor: Colors.red[100],
          appBar: AppBar(
            title: Text('Page 1'),
            backgroundColor: Colors.red,
            automaticallyImplyLeading: true, // Remove default back button
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: widget.onGoBack,
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
                  onPressed: () => widget.onNavigateToPage(thisPagePath+'/page2', () {setState(() {});}),
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

class Page2 extends StatefulWidget {

  final Function(String, VoidCallback) onNavigateToPage;
  final bool Function() onGoBack;
  final String parentPath; // url till parent page
  final String startPath;

  const Page2({super.key, required this.onNavigateToPage, required this.onGoBack, required this.parentPath, required this.startPath}); // url when app loaded

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {

  String thisPagePath = '/page2';
  String childPageActive = '';

  @override
  void initState() {

    lastPageState = this;
    //super.initState();

    thisPagePath = widget.parentPath+thisPagePath;
  }

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
              onPressed: widget.onGoBack,
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
                      onPressed: widget.onGoBack,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('← Flutter Back', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => widget.onNavigateToPage('', () {}),
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
                  onPressed: () => widget.onNavigateToPage('', () {}),
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
  final bool Function() onGoBack;

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