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

    if (_grassData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr('StudyGrass.NoData'),
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              GrassGrid(grassData: []), // 빈 데이터로 그리드 표시
              const SizedBox(height: 16),
              _buildLegend(), // 빈 데이터일 때도 범례 표시
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        GrassGrid(grassData: _grassData),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(tr('StudyGrass.StudyTime'), style: TextStyle(fontSize: 12)),
        _buildLegendItem('0h', Colors.grey[300]!),
        _buildLegendItem('~1h', Colors.green[100]!),
        _buildLegendItem('~2h', Colors.green[300]!),
        _buildLegendItem('~4h', Colors.green[500]!),
        _buildLegendItem('4h+', Colors.green[700]!),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
