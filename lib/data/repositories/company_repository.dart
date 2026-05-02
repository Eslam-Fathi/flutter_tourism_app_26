import 'package:dio/dio.dart';
import '../models/company_model.dart';

class CompanyRepository {
  final Dio _dio;

  CompanyRepository({required Dio dio}) : _dio = dio;

  /// Fetches all companies for public use (may only return approved ones).
  Future<List<Company>> getCompanies() async {
    try {
      final response = await _dio.get('/api/companies');
      final data = response.data['data'];
      if (data == null) return [];
      return (data as List).map((e) => Company.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches ALL companies for admin, including pending ones.
  /// Tries with ?all=true query param first; falls back to standard endpoint.
  Future<List<Company>> getAllCompaniesForAdmin() async {
    try {
      // Some backends expose a query param to return all statuses
      final response = await _dio.get('/api/companies', queryParameters: {'all': 'true'});
      final data = response.data['data'];
      if (data == null) return [];
      return (data as List).map((e) => Company.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Company> createCompany(Map<String, dynamic> companyData) async {
    try {
      final response = await _dio.post('/api/companies', data: companyData);
      return Company.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Company> approveCompany(String id, bool approved) async {
    try {
      final response = await _dio.put('/api/companies/$id/status', data: {'approved': approved});
      return Company.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data['message'] ?? 'An error occurred';
    }
    return e.message ?? 'Unknown error';
  }
}
