
import 'package:flutter/material.dart';
class MeasureView extends StatelessWidget {
  const MeasureView({super.key, required this.measurment});
  final List<dynamic> measurment;

  // //FIXME: this function only for simulation purposes
  // int getRandomNumber() {
  //   // Simulate a random number for length and weight
  //   return (25 +
  //       (100 * (0.5 - (DateTime.now().millisecondsSinceEpoch % 100) / 100)))
  //       .toInt();
  // }

  String getNextMeasurementDate() {
    final DateTime nextDate = DateTime.now().add(const Duration(days: 90));
    return "${nextDate.day.toString().padLeft(2, '0')}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Resultaten van de meting",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Text(
          "Gewicht: ${measurment[0]} cm\n Lengte: ${measurment[1]} kg\n",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        const SizedBox(height: 10),
        Text(
          "Het volgende meting wordt verwacht op:\n ${getNextMeasurementDate()}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}