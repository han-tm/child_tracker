import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:video_player/video_player.dart';

void showFullImageOrVideoUrl(BuildContext context, String url) {
  showDialog(
    context: context,
    builder: (_) => _FullscreenImageViewer(url: url),
  );
}

class _FullscreenImageViewer extends StatelessWidget {
  final String url;

  const _FullscreenImageViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: CircleAvatar(
          backgroundColor: white,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: greyscale900,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: InteractiveViewer(
            // child: (CustomImagePicker.isVideoUrl(url))
            //     ? _VideoPlayer(url: url)
            //     : CachedClickableImage(
            //         width: double.infinity,
            //         height: double.infinity,
            //         fit: BoxFit.contain,
            //         imageUrl: url,
            //       ),
            child: FutureBuilder<bool>(
              future: CustomImagePicker.isVideoUrl(url),
              builder: (context, snapshot) {
                final result = snapshot.data;

                if (result == null) return const CircularProgressIndicator();
                if (result) {
                  return _VideoPlayer(url: url);
                } else {
                  return CachedClickableImage(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                    imageUrl: url,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  final String url;
  const _VideoPlayer({required this.url});

  @override
  State<_VideoPlayer> createState() => __VideoPlayerState();
}

class __VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isBuffering = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isBuffering = false;
          });
        }
      }).catchError((error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Не удалось воспроизвести видео: $error')),
          );
          Navigator.pop(context);
        }
      });

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
          _isBuffering = _controller.value.isBuffering;

          if (_controller.value.position == _controller.value.duration && _controller.value.duration != Duration.zero) {
            _isPlaying = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isBuffering
          ? const CircularProgressIndicator()
          : _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_controller),
                      _buildControls(),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                    ],
                  ),
                )
              : const Text('Не удалось загрузить видео.'),
    );
  }

  Widget _buildControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40.0,
              ),
              onPressed: () {
                setState(() {
                  _isPlaying ? _controller.pause() : _controller.play();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
