import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class TagButton extends StatefulWidget {
  const TagButton({
    Key key,
    this.tagTitle,
    this.searchCategory,
  }) : super(key: key);

  final String tagTitle;
  final String searchCategory;
  static bool isSelect = false;

  @override
  _TagButtonState createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {
  void _isSelect() {
    setState(() {
      TagButton.isSelect = !TagButton.isSelect;
    });
    print(TagButton.isSelect);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(
            color: (TagButton.isSelect) ? PrimaryColor : Colors.grey,
            width: 2,
          ),
          color: (TagButton.isSelect) ? PrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.tagTitle,
            style: (TagButton.isSelect) ? Caption1 : Caption1Grey,
          ),
          onPressed: _isSelect,
        ),
      ),
    );
  }
}
