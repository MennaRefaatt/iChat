import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

extension ResponsiveSized on num {
  SizedBox get hSpace => SizedBox(height: h);

  SizedBox get wSpace => SizedBox(width: w);
}
