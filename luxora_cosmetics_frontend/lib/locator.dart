import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/resources/global_contexts.dart';
import 'features/data/data_sources/dummy_remote/dummy_category_api_service.dart';
import 'features/data/data_sources/dummy_remote/dummy_product_api_service.dart';
import 'features/data/data_sources/dummy_remote/dummy_system_message_api_service.dart';
import 'features/data/data_sources/dummy_remote/dummy_user_api_service.dart';
import 'features/data/data_sources/local/app_database.dart';
import 'features/data/data_sources/local/daos/cart_dao.dart';
import 'features/data/data_sources/local/daos/wishlist_dao.dart';
import 'features/data/data_sources/remote/auth_api_service.dart';
import 'features/data/data_sources/remote/author_api_service.dart';
import 'features/data/data_sources/remote/cart_api_service.dart';
import 'features/data/data_sources/remote/category_api_service.dart';
import 'features/data/data_sources/remote/product_api_service.dart';
import 'features/data/data_sources/remote/system_message_api_service.dart';
import 'features/data/data_sources/remote/user_api_service.dart';
import 'features/data/data_sources/remote/wishlist_api_service.dart';
import 'features/data/repository_impl/auth.dart';
import 'features/data/repository_impl/author.dart';
import 'features/data/repository_impl/cart.dart';
import 'features/data/repository_impl/category.dart';
import 'features/data/repository_impl/product.dart';
import 'features/data/repository_impl/system_message.dart';
import 'features/data/repository_impl/user.dart';
import 'features/data/repository_impl/wishlist.dart';
import 'features/domain/repository/auth.dart';
import 'features/domain/repository/author.dart';
import 'features/domain/repository/cart.dart';
import 'features/domain/repository/category.dart';
import 'features/domain/repository/product.dart';
import 'features/domain/repository/system_message.dart';
import 'features/domain/repository/user.dart';
import 'features/domain/repository/wishlist.dart';
import 'features/domain/usecases/auth.dart';
import 'features/domain/usecases/author.dart';
import 'features/domain/usecases/cart.dart';
import 'features/domain/usecases/category.dart';
import 'features/domain/usecases/product.dart';
import 'features/domain/usecases/system_message.dart';
import 'features/domain/usecases/user.dart';
import 'features/domain/usecases/wishlist.dart';
import 'features/presentation/bloc/app/bread_crumbs/bread_crumbs_bloc.dart';
import 'features/presentation/bloc/app/currency/currency_bloc.dart';
import 'features/presentation/bloc/app/language/translation_bloc.dart';
import 'features/presentation/bloc/app/lite_notification/lite_notifications_bloc.dart';
import 'features/presentation/bloc/app/route/route_bloc.dart';
import 'features/presentation/bloc/app/theme/theme_bloc.dart';
import 'features/presentation/bloc/remote/auth/auth_bloc.dart';
import 'features/presentation/bloc/remote/author/author_bloc.dart';
import 'features/presentation/bloc/remote/cart/cart_bloc.dart';
import 'features/presentation/bloc/remote/category/category_bloc.dart';
import 'features/presentation/bloc/remote/product/product_bloc.dart';
import 'features/presentation/bloc/remote/system_messages/system_message_bloc.dart';
import 'features/presentation/bloc/remote/user/user_bloc.dart';
import 'features/presentation/bloc/remote/wishlist/wishlist_bloc.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('local_db_alfia.db').build();

  // Register GlobalContexts
  locator.registerSingleton<GlobalContexts>(GlobalContexts());

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Dio
  locator.registerSingleton<Dio>(Dio());

  //App Blocs
  locator.registerFactory<AppRouteBloc>(() => AppRouteBloc());
  locator.registerFactory<AppCurrencyBloc>(() => AppCurrencyBloc());
  locator.registerFactory<AppTranslationBloc>(() => AppTranslationBloc());
  locator.registerFactory<AppThemeBloc>(() => AppThemeBloc());
  locator.registerFactory<AppLiteNotificationsBloc>(
      () => AppLiteNotificationsBloc());
  locator.registerFactory<AppBreadCrumbsBloc>(() => AppBreadCrumbsBloc());

  //Remote Blocs
  locator.registerFactory<RemoteAuthBloc>(() => RemoteAuthBloc(locator()));
  locator.registerFactory<RemoteUserBloc>(() => RemoteUserBloc(locator()));
  locator.registerFactory<RemoteSystemMessageBloc>(
      () => RemoteSystemMessageBloc(locator()));
  locator
      .registerFactory<RemoteProductBloc>(() => RemoteProductBloc(locator()));
  locator.registerFactory<RemoteAuthorBloc>(() => RemoteAuthorBloc(locator()));
  locator
      .registerFactory<RemoteCategoryBloc>(() => RemoteCategoryBloc(locator()));
  locator
      .registerFactory<RemoteWishlistBloc>(() => RemoteWishlistBloc(locator()));
  locator.registerFactory<RemoteCartBloc>(() => RemoteCartBloc(locator()));

  // Dependencies
  locator.registerSingleton<AuthApiService>(AuthApiService(locator()));
  locator.registerSingleton<AuthRepository>(AuthRepositoryImpl(locator()));

  locator.registerSingleton<UserApiService>(UserApiService(locator()));
  locator.registerSingleton<DummyUserApiService>(DummyUserApiService());
  locator.registerSingleton<UserRepository>(
      UserRepositoryImpl(locator(), locator()));

  locator.registerSingleton<SystemMessageApiService>(
      SystemMessageApiService(locator()));
  locator.registerSingleton<DummySystemMessageApiService>(
      DummySystemMessageApiService());
  locator.registerSingleton<SystemMessageRepository>(
      SystemMessageRepositoryImpl(locator(), locator(), locator()));

  locator.registerSingleton<ProductApiService>(ProductApiService(locator()));
  locator.registerSingleton<DummyProductApiService>(DummyProductApiService());
  locator.registerSingleton<ProductRepository>(
      ProductRepositoryImpl(locator(), locator(), locator()));

  locator.registerSingleton<AuthorApiService>(AuthorApiService(locator()));
  locator.registerSingleton<AuthorRepository>(
      AuthorRepositoryImpl(locator(), locator()));

  locator.registerSingleton<CategoryApiService>(CategoryApiService(locator()));
  locator.registerSingleton<DummyCategoryApiService>(DummyCategoryApiService());
  locator.registerSingleton<CategoryRepository>(
      CategoryRepositoryImpl(locator(), locator(), locator()));

  locator.registerSingleton<WishlistApiService>(WishlistApiService(locator()));
  locator.registerSingleton<WishlistDao>(database.wishlistDao);

  locator.registerSingleton<WishlistRepository>(WishlistRepositoryImpl(
    locator(),
    locator(),
    locator(),
  ));

  locator.registerSingleton<CartApiService>(CartApiService(locator()));
  locator.registerSingleton<CartDao>(database.cartDao);
  locator.registerSingleton<CartRepository>(CartRepositoryImpl(
    locator(),
    locator(),
    locator(),
  ));

  //UseCases
  locator.registerSingleton<UserUseCases>(UserUseCases(locator()));
  locator.registerSingleton<AuthUseCases>(AuthUseCases(locator()));
  locator.registerSingleton<SystemMessageUseCases>(
      SystemMessageUseCases(locator()));
  locator.registerSingleton<ProductUseCases>(ProductUseCases(locator()));
  locator.registerSingleton<AuthorUseCases>(AuthorUseCases(locator()));
  locator.registerSingleton<CategoryUseCases>(CategoryUseCases(locator()));
  locator.registerSingleton<WishlistUseCases>(WishlistUseCases(locator()));
  locator.registerSingleton<CartUseCases>(CartUseCases(locator()));
}
