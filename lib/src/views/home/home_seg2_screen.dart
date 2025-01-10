import 'package:flutter/material.dart';

import 'widgets/d_day_widgets/d_day_list_tile_module.dart';

//Dday
class Seg2Screen extends StatelessWidget {
  const Seg2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DDayListTileModule(),
      ],
    );
  }
}
