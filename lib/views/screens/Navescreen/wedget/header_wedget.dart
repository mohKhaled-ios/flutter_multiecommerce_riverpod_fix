// import 'package:flutter/material.dart';

// class HeaderWedget extends StatelessWidget {
//   const HeaderWedget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * 0.20,
//       child: Stack(
//         children: [
//           Image.asset(
//             'assets/icons/searchBanner.jpeg',
//             width: MediaQuery.of(context).size.width,
//             fit: BoxFit.cover,
//           ),
//           Positioned(
//             left: 48,
//             top: 68,
//             child: SizedBox(
//               height: 50,
//               width: 250,
//               child: TextField(
//                 onTap: () {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (context){
//                     return ProductSearchScreen()
//                   });
//                   },

//                 //controller: _searchController,
//                 decoration: InputDecoration(
//                   hintText: ' Enter text...',
//                   hintStyle: TextStyle(fontSize: 14, color: Color(0xFF7F7F7F)),
//                   prefixIcon: Image.asset('assets/icons/searc1.png'),
//                   suffixIcon: Image.asset('assets/icons/cam.png'),
//                   fillColor: Colors.grey.shade200,
//                   filled: true,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 16,
//                   ),
//                   focusColor: Colors.black,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 311,
//             top: 78,
//             child: Material(
//               type: MaterialType.transparency,
//               child: InkWell(
//                 onTap: () {

//                 },
//                 overlayColor: MaterialStateProperty.all(Color(0x0c7f7f)),
//                 child: Ink(
//                   height: 31,
//                   width: 31,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     image: DecorationImage(
//                       image: AssetImage('assets/icons/bell.png'),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 354,
//             top: 78,
//             child: Material(
//               type: MaterialType.transparency,
//               child: InkWell(
//                 onTap: () {},
//                 overlayColor: MaterialStateProperty.all(Color(0x0c7f7f)),
//                 child: Ink(
//                   height: 31,
//                   width: 31,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     image: DecorationImage(
//                       image: AssetImage('assets/icons/message.png'),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:multivendor_ecommerce_riverpod/views/screens/search_screen_product.dart';

class HeaderWedget extends StatelessWidget {
  const HeaderWedget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.20,
      child: Stack(
        children: [
          Image.asset(
            'assets/icons/searchBanner.jpeg',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 48,
            top: 68,
            child: SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductSearchScreen(),
                    ),
                  );
                },
                decoration: InputDecoration(
                  hintText: ' Enter text...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F7F7F),
                  ),
                  prefixIcon: Image.asset('assets/icons/searc1.png'),
                  suffixIcon: Image.asset('assets/icons/cam.png'),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  focusColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 311,
            top: 78,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                overlayColor: WidgetStateProperty.all(const Color(0x000c7f7f)),
                child: Ink(
                  height: 31,
                  width: 31,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/icons/bell.png'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 354,
            top: 78,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                overlayColor: WidgetStateProperty.all(const Color(0x000c7f7f)),
                child: Ink(
                  height: 31,
                  width: 31,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/icons/message.png'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
