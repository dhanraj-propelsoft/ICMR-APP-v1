
import 'package:flutter/material.dart';
import 'package:wapindex/utils/DimensionUtils.dart';
import 'package:wapindex/utils/StyleUtils.dart';


class SubmitAndContinueButton extends StatelessWidget {
  final Function()? onTab;
  final String ? text;
  final Color ? gradientColor1;
  final Color ? gradientColor2;
  final bool ? iconTrueOrFalse;
  const SubmitAndContinueButton({Key? key,this.iconTrueOrFalse,required this.onTab,required this.text,required this.gradientColor1,required this.gradientColor2}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child:Row(
          mainAxisSize: MainAxisSize.min,
          children:<Widget> [
            SizedBox(
              height: DimensionUtils.height_button,
              child: InkWell(
                  onTap: onTab,
                  child:Container(
                    decoration: BoxDecoration(
                        gradient:
                        LinearGradient(colors: [gradientColor1!, gradientColor2!],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(DimensionUtils.margin_xlarge)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.fromLTRB(DimensionUtils.margin_xxlarge, DimensionUtils.margin_large, DimensionUtils.margin_xxlarge, DimensionUtils.margin_large),
                      child: Container(
                        alignment: Alignment.center,
//                        width: 200,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: DimensionUtils.margin_xxlarge,),
                            Text(text!,
                              textAlign: TextAlign.center,
                              style: buttonStyle.copyWith(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: DimensionUtils.margin_xxlarge,),
                          ],
                        ),
                      ),
                    ),
                  )),

            )
          ],)
    );
  }
}
