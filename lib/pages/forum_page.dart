import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/forum_service.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final forum = ForumService();
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  final postController = TextEditingController();
  late final RealtimeChannel _channel;

  @override
  void initState() {
    super.initState();
    loadPosts();

    _channel = Supabase.instance.client.channel('public:posts')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'posts',
        callback: (_) => loadPosts(),
      )
      ..subscribe();
  }

  Future<void> loadPosts() async {
    try {
      final data = await forum.getPosts();
      if (mounted) setState(() { posts = data; isLoading = false; });
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showSnack("Failed to load posts: $e");
      }
    }
  }

  Future<void> createPost() async {
    final text = postController.text.trim();
    if (text.isEmpty) return;
    try {
      await forum.createPost(text);
      postController.clear();
      await loadPosts();
    } catch (e) {
      _showSnack("Failed to post: $e");
    }
  }

  // Optimistic like toggle — reverts on error
  Future<void> toggleLike(int index) async {
    final post = posts[index];
    final postId = post['id'] as String;
    final wasLiked = post['liked_by_me'] as bool? ?? false;

    // Apply optimistic update immediately
    setState(() {
      posts[index]['liked_by_me'] = !wasLiked;
      posts[index]['like_count'] =
          ((post['like_count'] as int? ?? 0) + (wasLiked ? -1 : 1))
              .clamp(0, 999999);
    });

    try {
      await forum.toggleLike(postId, wasLiked);
    } catch (e) {
      // Revert on failure
      if (mounted) {
        setState(() {
          posts[index]['liked_by_me'] = wasLiked;
          posts[index]['like_count'] =
              ((post['like_count'] as int? ?? 0)).clamp(0, 999999);
        });
        _showSnack("Like failed: $e");
      }
    }
  }

  void showPostDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create Post"),
        content: TextField(
          controller: postController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Share something with the community...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); createPost(); },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  void openReplies(Map<String, dynamic> post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _RepliesPage(post: post, forum: forum)),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 4)),
    );
  }

  @override
  void dispose() {
    Supabase.instance.client.removeChannel(_channel);
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text("Community"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      const Text("No posts yet. Be the first!",
                          style: TextStyle(color: Colors.black45, fontSize: 16)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadPosts,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: posts.length,
                    itemBuilder: (_, i) => _PostCard(
                      post: posts[i],
                      onLike: () => toggleLike(i),
                      onReply: () => openReplies(posts[i]),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: showPostDialog,
        backgroundColor: const Color(0xFF2D7A4A),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}

// ── Post Card ──────────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final VoidCallback onReply;

  const _PostCard({required this.post, required this.onLike, required this.onReply});

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    try { return timeago.format(DateTime.parse(iso).toLocal()); }
    catch (_) { return ''; }
  }

  @override
  Widget build(BuildContext context) {
    // users is a Map when the join succeeds, null when it fails
    final usersMap = post['users'];
    final authorName = usersMap is Map
        ? (usersMap['name'] as String? ?? 'Anonymous')
        : 'Anonymous';

    final content = post['content'] as String? ?? '';
    final likeCount = post['like_count'] as int? ?? 0;
    final likedByMe = post['liked_by_me'] as bool? ?? false;
    final time = _timeAgo(post['created_at'] as String?);

    final initials = authorName.trim().split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2).join().toUpperCase();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF2D7A4A),
                child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(authorName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  if (time.isNotEmpty)
                    Text(time, style: const TextStyle(color: Colors.black38, fontSize: 12)),
                ],
              )),
            ]),

            const SizedBox(height: 10),
            Text(content, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
            const SizedBox(height: 12),

            // Action row
            Row(children: [
              // Like
              InkWell(
                onTap: onLike,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        likedByMe ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(likedByMe),
                        color: likedByMe ? Colors.red : Colors.black38,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$likeCount',
                      style: TextStyle(
                        color: likedByMe ? Colors.red : Colors.black45,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ]),
                ),
              ),

              const SizedBox(width: 20),

              // Reply
              InkWell(
                onTap: onReply,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.black38, size: 20),
                    SizedBox(width: 5),
                    Text("Reply", style: TextStyle(color: Colors.black45, fontSize: 14)),
                  ]),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ── Replies Page ───────────────────────────────────────────────────────────────

class _RepliesPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final ForumService forum;
  const _RepliesPage({required this.post, required this.forum});

  @override
  State<_RepliesPage> createState() => _RepliesPageState();
}

class _RepliesPageState extends State<_RepliesPage> {
  List<Map<String, dynamic>> replies = [];
  bool isLoading = true;
  bool isSending = false;
  final replyController = TextEditingController();
  final scrollController = ScrollController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadReplies();
  }

  Future<void> loadReplies() async {
    try {
      final data = await widget.forum.getReplies(widget.post['id'] as String);
      if (mounted) setState(() { replies = data; isLoading = false; });
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showSnack("Failed to load replies: $e");
      }
    }
  }

  Future<void> submitReply() async {
    final text = replyController.text.trim();
    if (text.isEmpty || isSending) return;

    setState(() => isSending = true);
    try {
      await widget.forum.createReply(widget.post['id'] as String, text);
      replyController.clear();
      await loadReplies();
      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      _showSnack("Failed to reply: $e");
    } finally {
      if (mounted) setState(() => isSending = false);
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 4)),
    );
  }

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    try { return timeago.format(DateTime.parse(iso).toLocal()); }
    catch (_) { return ''; }
  }

  @override
  void dispose() {
    replyController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersMap = widget.post['users'];
    final authorName = usersMap is Map
        ? (usersMap['name'] as String? ?? 'Anonymous')
        : 'Anonymous';
    final content = widget.post['content'] as String? ?? '';
    final likeCount = widget.post['like_count'] as int? ?? 0;
    final time = _timeAgo(widget.post['created_at'] as String?);

    final initials = authorName.trim().split(' ')
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2).join().toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text("Replies"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Column(children: [
        // Original post (pinned at top)
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF2D7A4A),
                child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(authorName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                if (time.isNotEmpty)
                  Text(time, style: const TextStyle(color: Colors.black38, fontSize: 12)),
              ]),
            ]),
            const SizedBox(height: 10),
            Text(content, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.favorite, color: Colors.red, size: 16),
              const SizedBox(width: 4),
              Text('$likeCount likes', style: const TextStyle(color: Colors.black45, fontSize: 13)),
            ]),
          ]),
        ),

        const Divider(height: 1, color: Color(0xFFE0E0E0)),

        // Replies list
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : replies.isEmpty
                  ? const Center(
                      child: Text("No replies yet.\nBe the first to reply!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black45, fontSize: 15)))
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      itemCount: replies.length,
                      itemBuilder: (_, i) {
                        final r = replies[i];
                        final rUsers = r['users'];
                        final rName = rUsers is Map
                            ? (rUsers['name'] as String? ?? 'Anonymous')
                            : 'Anonymous';
                        final rInitials = rName.trim().split(' ')
                            .map((w) => w.isNotEmpty ? w[0] : '')
                            .take(2).join().toUpperCase();
                        final rTime = _timeAgo(r['created_at'] as String?);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.blueGrey.shade100,
                                child: Text(rInitials,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(rName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                        if (rTime.isNotEmpty) ...[
                                          const SizedBox(width: 8),
                                          Text(rTime, style: const TextStyle(color: Colors.black38, fontSize: 11)),
                                        ],
                                      ]),
                                      const SizedBox(height: 3),
                                      Text(r['content'] as String? ?? '',
                                          style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),

        // Reply input bar
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            left: 12, right: 8, top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8,
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: replyController,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: "Write a reply...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFF2D7A4A)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            isSending
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)))
                : IconButton(
                    onPressed: submitReply,
                    icon: const Icon(Icons.send_rounded),
                    color: const Color(0xFF2D7A4A),
                    iconSize: 28,
                  ),
          ]),
        ),
      ]),
    );
  }
}