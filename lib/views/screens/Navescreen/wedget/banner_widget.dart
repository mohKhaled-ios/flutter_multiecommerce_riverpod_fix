import 'package:flutter/material.dart';
import 'package:multivendor_ecommerce_riverpod/controllers/banner_vontroller.dart';
import 'package:multivendor_ecommerce_riverpod/models/banner.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late Future<List<BannerModel>> futurebanner;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    futurebanner = BannerController().fetchBanners(context);

    // تفعيل الـ auto-scroll (اختياري)
    Future.delayed(Duration.zero, () {
      if (mounted) {
        _autoScroll();
      }
    });
  }

  void _autoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (_pageController.hasClients && mounted) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage %
              5, // فرضًا لديك 5 بانرات، يمكن تعديله لاحقًا حسب البيانات
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _autoScroll(); // لإعادة التكرار
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: FutureBuilder<List<BannerModel>>(
        future: futurebanner,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Banners Available"));
          } else {
            final banners = snapshot.data!;
            String baseUrl = 'http://192.168.1.3:5000';

            return PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '$baseUrl${banners[index].image}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.error),
                    ),
                    // Image.network(
                    //   banners[index].image.startsWith('http')
                    //       ? banners[index].image
                    //       : 'https://via.placeholder.com/300',
                    //   fit: BoxFit.cover,
                    //   width: double.infinity,
                    //   errorBuilder:
                    //       (context, error, stackTrace) =>
                    //           const Icon(Icons.error),
                    // ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
