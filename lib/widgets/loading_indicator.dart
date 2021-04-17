import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final sizeLoadingIndicator = MediaQuery.of(context).size.shortestSide * 0.3;
    return Center(
      child: SizedBox(
        height: sizeLoadingIndicator,
        width: sizeLoadingIndicator,
        child: CircularProgressIndicator(
          strokeWidth: 10,
        ),
      ),
    );
  }
}
