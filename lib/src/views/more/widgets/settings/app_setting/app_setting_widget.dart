import 'package:flutter/material.dart';

import '../../../../../../core/enum/mxnRate.dart';
import '../../../../../../core/widgets/mxnContainer.dart';
import 'select_font_size_button_widget.dart';
import 'select_language_button_widget.dart';

class AppSettingWidget extends StatelessWidget {
  const AppSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYONE,
      MxN_child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            // SelectThemeButtonWidget(),
            // Divider(),
            SelectLanguageButtonWidget(),
            Divider(),
            SelectFontSizeButtonWidget(),
          ],
        ),
      ),
    );
  }
}
