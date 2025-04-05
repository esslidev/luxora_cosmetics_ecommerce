import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/routes/app_routes/app_routes.dart';
import 'config/theme/app_theme.dart';
import 'features/presentation/bloc/app/bread_crumbs/bread_crumbs_bloc.dart';
import 'features/presentation/bloc/app/lite_notification/lite_notifications_bloc.dart';
import 'features/presentation/bloc/app/route/route_bloc.dart';
import 'features/presentation/bloc/remote/auth/auth_bloc.dart';
import 'features/presentation/bloc/remote/category/category_bloc.dart';
import 'features/presentation/bloc/remote/product/product_bloc.dart';
import 'features/presentation/bloc/remote/user/user_bloc.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  usePathUrlStrategy();

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Local Blocs
        BlocProvider<AppRouteBloc>(
          create: (context) => locator<AppRouteBloc>(),
        ),
        BlocProvider<AppLiteNotificationsBloc>(
          create: (context) => locator<AppLiteNotificationsBloc>(),
        ),
        BlocProvider<AppBreadCrumbsBloc>(
          create: (context) => locator<AppBreadCrumbsBloc>(),
        ),

        // Remote Blocs
        BlocProvider<RemoteAuthBloc>(
          create: (context) => locator<RemoteAuthBloc>(),
        ),
        BlocProvider<RemoteUserBloc>(
          create: (context) => locator<RemoteUserBloc>(),
        ),
        BlocProvider<RemoteProductBloc>(
          create: (context) => locator<RemoteProductBloc>(),
        ),
        BlocProvider<RemoteCategoryBloc>(
          create: (context) => locator<RemoteCategoryBloc>(),
        ),
        /* BlocProvider<RemoteWishlistBloc>(
            create: (context) => locator<RemoteWishlistBloc>()),
        BlocProvider<RemoteCartBloc>(
            create: (context) => locator<RemoteCartBloc>()),*/
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        supportedLocales: const [
          //Locale('en', 'EN'), // English
          // add more locales as needed
          Locale('fr', 'FR'), // French
          //Locale('de', 'DE'), // Deutsch
          Locale('ar', 'AR'), // Arabic
        ],
        localizationsDelegates: const [
          // Add the following delegates
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // ...
        ],
        localeResolutionCallback: (
          Locale? locale,
          Iterable<Locale> supportedLocales,
        ) {
          if (locale != null) {
            for (Locale supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
          }
          return const Locale('fr', 'FR'); //default language
        },
        routerDelegate: AppRoutes.appBeamerDelegate,
        routeInformationParser: BeamerParser(),
        backButtonDispatcher: BeamerBackButtonDispatcher(
          delegate: AppRoutes.appBeamerDelegate,
        ),
      ),
    );
  }
}
