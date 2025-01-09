import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hummingbird/src/views/statistics/widgets/chart_scroll_view.dart';

class TimePeriodSegmentedButton<T> extends StatelessWidget {
  const TimePeriodSegmentedButton(
      {super.key,
      required this.selected,
      required this.options,
      required this.labels,
      required this.width,
      required this.height,
      required this.selectedColor,
      required this.selectedForegroundColor,
      required this.backgroundColor,
      required this.foregroundColor,
      this.labelStyle,
      required this.boxShadowColor,
      required this.onSelected});

  final PeriodOption selected;
  final List<T> options;
  final List<String> labels;
  final double width;
  final double height;
  final Color selectedColor;
  final Color selectedForegroundColor;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle? labelStyle;
  final Color boxShadowColor;
  final void Function(int newSelcted) onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = options.indexWhere((element) => element == selected);
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(1.8.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            left: selectedIndex * (width / labels.length),
            top: 0,
            bottom: 0,
            child: Container(
              width: width / labels.length - 3.6.w,
              height: height - 10.w,
              decoration: BoxDecoration(
                border: Border.all(color: selectedColor, width: 0.5),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: boxShadowColor,
                    blurRadius: 0.5,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                  )
                ],
              ),
            ),
          ),
          ...List.generate(labels.length, (index) {
            return Positioned(
              top: 0,
              bottom: 0,
              left: index * (width / labels.length),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(index),
                child: SizedBox(
                  width: width / labels.length - 3.6.w,
                  child: Center(
                    child: Text(
                      labels[index],
                      style: labelStyle?.copyWith(
                        color: selectedIndex == index
                            ? selectedForegroundColor
                            : foregroundColor,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// class TimePeriodSegmentedButton extends StatefulWidget {
  

  

//   @override
//   State<TimePeriodSegmentedButton> createState() =>
//       _TimePeriodSegmentedButtonState();
// }

// class _TimePeriodSegmentedButtonState extends State<TimePeriodSegmentedButton> {
//   int selectedIndex = 0;
//   final List<String> options = ['주간', '월간'];

//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = switch (widget.option) {
//       PeriodOption.weekly => 0,
//       _ => 1,
//     };
//   }

//   void onSelected(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }

  
// }
