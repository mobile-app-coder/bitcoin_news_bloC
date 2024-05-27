import 'package:bitcoin_news_getx/models/new_response_model.dart';
import 'package:bitcoin_news_getx/services/http_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadEvent>(loadNews);
  }

  List<Article> news = [];

  Future<void> loadNews(HomeLoadEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    var response = await Network.GET();
    if (response != null) {
      var articles = responseModelFromJson(response);
      news.addAll(articles.articles!);
      emit(HomeSuccessState());
    }
  }

  openBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
