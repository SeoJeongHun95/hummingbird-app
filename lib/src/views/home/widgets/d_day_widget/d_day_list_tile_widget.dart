import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/color_container_with_opacity.dart';
import '../../../../../core/widgets/mxnContainer.dart';
import '../../../../providers/d_day/d_day_screen_state_provider.dart';
import '../../../../viewmodels/d_day/d_day_view_model.dart';
import 'add_d_day_dialog.dart';
import 'update_d_day_dialog.dart';

class DDayListTileWidget extends ConsumerWidget {
  const DDayListTileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dDayScreenState = ref.watch(dDayScreenStateProvider);
    final viewModel = ref.read(dDayViewModelProvider.notifier);

    return dDayScreenState.when(
      data: (state) {
        final (dDays, isConnected) = state;
        return MxNcontainer(
          MxN_rate: MxNRate.TWOBYTWO,
          MxN_child: Container(
            color: Colors.white,
            child: dDays.isNotEmpty
                ? ListView.builder(
                    itemCount: dDays.length + 1,
                    itemBuilder: (context, index) {
                      if (index < dDays.length) {
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
                              isConnected
                                  ? MenuAnchor(
                                      alignmentOffset: Offset(-17.w, 0),
                                      menuChildren: [
                                        MenuItemButton(
                                          onPressed: () => _showUpdateDialog(
                                              context: context,
                                              index: index,
                                              dDayId: dDays[index].ddayId!,
                                              goalTitle: goalTitle,
                                              goalDate: goalDate,
                                              color: dDays[index].color,
                                              viewModel: viewModel),
                                          child: Text("DDayListTile.Edit"),
                                        ),
                                        MenuItemButton(
                                          onPressed: () =>
                                              _showDeleteDDayDialog(
                                            context: context,
                                            index: index,
                                            goalTitle: goalTitle,
                                            dDayId: dDays[index].ddayId ?? '',
                                            deleteDDay: viewModel.deleteDDay,
                                          ),
                                          child:
                                              Text(tr("DDayListTile.Delete")),
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
                                    )
                                  : IconButton(
                                      onPressed: () =>
                                          showOnOfflineDialog(context),
                                      icon: Icon(
                                        Icons.more_vert,
                                        size: 16.sp,
                                      ),
                                    ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 20.w),
                          child: isConnected
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    fixedSize: Size(300.w, 20.w),
                                  ),
                                  onPressed: () =>
                                      _showAddDialog(context, viewModel),
                                  child: Icon(Icons.add),
                                )
                              : onOfflineContainer,
                        );
                      }
                    },
                  )
                : Center(
                    child: isConnected
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              fixedSize: Size(300.w, 20.w),
                            ),
                            onPressed: () => _showAddDialog(context, viewModel),
                            child: Icon(Icons.add),
                          )
                        : onOfflineContainer,
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
      required String dDayId,
      required int goalDate,
      required String color,
      required DDayViewModel viewModel}) {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateDDayDialog(
            goalTitle: goalTitle,
            index: index,
            dDayId: dDayId,
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
              child: Text("DDayListTile.Cancel"),
            ),
            TextButton(
                onPressed: () {
                  deleteDDay(index, dDayId);
                  Navigator.pop(context);
                },
                child: Text("DDayListTile.Confirm"))
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
