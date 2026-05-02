import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/article_model.dart';

class ArticleRepository {
  final SupabaseClient _supabase;

  ArticleRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<List<HistoricalArticle>> getArticles() async {
    try {
      final response = await _supabase
          .from('historical_articles')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List).map((e) => HistoricalArticle.fromJson(e)).toList();
    } catch (e) {
      throw 'Error fetching articles: $e';
    }
  }

  Future<void> createArticle(Map<String, dynamic> data) async {
    try {
      await _supabase.from('historical_articles').insert(data);
    } catch (e) {
      throw 'Error creating article: $e';
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      await _supabase.from('historical_articles').delete().match({'id': id});
    } catch (e) {
      throw 'Error deleting article: $e';
    }
  }
}
