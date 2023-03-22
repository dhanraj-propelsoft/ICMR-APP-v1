import 'package:flutter/material.dart';
class GifProgressWidget extends StatelessWidget {
  final bool ? progress;
  final Widget ? child;

  const GifProgressWidget({Key? key, this.progress, this.child}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child!,
       progress!? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black87,
          child: Center(
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.all(Radius.circular(20))
                    shape: BoxShape.circle
                ),
                child: Image.asset("assets/images/progress.gif",)),
          ),
        ):const SizedBox(),
      ],
    );
  }
}
