import 'package:flutter/material.dart';

class PinchZoomImage extends StatefulWidget {
  const PinchZoomImage({Key? key}) : super(key: key);

  @override
  State<PinchZoomImage> createState() => _PinchZoomImageState();
}

class _PinchZoomImageState extends State<PinchZoomImage>
    with SingleTickerProviderStateMixin {
  late TransformationController _controller;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  final double _minScale = 1.0;
  final double _maxScale = 4.0;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() => _controller.value = _animation!.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 25, 9, 28),
              Color.fromARGB(255, 93, 10, 38),
              Color.fromARGB(255, 167, 68, 103),
            ],
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: InteractiveViewer(
              transformationController: _controller,
              clipBehavior: Clip.none,
              panEnabled: false,
              minScale: _minScale,
              maxScale: _maxScale,
              onInteractionEnd: (details) {
                resetAnimation();
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1524338198850-8a2ff63aaceb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8d2F0ZXJmYWxsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetAnimation() {
    _animation = Matrix4Tween(
      begin: _controller.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInBack,
    ));
    _animationController.forward(from: 0);
  }
}
