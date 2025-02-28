import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/resources/global_contexts.dart';
import 'features/data/data_sources/remote/auth_api_service.dart';
import 'features/data/data_sources/remote/category_api_service.dart';
import 'features/data/data_sources/remote/product_api_service.dart';
import 'features/data/data_sources/remote/user_api_service.dart';
import 'features/data/repository_impl/auth.dart';
import 'features/data/repository_impl/category.dart';
import 'features/data/repository_impl/product.dart';
import 'features/data/repository_impl/user.dart';
import 'features/domain/repository/auth.dart';
import 'features/domain/repository/category.dart';
import 'features/domain/repository/product.dart';
import 'features/domain/repository/user.dart';
import 'features/domain/usecases/auth.dart';
import 'features/domain/usecases/category.dart';
import 'features/domain/usecases/product.dart';
import 'features/domain/usecases/user.dart';
import 'features/presentation/bloc/app/bread_crumbs/bread_crumbs_bloc.dart';
import 'features/presentation/bloc/app/lite_notification/lite_notifications_bloc.dart';
import 'features/presentation/bloc/app/route/route_bloc.dart';
import 'features/presentation/bloc/remote/auth/auth_bloc.dart';
import 'features/presentation/bloc/remote/category/category_bloc.dart';
import 'features/presentation/bloc/remote/product/product_bloc.dart';
import 'features/presentation/bloc/remote/user/user_bloc.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register GlobalContexts
  locator.registerSingleton<GlobalContexts>(GlobalContexts());

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Dio
  locator.registerSingleton<Dio>(Dio());

  //App Blocs
  locator.registerFactory<AppRouteBloc>(() => AppRouteBloc());
  locator.registerFactory<AppLiteNotificationsBloc>(
      () => AppLiteNotificationsBloc());
  locator.registerFactory<AppBreadCrumbsBloc>(() => AppBreadCrumbsBloc());

  //Remote Blocs
  locator.registerFactory<RemoteAuthBloc>(() => RemoteAuthBloc(locator()));
  locator.registerFactory<RemoteUserBloc>(() => RemoteUserBloc(locator()));
  locator
      .registerFactory<RemoteProductBloc>(() => RemoteProductBloc(locator()));
  locator
      .registerFactory<RemoteCategoryBloc>(() => RemoteCategoryBloc(locator()));
  /* locator
      .registerFactory<RemoteWishlistBloc>(() => RemoteWishlistBloc(locator()));
  locator.registerFactory<RemoteCartBloc>(() => RemoteCartBloc(locator()));*/

  // Dependencies
  locator.registerSingleton<AuthApiService>(AuthApiService(locator()));
  locator.registerSingleton<AuthRepository>(AuthRepositoryImpl(locator()));

  locator.registerSingleton<UserApiService>(UserApiService(locator()));
  locator.registerSingleton<UserRepository>(
      UserRepositoryImpl(locator(), locator()));

  locator.registerSingleton<ProductApiService>(ProductApiService(locator()));
  locator.registerSingleton<ProductRepository>(
      ProductRepositoryImpl(locator(), locator()));

  locator.registerSingleton<CategoryApiService>(CategoryApiService(locator()));
  locator.registerSingleton<CategoryRepository>(
      CategoryRepositoryImpl(locator(), locator()));

  /*locator.registerSingleton<WishlistApiService>(WishlistApiService(locator()));
  locator.registerSingleton<WishlistDao>(database.wishlistDao);

  locator.registerSingleton<WishlistRepository>(WishlistRepositoryImpl(
    locator(),
    locator(),
    locator(),
  ));*/

  /* locator.registerSingleton<CartApiService>(CartApiService(locator()));
  locator.registerSingleton<CartDao>(database.cartDao);
  locator.registerSingleton<CartRepository>(CartRepositoryImpl(
    locator(),
    locator(),
    locator(),
  ));*/

  //UseCases
  locator.registerSingleton<UserUseCases>(UserUseCases(locator()));
  locator.registerSingleton<AuthUseCases>(AuthUseCases(locator()));
  locator.registerSingleton<ProductUseCases>(ProductUseCases(locator()));
  locator.registerSingleton<CategoryUseCases>(CategoryUseCases(locator()));
  //locator.registerSingleton<WishlistUseCases>(WishlistUseCases(locator()));
  //locator.registerSingleton<CartUseCases>(CartUseCases(locator()));
}
