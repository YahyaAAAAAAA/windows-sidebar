import 'dart:math';

enum WindowCurves {
  easeIn,
  easeOut,
  easeInOut,
  linear,
}

double easeIn(double t) => t * t;
double easeOut(double t) => 1 - pow(1 - t, 2).toDouble();
double easeInOut(double t) => t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2;

double Function(double) decideCurve(WindowCurves curve) {
  switch (curve) {
    case WindowCurves.easeIn:
      return easeIn;
    case WindowCurves.easeOut:
      return easeOut;
    case WindowCurves.easeInOut:
      return easeInOut;
    default:
      return (t) => t;
  }
}
