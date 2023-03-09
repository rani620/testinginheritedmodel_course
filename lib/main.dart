import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:math' show Random;
import 'dart:developer' as devtools show log;

// simple flutter scaffold code snipet
void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primaryColor: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var color1 = Colors.yellow;
  var color2 = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: AvailableColorsWidget(
        color1: color1,
        color2: color2,
        child: Column(children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      color1 = colors.getRandomeElement();
                    }
                    );
                  },
                  child: const Text('Chnage color1')),
              TextButton(onPressed: () {
                  setState(() {
                      color2 = colors.getRandomeElement();
                    }
                    );
              }, child: const Text('Chnage color2'))
            ],
          ),
          const ColorWidget(color: AvailableColors.one,),
           const ColorWidget(color: AvailableColors.one,)
        ]),
      ), // it is a peoxy widget
    );
  }
}

enum AvailableColors { one, two }

//creating first inherited model{T = it tells about the generic type
//}
class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1; // these are the provider
  final MaterialColor color2;

  const AvailableColorsWidget({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(key: key, child: child);

  static AvailableColorsWidget of(
      BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(context,
        aspect: aspect)!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    devtools.log('updateShouldNotify');
    // TODO: implement updateShouldNotify
    // throw UnimplementedError();
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorsWidget oldWidget,
      Set<AvailableColors> dependencies) {
    devtools.log('updateShouldNotifyDependent');
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }
    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        // TODO: Handle this case.
        devtools.log('Color1 widget got reuilt!');
        break;
      case AvailableColors.two:
        // TODO: Handle this case.
        devtools.log('Color2 widget got rebuilt!');
        break;
    }
    final provider = AvailableColorsWidget.of(
      context,
      color,
    );
    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}

// set the array  of colors
final colors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.brown,
  Colors.amber,
  Colors.deepPurple,
];
//final color = colors.getRandomeElement();

// seting the random color selection
extension RandomElement<T> on Iterable<T> {
  T getRandomeElement() => elementAt(
        Random().nextInt(length),
      );
}
