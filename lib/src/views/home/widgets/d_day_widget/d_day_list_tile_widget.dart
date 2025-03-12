import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/color_container_with_opacity.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../viewmodels/d_day/d_day_view_model.dart';

class DDayListTileWidget extends ConsumerWidget {
  const DDayListTileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dDayScreenState = ref.watch(dDayViewModelProvider);
    final viewModel = ref.read(dDayViewModelProvider.notifier);

    return dDayScreenState.when(
      data: (state) {
        final (dDays) = state;
        return MxNcontainer(
          MxN_rate: MxNRate.TWOBYTWO,
          MxN_child: Container(
            color: Colors.white,
            child: dDays.isNotEmpty
                ? ListView.builder(
                    itemCount: dDays.length + 1,
                    itemBuilder: (context, index) {
                      if (index < dDays.length) {
                        final String dDayId = dDays[index].ddayId!;
                        final String goalTitle = dDays[index].title;
                        final int goalDate = dDays[index].targetDatetime;
                        final Color color =
                            Color(int.parse('0xff${dDays[index].color}'));
                        return ListTile(
                          contentPadding: EdgeInsets.only(left: 16.0),
                          dense: true,
                          leading: ColorContainerWithOpacity(
                            color: color,
                            width: 30.w,
                            alphaOfColor: 70,
                            child: Icon(
                              Icons.calendar_month,
                              color: color,
                              size: 20.w,
                            ),
                          ),
                          title: Text(
                            goalTitle,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${tr("DDayListTile.GoalDate")}${viewModel.getFormattedDate(goalDate)}',
                            style: TextStyle(fontSize: 10.sp),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                viewModel.getDDayIndicator(goalDate),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              MenuAnchor(
                                alignmentOffset: Offset(-17.w, 0),
                                style: MenuStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                ),
                                menuChildren: [
                                  MenuItemButton(
                                    onPressed: () {
                                      context.push(
                                        '/dDayUpdate',
                                        extra: {
                                          'index': index,
                                          'dDayId': dDayId,
                                          'title': goalTitle,
                                          'color': dDays[index].color,
                                          'targetDatetime': goalDate,
                                        },
                                      );
                                    },
                                    child: Text(tr("DDayListTile.Edit")),
                                  ),
                                  MenuItemButton(
                                    onPressed: () => _showDeleteDDayDialog(
                                      context: context,
                                      index: index,
                                      goalTitle: goalTitle,
                                      dDayId: dDays[index].ddayId ?? '',
                                      deleteDDay: viewModel.deleteDDay,
                                    ),
                                    child: Text(tr("DDayListTile.Delete")),
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
                                      size: 16.sp,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 20.w),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              fixedSize: Size(300.w, 20.w),
                            ),
                            onPressed: () {
                              context.push('/dDayAdd');
                            },
                            child: Icon(Icons.add),
                          ),
                        );
                      }
                    },
                  )
                : Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(300.w, 20.w),
                      ),
                      onPressed: () {
                        context.push('/dDayAdd');
                      },
                      child: Icon(Icons.add),
                    ),
                  ),
          ),
        );
      },
      error: (error, stackTrace) => MxNcontainer(
        MxN_rate: MxNRate.TWOBYTWO,
        MxN_child: Center(
          child: Text('$error'),
        ),
      ),
      loading: () => MxNcontainer(
        MxN_rate: MxNRate.TWOBYTWO,
        MxN_child: Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void _showDeleteDDayDialog(
      {required BuildContext context,
      required int index,
      required String goalTitle,
      required String dDayId,
      required void Function(int, String) deleteDDay}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tr("DDayListTile.Delete")),
          content: Text(
              "${tr("DDayListTile.AreYouSure")}$goalTitle'${tr("DDayListTile.DeleteConfirmationSuffix")}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr("DDayListTile.Cancel")),
            ),
            TextButton(
                onPressed: () {
                  deleteDDay(index, dDayId);
                  Navigator.pop(context);
                },
                child: Text(tr("DDayListTile.Confirm")))
          ],
        );
      },
    );
  }

  void showOnOfflineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tr("DDayListTile.OfflineEditDeleteError"),
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("DDayListTile.Confirm"),
            ),
          ],
        );
      },
    );
  }

  Widget get onOfflineContainer => Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 60.w,
            ),
            Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            SizedBox(
              width: 12.w,
            ),
            Text(
              tr("DDayListTile.OfflineStatus"),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
