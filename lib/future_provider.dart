import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list_provider_riverpod_firebase_auth/models/cat_fact_model.dart';

final httpClientProvider = Provider((ref) {
  return Dio(BaseOptions(baseUrl: 'https://catfact.ninja/'));
});

final catFactsProvider =
    FutureProvider.autoDispose.family<List<CatFactModel>, Map<String, dynamic>>(
        (ref, parameterMap) async {

  final _dio = ref.watch(httpClientProvider);
  final result =
      await _dio.get('facts', queryParameters: parameterMap);
  ref.keepAlive();
  List<Map<String, dynamic>> _mapData = List.from(result.data['data']);
  List<CatFactModel> _catFactList =
      _mapData.map((e) => CatFactModel.fromMap(e)).toList();
  return _catFactList;
});

class FutureProviderExample extends ConsumerWidget {
  const FutureProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var myList = ref.watch(catFactsProvider(const {'limit':4, 'max_length':100}));
    return Scaffold(
      body: SafeArea(
        child: myList.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].fact), // data[index] kullanıldı
                );
              },
            );
          },
          error: (err, stack) {
            return Center(
              child: Text('Error $err'),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
