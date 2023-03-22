import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'ColorUtils.dart';
import 'DimensionUtils.dart';

TextStyle styleBottomNavigation = TextStyle(fontWeight:FontWeight.bold, fontSize: DimensionUtils.txt_size_body1,color: ColorUtils.primary,);
 TextStyle style = TextStyle( fontSize: DimensionUtils.txt_size_body1,color: ColorUtils.black,);
 TextStyle styleGridValue = TextStyle( fontSize: DimensionUtils.txt_size_body1,color: ColorUtils.white,);

TextStyle styleAppName = TextStyle( fontSize: DimensionUtils.txt_size_large,fontWeight:FontWeight.bold,color: ColorUtils.primary);
TextStyle styleLarge = TextStyle( fontSize: DimensionUtils.txt_size_large,fontWeight:FontWeight.bold,color: ColorUtils.primary);
TextStyle styleMedium = TextStyle( fontSize: DimensionUtils.txt_size_medium,color: ColorUtils.black,);
TextStyle buttonStyle = TextStyle( fontSize: DimensionUtils.txt_size_medium,color: ColorUtils.white,);

TextStyle styleListMedium = TextStyle(fontSize: DimensionUtils.txt_size_medium,color: ColorUtils.light_black,);
TextStyle styleListPrice = TextStyle( fontSize: DimensionUtils.txt_size_body1,color: ColorUtils.primary,);
TextStyle styleListSmall = TextStyle( fontSize: DimensionUtils.txt_size_body2,color: ColorUtils.light_black,);

TextStyle styleToggleNormal = TextStyle( fontSize: DimensionUtils.txt_size_body1,fontWeight:FontWeight.bold,color: ColorUtils.light_black,);
TextStyle styleToggleSelected = TextStyle( fontSize: DimensionUtils.txt_size_body1,fontWeight:FontWeight.bold,color: ColorUtils.primary,);

TextStyle styleListMediumBold = TextStyle(fontSize: DimensionUtils.txt_size_medium,fontWeight:FontWeight.bold,color: ColorUtils.light_black,);
TextStyle styleDrawerMenu = TextStyle(fontSize: DimensionUtils.txt_size_body1,color: ColorUtils.light_black,);
TextStyle styleDrawerFooter = TextStyle( fontSize: DimensionUtils.txt_size_body1,color: ColorUtils.red,);

TextStyle styleViewTitle = TextStyle( fontSize: DimensionUtils.txt_size_body2,fontWeight:FontWeight.bold ,color: ColorUtils.primary,);
TextStyle styleDropdownHint = TextStyle( fontSize: DimensionUtils.txt_size_body1,color: ColorUtils.grey_form,);
EdgeInsets edgeInsets=EdgeInsets.fromLTRB(DimensionUtils.margin_xxlarge, DimensionUtils.margin_xlarge, DimensionUtils.margin_xxlarge, DimensionUtils.margin_xlarge);
OutlineInputBorder outlineInputBorder=OutlineInputBorder(borderRadius: BorderRadius.circular(DimensionUtils.margin_large));

BoxDecoration dropDownDecoration= BoxDecoration(borderRadius: BorderRadius.circular( DimensionUtils.margin_medium),
 border: Border.all(color: ColorUtils.grey_form, style: BorderStyle.solid, width: 0.80), );
