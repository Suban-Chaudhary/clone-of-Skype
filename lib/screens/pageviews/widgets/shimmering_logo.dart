import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Shimmer.fromColors(child: Image.asset("assets/app_logo.png"), baseColor: UniversalVariables.blackColor, highlightColor: Colors.white),
    );
  }
}