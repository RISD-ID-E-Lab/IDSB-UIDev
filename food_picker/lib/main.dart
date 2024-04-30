import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Picker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Food Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _optionTextEditingController = TextEditingController();

  final List _options = List.empty(growable: true);

  void _addOption({required String value}) {
    setState(() {
      _options.add(value);
      _optionTextEditingController.clear();
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
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          if (_options.isNotEmpty)
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                var choice = Random().nextInt(_options.length);
                return Result(result: _options[choice]);
              }))
            }
        },
        label: const Text("Make a choice!"),
        icon: const Icon(Icons.emoji_food_beverage),
      ),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 80, bottom: 40, left: 20, right: 20),
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 255, 218, 240)),
            child: Text(
              "Food Picker",
              style: GoogleFonts.robotoSlab(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 80, height: 1.1)),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 350,
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Enter option",
                    suffix: ElevatedButton(
                      child: const Text("Add"),
                      onPressed: () => {
                        _addOption(
                            value: _optionTextEditingController.value.text)
                      },
                    )),
                onSubmitted: (value) {
                  _addOption(value: value);
                },
                controller: _optionTextEditingController,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(20),
              childAspectRatio: 1.5,
              children: List.generate(_options.length, (index) {
                return Hero(
                  tag: _options[index],
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.deepPurple.shade100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _options[index],
                            style: GoogleFonts.robotoSlab(
                                textStyle: const TextStyle(fontSize: 20)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _options.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete),
                            iconSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class Result extends StatefulWidget {
  const Result({super.key, required this.result});
  final String result;

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  double scale = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
          },
          label: const Text('Go back')),
      body: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            setState(() {
              scale = 1.075;
            });
          },
          onTapUp: (details) {
            setState(() {
              scale = 1;
            });
          },
          child: Hero(
            tag: widget.result,
            child: PhysicalModel(
              color: Colors.deepPurple.shade100,
              elevation: 8,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                  duration: Durations.short2,
                  height: scale * 400,
                  width: MediaQuery.of(context).size.width * 0.75 * scale,
                  child: Center(
                      child: Text(
                    widget.result,
                    style: GoogleFonts.robotoSlab(
                        textStyle: const TextStyle(fontSize: 40)),
                  ))),
            ),
          ),
        ),
      ),
    );
  }
}
