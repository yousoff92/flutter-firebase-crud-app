/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<BarChartItem, String>> _createSampleData() {
    final data = [
      new BarChartItem('2014', 5),
      new BarChartItem('2015', 25),
      new BarChartItem('2016', 100),
      new BarChartItem('2017', 75),
    ];

    return [
      new charts.Series<BarChartItem, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BarChartItem sales, _) => sales.key,
        measureFn: (BarChartItem sales, _) => sales.value,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class BarChartItem {
  final String key;
  final num value;

  BarChartItem(this.key, this.value);
}