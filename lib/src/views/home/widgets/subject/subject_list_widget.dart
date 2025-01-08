import 'package:flutter/material.dart';

import '../../../../../core/enum/mxnRate.dart';
import '../../../../../core/widgets/mxnContainer.dart';

class SubjectListWidget extends StatelessWidget {
  const SubjectListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MxNcontainer(
      MxN_rate: MxNRate.TWOBYTWO,
      MxN_child: Center(
        child: Text("과목리스트"),
      ),
    );
  }
}
