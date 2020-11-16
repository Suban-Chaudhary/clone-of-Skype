import 'package:flutter/material.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an Customize AppBar Widget
  /// With the property of title, action, leading & centerTitle
  /// Here actions are list of widgets mostly of icons.
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar(
      {Key key,
      @required this.title,
      @required this.actions,
      @required this.leading,
      @required this.centerTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: UniversalVariables.blackColor,
        border: Border(
          bottom: BorderSide(
            color: UniversalVariables.separatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: UniversalVariables.blackColor,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }
  final Size preferredSize = const Size.fromHeight(kToolbarHeight+10);
}
