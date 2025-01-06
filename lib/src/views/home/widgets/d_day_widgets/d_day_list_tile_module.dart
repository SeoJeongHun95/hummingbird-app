import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../viewmodels/d_day/d_day_view_model.dart';
import 'add_d_day_dialog.dart';
import '../../../../../core/widgets/color_container_with_opacity.dart';
import 'update_d_day_dialog.dart';

class DDayListTileModule extends ConsumerWidget {
  const DDayListTileModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dDaysState = ref.watch(dDayViewModelProvider);
    final viewModel = ref.read(dDayViewModelProvider.notifier);
    return dDaysState.when(
      data: (dDays) {
        return MxNcontainer(
          MxN_rate: dDays.length > 1 ? MxNRate.TWOBYTWO : MxNRate.TWOBYONE,
          MxN_child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: dDays.length + 1,
              itemBuilder: (context, index) {
                if (index < dDays.length) {
                  final String goalTitle = dDays[index].goalTitle;
                  final int goalDate = dDays[index].goalDate;
                  final Color color =
                      Color(int.parse('0xff${dDays[index].color}'));
                  return ListTile(
                    contentPadding: EdgeInsets.only(left: 16.0),
                    dense: true,
                    leading: ColorContainerWithOpacity(
                        color: color,
                        width: 30.w,
                        alphaOfColor: 70,
                        borderRadius: 8,
                        child: Icon(
                          Icons.calendar_month,
                          color: color,
                          size: 20.w,
                        )),
                    title: Text(
                      goalTitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '목표 날짜: ${viewModel.getFormattedDate(goalDate)}',
                      style: TextStyle(fontSize: 10.sp),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          viewModel.getDDayIndicator(goalDate),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        MenuAnchor(
                          alignmentOffset: Offset(-17.w, 0),
                          menuChildren: [
                            MenuItemButton(
                              onPressed: () => _showUpdateDialog(
                                  context: context,
                                  index: index,
                                  goalTitle: goalTitle,
                                  goalDate: goalDate,
                                  color: dDays[index].color,
                                  viewModel: viewModel),
                              child: Text("편집"),
                            ),
                            MenuItemButton(
                              onPressed: () => _showDeleteDDayDialog(
                                  context: context,
                                  index: index,
                                  goalTitle: goalTitle,
                                  deleteDDay: viewModel.deleteDDay),
                              child: Text("제거"),
                            )
                          ],
                          builder: (context, controller, child) {
                            return IconButton(
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              icon: Icon(
                                Icons.more_vert,
                                size: 15.sp,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(),
                      onPressed: () => _showAddDialog(context, viewModel),
                      child: Icon(Icons.add),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }

  void _showAddDialog(context, DDayViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AddDDayDialog(viewModel: viewModel);
      },
    );
  }

  void _showUpdateDialog(
      {required BuildContext context,
      required String goalTitle,
      required int index,
      required int goalDate,
      required String color,
      required DDayViewModel viewModel}) {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateDDayDialog(
            goalTitle: goalTitle,
            index: index,
            goalDate: goalDate,
            color: color,
            viewModel: viewModel);
      },
    );
  }

  void _showDeleteDDayDialog(
      {required BuildContext context,
      required int index,
      required String goalTitle,
      required void Function(int) deleteDDay}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("제거"),
          content: Text("정말로 '$goalTitle'을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("취소"),
            ),
            TextButton(
                onPressed: () {
                  deleteDDay(index);
                  Navigator.pop(context);
                },
                child: Text("확인"))
          ],
        );
      },
    );
  }
}
