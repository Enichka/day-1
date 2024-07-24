import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: FirstPage());
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  static const images = [
    'images/image1.jpg',
    'images/image2.jpg',
    'images/image3.jpg',
    'images/image4.jpg',
    'images/image5.jpg',
    'images/image6.jpg',
    'images/image7.jpg',
    'images/image8.jpg',
    'images/image9.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('images/logo/postogram.png', 
          fit: BoxFit.contain,
          height: 50,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset('images/logo/3point.svg'),
            padding: const EdgeInsets.all(8.0),
            onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                  return Container(
                    height: 161, // Устанавливаем фиксированную высоту
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            leading: SvgPicture.asset(
                              'images/logo/light_mode.svg',
                              width: 326,
                              height: 42,
                            ),
                            title: const Text('Тема'),
                          ),
                          ListTile(
                            leading: SvgPicture.asset(
                              'images/logo/upload_cloud.svg',
                              width: 185,
                              height: 35,
                            ),
                            title: const Text('Загрузить фото...'),                          
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(
          images.length,
          (index) => _GridItem(index: index, images: images),
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final int index;
  final List<String> images;

  const _GridItem({required this.index, required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => ExampleApp(initialPage: index, images: images),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Image.asset(
          images[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ExampleApp extends StatefulWidget {
  final List<String> images;
  final int initialPage;

  const ExampleApp({super.key, required this.images, this.initialPage = 0});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  static const _defaultAnimDuration = Duration(milliseconds: 300);

  late int currentPage = widget.initialPage;

  late final _pageController = PageController(
    initialPage: currentPage,
    viewportFraction: 0.6,
  );

  @override
  void initState() {
    _pageController.addListener(_onPageChanged);
    super.initState();
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final prevPage = currentPage;
    currentPage = _pageController.page?.round() ?? currentPage;
    if (prevPage != currentPage) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Date'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${currentPage + 1}/${widget.images.length}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        itemBuilder: (_, i) => Center(
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: currentPage == i ? 1 : 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () => _pageController.animateToPage(
                  i,
                  duration: _defaultAnimDuration,
                  curve: Curves.easeIn,
                ),
                child: _PageViewItem(image: widget.images[i]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageViewItem extends StatelessWidget {
  final String image;

  const _PageViewItem({
    required this.image,
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 600,
        width: 312,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}