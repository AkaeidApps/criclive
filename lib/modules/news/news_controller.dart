import 'package:get/get.dart';

import '../../core/enums/app_enums.dart';
import '../../data/models/news.dart';
import '../../data/repositories/cricket_repositories.dart';

class NewsController extends GetxController {
  final String? articleId;
  final NewsRepository _repository;

  NewsController({this.articleId, NewsRepository? repository})
      : _repository = repository ?? Get.find<NewsRepository>();

  final state = ViewState.initial.obs;
  final articles = <NewsArticle>[].obs;
  final article = Rxn<NewsArticle>();
  final category = NewsCategory.all.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    state.value = ViewState.loading;
    try {
      if (articleId == null) {
        articles.value = await _repository.all();
      } else {
        article.value = await _repository.find(articleId!);
      }
      state.value = ViewState.success;
    } catch (error) {
      errorMessage.value = error.toString();
      state.value = ViewState.error;
    }
  }

  List<NewsArticle> get filtered => category.value == NewsCategory.all
      ? articles
      : articles.where((item) => item.category == category.value).toList();
}
