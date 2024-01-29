import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_buzz/routes/app_route_consts.dart';

class ScaffoldWrapper extends StatelessWidget {
  const ScaffoldWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    GoRouter _router = GoRouter.of(context);

    return SafeArea(
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.primary,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                Container(
                  height: 250,
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Home'),
                  onTap: () => _router.push('/'),
                ),
                ListTile(
                  title: const Text('Movies'),
                  onTap: () => _router.pushNamed(discoverMoviesPageRoute),
                ),
                ListTile(
                  enabled: false,
                  title: const Text('TV Shows (WIP)'),
                  onTap: () => _router.pushNamed(homePageRoute),
                ),
                ListTile(
                  enabled: false,
                  title: const Text('People (WIP)'),
                  onTap: () => _router.pushNamed(homePageRoute),
                ),
              ],
            ),
          ),
          body: child,
        ),
      ),
    );
  }
}
