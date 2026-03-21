import 'package:supabase_flutter/supabase_flutter.dart';

class ForumService {
  final supabase = Supabase.instance.client;

  // ── Posts ──────────────────────────────────────────────────────────────────

  Future<void> createPost(String content) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("Not logged in");

    await supabase.from('posts').insert({
      'user_id': user.id,
      'content': content,
    });
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final currentUser = supabase.auth.currentUser;

    // Step 1: Fetch posts (no join — avoids FK issues)
    final postsRaw = await supabase
        .from('posts')
        .select('id, content, created_at, user_id')
        .order('created_at', ascending: false);

    final posts = List<Map<String, dynamic>>.from(
      (postsRaw as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );

    if (posts.isEmpty) return posts;

    // Step 2: Collect all unique user_ids from posts
    final userIds = posts
        .map((p) => p['user_id'] as String?)
        .whereType<String>()
        .toSet()
        .toList();

    // Step 3: Fetch user names for those ids
    Map<String, String> userNames = {};
    if (userIds.isNotEmpty) {
      try {
        final usersRaw = await supabase
            .from('users')
            .select('id, name')
            .inFilter('id', userIds);

        for (final u in (usersRaw as List)) {
          final map = Map<String, dynamic>.from(u as Map);
          userNames[map['id'] as String] = map['name'] as String? ?? 'Anonymous';
        }
      } catch (_) {
        // If users table fetch fails, names default to Anonymous
      }
    }

    // Step 4: Fetch ALL likes in one query
    final allLikesRaw = await supabase
        .from('likes')
        .select('post_id, user_id');

    final allLikes = List<Map<String, dynamic>>.from(
      (allLikesRaw as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );

    // Step 5: Attach author name, like_count, liked_by_me to each post
    for (final post in posts) {
      final postId = post['id'] as String;
      final userId = post['user_id'] as String?;

      post['author_name'] = userId != null
          ? (userNames[userId] ?? 'Anonymous')
          : 'Anonymous';

      final postLikes = allLikes.where((l) => l['post_id'] == postId).toList();
      post['like_count'] = postLikes.length;
      post['liked_by_me'] = currentUser != null &&
          postLikes.any((l) => l['user_id'] == currentUser.id);
    }

    return posts;
  }

  // ── Likes ──────────────────────────────────────────────────────────────────

  Future<void> toggleLike(String postId, bool currentlyLiked) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("Not logged in");

    if (currentlyLiked) {
      await supabase
          .from('likes')
          .delete()
          .match({'post_id': postId, 'user_id': user.id});
    } else {
      await supabase.from('likes').insert({
        'post_id': postId,
        'user_id': user.id,
      });
    }
  }

  // ── Replies ────────────────────────────────────────────────────────────────

  Future<void> createReply(String postId, String content) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("Not logged in");

    await supabase.from('replies').insert({
      'post_id': postId,
      'user_id': user.id,
      'content': content,
    });
  }

  Future<List<Map<String, dynamic>>> getReplies(String postId) async {
    // Fetch replies without join first
    final raw = await supabase
        .from('replies')
        .select('id, content, created_at, user_id')
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    final replies = List<Map<String, dynamic>>.from(
      (raw as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );

    if (replies.isEmpty) return replies;

    // Fetch reply author names
    final userIds = replies
        .map((r) => r['user_id'] as String?)
        .whereType<String>()
        .toSet()
        .toList();

    Map<String, String> userNames = {};
    if (userIds.isNotEmpty) {
      try {
        final usersRaw = await supabase
            .from('users')
            .select('id, name')
            .inFilter('id', userIds);

        for (final u in (usersRaw as List)) {
          final map = Map<String, dynamic>.from(u as Map);
          userNames[map['id'] as String] = map['name'] as String? ?? 'Anonymous';
        }
      } catch (_) {}
    }

    for (final reply in replies) {
      final uid = reply['user_id'] as String?;
      reply['author_name'] = uid != null ? (userNames[uid] ?? 'Anonymous') : 'Anonymous';
    }

    return replies;
  }
}