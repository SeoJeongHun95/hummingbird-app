import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../models/grass/grass_data_model.dart';
import '../../../../services/study_time_service.dart';
import 'grass_grid.dart';

class StudyGrassWidget extends StatefulWidget {
  const StudyGrassWidget({super.key});

  @override
  State<StudyGrassWidget> createState() => _StudyGrassWidgetState();
}

class _StudyGrassWidgetState extends State<StudyGrassWidget> {
  final StudyTimeService _studyTimeService = StudyTimeService();
  List<GrassDataModel> _grassData = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStudyTimeData();
  }

  Future<void> _loadStudyTimeData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _studyTimeService.getStudyTimeData();

      if (mounted) {
        setState(() {
          _grassData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
          _grassData = [];
        });
      }
      print('Error loading study time data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr('StudyGrass.Error'),
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _loadStudyTimeData,
                child: Text(tr('Common.Retry')),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GrassGrid(grassData: _grassData),
      ],
    );
  }
}
