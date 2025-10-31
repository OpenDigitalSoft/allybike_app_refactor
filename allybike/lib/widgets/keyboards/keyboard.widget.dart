import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyBoard extends StatelessWidget {
  final List<String> keys = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "",
    "0",
    "<",
  ];
  final Function(String) onChanged;
  final Function(bool) onDelete;
  KeyBoard({required this.onChanged, required this.onDelete,super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 20,
      children: [
        ...keys.map((text) => GestureDetector(
              onTap: () => _onTap(text),
              child: Container(
                     color: Colors.transparent,
                     width: MediaQuery.of(context).size.width / 3 - 30,
                     child: Center(
                            child: Text(text, 
                                   style: const TextStyle(fontSize: 40)
                                   )
                             )
                     ),
            ))
      ],
    );
  }

  _onTap(String text) {
    SystemSound.play(SystemSoundType.click);
    if (text.isEmpty) {
      return;
    }
    if (text == "<") {
      onDelete.call(true);
      return;
    }
    onChanged.call(text);
  }
}