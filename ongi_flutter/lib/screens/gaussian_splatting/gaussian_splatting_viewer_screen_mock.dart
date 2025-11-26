import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/gaussian_splatting_provider.dart';

/// 가우시안 스플래팅 뷰어 **목업 화면**
/// Unity 없이 UI 흐름만 테스트하기 위한 임시 화면
class GaussianSplattingViewerScreenMock extends StatefulWidget {
  final String modelId;
  final String modelUrl;
  final String? modelName;
  final String? description;

  const GaussianSplattingViewerScreenMock({
    Key? key,
    required this.modelId,
    required this.modelUrl,
    this.modelName,
    this.description,
  }) : super(key: key);

  @override
  _GaussianSplattingViewerScreenMockState createState() =>
      _GaussianSplattingViewerScreenMockState();
}

class _GaussianSplattingViewerScreenMockState
    extends State<GaussianSplattingViewerScreenMock> {
  static const String _headerImagePath = 'assets/images/eaves.png';
  bool _isLoading = true;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _simulateDownload();
  }

  /// 다운로드 시뮬레이션
  Future<void> _simulateDownload() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    // 다운로드 진행률 시뮬레이션
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _downloadProgress = i / 100.0;
        });
      }
    }

    setState(() {
      _isDownloading = false;
      _isLoading = false;
    });

    // Provider 상태 업데이트
    if (mounted) {
      Provider.of<GaussianSplattingProvider>(context, listen: false)
          .setViewerReady(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? _buildLoadingScreen()
                : _buildMockViewer(),
          ),
          if (widget.description != null) _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Image.asset(
          _headerImagePath,
          width: double.infinity,
          height: 120,
          fit: BoxFit.cover,
        ),
        SafeArea(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  widget.modelName ?? '가우시안 스플래팅 뷰어',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('카메라 리셋 (목업)')),
                  );
                },
                tooltip: '카메라 리셋',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isDownloading) ...[
              CircularProgressIndicator(
                value: _downloadProgress,
                backgroundColor: Colors.grey.shade700,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 24),
              const Text(
                '모델 다운로드 중...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_downloadProgress * 100).toInt()}%',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ] else ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              const Text(
                'Unity 엔진 초기화 중...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMockViewer() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.view_in_ar,
              size: 120,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              '🎨 가우시안 스플래팅 뷰어 (목업)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Model ID: ${widget.modelId}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '실제 Unity 뷰어는 여기에 표시됩니다',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: Column(
                children: const [
                  Text(
                    '💡 조작 방법',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1-finger 드래그: 회전\n2-finger 핀치: 줌\n우측 상단 버튼: 카메라 리셋',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.7),
      child: Text(
        widget.description!,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
