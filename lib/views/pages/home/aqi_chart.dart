import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/color_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

class AqiChartView extends StatelessWidget {
  final WeatherModelEntity entity;

  const AqiChartView({
    Key key,
    @required this.entity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = (1.wp -
            DimenConstant.cardMarginStartEnd * 2 -
            DimenConstant.dayMiddleMargin) /
        2;
    var height = DimenConstant.aqiChartHeight;
    int aqiValue = entity?.result?.realtime?.airQuality?.aqi?.chn;
    String aqiValueStr = aqiValue == null ? "0" : "$aqiValue";
    double aqiRatio = aqiValue == null ? 0 : aqiValue.toDouble() / 500;
    double humidityValue = entity?.result?.realtime?.humidity??0;
    String humidityStr = "${(humidityValue * 100).toInt()}%";

    return Row(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DimenConstant.cardRadius),
            color: ColorUtils.parse("#33ffffff"),
          ),
          child: CustomPaint(
            painter: AqiChartPainter(aqiRatio, aqiValueStr,
                entity?.result?.realtime?.airQuality?.description?.chn),
          ),
        ),
        SizedBox(
          width: DimenConstant.dayMiddleMargin,
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DimenConstant.cardRadius),
            color: ColorUtils.parse("#33ffffff"),
          ),
          child: CustomPaint(
            painter: AqiChartPainter(humidityValue, humidityStr, "体感"),
          ),
        ),
      ],
    );
  }
}

class AqiChartPainter extends CustomPainter {
  Paint _paint = Paint();
  Path _path = Path();
  double ratio;
  String value;
  String desc;

  AqiChartPainter(this.ratio, this.value, this.desc);

  @override
  void paint(Canvas canvas, Size size) {
    weatherPrint("AqiChartPainter size:$size");
    var radius = size.height / 2 - 10;
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var centerOffset = Offset(centerX, centerY);
    _path.reset();
    _path.addArc(Rect.fromCircle(center: centerOffset, radius: radius),
        pi * 0.7, pi * 1.6);
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 4;
    _paint.strokeCap = StrokeCap.round;
    _paint.color = Colors.white38;
    canvas.drawPath(_path, _paint);
    _path.reset();
    _path.addArc(Rect.fromCircle(center: centerOffset, radius: radius),
        pi * 0.7, pi * 1.6 * ratio);
    _paint.color = Colors.white;
    canvas.drawPath(_path, _paint);

    var valuePara = getParagraph(value, 30);
    canvas.drawParagraph(
        valuePara,
        Offset(centerOffset.dx - valuePara.width / 2,
            centerOffset.dy - valuePara.height / 2));

    var descPara = getParagraph("$desc", 15);
    canvas.drawParagraph(
        descPara,
        Offset(centerOffset.dx - valuePara.width / 2,
            centerOffset.dy + valuePara.height / 2));
  }

  ui.Paragraph getParagraph(String text, double textSize,
      {Color color = Colors.white}) {
    var pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center, //居中
      fontSize: textSize, //大小
    ));
    pb.addText(text);
    pb.pushStyle(ui.TextStyle(color: color));
    var paragraph = pb.build()..layout(ui.ParagraphConstraints(width: 100));
    return paragraph;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
