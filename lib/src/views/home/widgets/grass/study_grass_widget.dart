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
        _buildLegendItem('0', const Color(0xFF242424)),
        _buildLegendItem('1-2', const Color(0xFF0E4429)),
        _buildLegendItem('3-4', const Color(0xFF006D32)),
        _buildLegendItem('5+', const Color(0xFF26A641)),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
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
