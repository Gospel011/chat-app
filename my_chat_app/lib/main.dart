import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_chat_app/business_logic/auth/auth_cubit.dart';
import 'package:my_chat_app/business_logic/chat/chat_cubit.dart';
import 'package:my_chat_app/presentation/pages/home_page.dart';
import 'package:my_chat_app/presentation/pages/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

void main() async {
  // HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<ChatCubit>(create: (context) => ChatCubit()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // useMaterial3: false,
          ),
          home: context.read<AuthCubit>().state.user != null
              ? const HomePage()
              : const LoginPage(),
        );
      }),
    );
  }
}
