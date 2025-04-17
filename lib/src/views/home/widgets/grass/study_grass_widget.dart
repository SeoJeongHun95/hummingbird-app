import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _loadStudyTimeData();
  }

  Future<void> _loadStudyTimeData() async {
    try {
      final data = await _studyTimeService.getStudyTimeData();
      setState(() {
        _grassData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading study time data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
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
        const Text('학습시간: ', style: TextStyle(fontSize: 12)),
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
