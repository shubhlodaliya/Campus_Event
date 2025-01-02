// import 'package:flutter/material.dart';
//
// import 'home_page.dart';
// import 'login_page.dart';
//
// class Splash extends StatefulWidget {
//   @override
//   _SplashState createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//   @override
//   void initState() {
//     super.initState();
//     // Navigate to the next screen after 3 seconds
//     Future.delayed(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/splash.png', // Replace with your asset path
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Centered animated logo
//           Center(
//             child: AnimatedLogo(),
//           ),
//           // Loader at the bottom
//           Positioned(
//             bottom: 20,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: CircularProgressIndicator(
//
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Customize color
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AnimatedLogo extends StatefulWidget {
//   @override
//   _AnimatedLogoState createState() => _AnimatedLogoState();
// }
//
// class _AnimatedLogoState extends State<AnimatedLogo>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true); // Repeats animation in reverse
//     _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaleTransition(
//       scale: _animation,
//       child: Image.asset(
//         'assets/images/logo.png', // Replace with your logo asset path
//         width: 150,
//         height: 150,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'student/student_home.dart';
import 'login_page.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    // Simulate loading time
    await Future.delayed(Duration(seconds: 3));

    // Check login status
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate to HomePage if logged in, otherwise to LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? HomePage() : LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash.png', // Replace with your asset path
              fit: BoxFit.cover,
            ),
          ),
          // Centered animated logo
          Center(
            child: AnimatedLogo(),
          ),
          // Loader at the bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Customize color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedLogo extends StatefulWidget {
  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeats animation in reverse
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Image.asset(
        'assets/images/logo.png', // Replace with your logo asset path
        width: 150,
        height: 150,
      ),
    );
  }
}
