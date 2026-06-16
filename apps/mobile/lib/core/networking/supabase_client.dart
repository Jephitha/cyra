import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cyra/core/constants/api_constants.dart';

part 'supabase_client.g.dart';

class SupabaseClientService {
  final SupabaseClient _client;

  SupabaseClientService(this._client);

  static Future<void> initialize() async {
    await dotenv.load();
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? ApiConstants.supabaseUrl,
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? ApiConstants.supabaseAnonKey,
    );
  }

  SupabaseClient get client => _client;

  GoTrueClient get auth => _client.auth;

  static SupabaseClientService get instance {
    return SupabaseClientService(Supabase.instance.client);
  }

  Future<AuthResponse> signInAnonymously() => _client.auth.signInAnonymously();

  Future<AuthResponse> signInWithEmail(String email, String password) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<bool> signInWithOAuth(OAuthProvider provider) async {
    return _client.auth.signInWithOAuth(provider);
  }

  Future<void> signOut() => _client.auth.signOut();

  Future<List<Map<String, dynamic>>> fetch(
    String table, {
    String? userId,
    String? orderBy,
    bool ascending = false,
  }) async {
    dynamic query = _client.from(table).select();

    if (userId != null) {
      query = query.eq('user_id', userId);
    }

    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }

    final response = await query;
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchWithFilter(
    String table, {
    required String column,
    required Object value,
    String? orderBy,
    bool ascending = false,
  }) async {
    dynamic query = _client.from(table).select().eq(column, value);

    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }

    final response = await query;
    return (response as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> fetchById(String table, String id) async {
    final response = await _client.from(table).select().eq('id', id).maybeSingle();
    return response;
  }

  Future<void> upsert(
    String table,
    Map<String, dynamic> data, {
    String? conflictColumn,
  }) async {
    await _client.from(table).upsert(
          data,
          onConflict: conflictColumn,
        );
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    await _client.from(table).insert(data);
  }

  Future<void> update(String table, String id, Map<String, dynamic> data) async {
    await _client.from(table).update(data).eq('id', id);
  }

  Future<void> delete(String table, String id) async {
    await _client.from(table).delete().eq('id', id);
  }

  Future<void> deleteMany(String table, String column, List<String> ids) async {
    await _client.from(table).delete().inFilter(column, ids);
  }

  RealtimeChannel subscribe(
    String table, {
    String? userId,
    void Function(Map<String, dynamic>)? onInsert,
    void Function(Map<String, dynamic>)? onUpdate,
    void Function(Map<String, dynamic>)? onDelete,
  }) {
    final channel = _client.channel('public:$table').onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: (payload) {
            final record = payload.newRecord;
            switch (payload.eventType) {
              case PostgresChangeEvent.insert:
                onInsert?.call(record);
              case PostgresChangeEvent.update:
                onUpdate?.call(record);
              case PostgresChangeEvent.delete:
                onDelete?.call(record);
              default:
                break;
            }
          },
        );

    return channel.subscribe();
  }

  RealtimeChannel subscribeToUserData(
    String table, {
    required String userId,
    void Function(Map<String, dynamic>)? onInsert,
    void Function(Map<String, dynamic>)? onUpdate,
    void Function(Map<String, dynamic>)? onDelete,
  }) {
    final channel = _client.channel('user:$table:$userId').onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            final record = payload.newRecord;
            switch (payload.eventType) {
              case PostgresChangeEvent.insert:
                onInsert?.call(record);
              case PostgresChangeEvent.update:
                onUpdate?.call(record);
              case PostgresChangeEvent.delete:
                onDelete?.call(record);
              default:
                break;
            }
          },
        );

    return channel.subscribe();
  }

  void unsubscribe(RealtimeChannel channel) {
    _client.removeChannel(channel);
  }

  Future<void> uploadFile(
    String bucket,
    String path,
    Uint8List data, {
    String? contentType,
  }) async {
    await _client.storage.from(bucket).uploadBinary(
          path,
          data,
          fileOptions: FileOptions(contentType: contentType),
        );
  }

  Future<String> getFileUrl(String bucket, String path) async {
    final response = _client.storage.from(bucket).getPublicUrl(path);
    return response;
  }

  Future<void> deleteFile(String bucket, String path) async {
    await _client.storage.from(bucket).remove([path]);
  }
}

@Riverpod(keepAlive: true)
SupabaseClientService supabaseClientService(SupabaseClientServiceRef ref) {
  return SupabaseClientService.instance;
}
