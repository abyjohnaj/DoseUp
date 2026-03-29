import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/forum_service.dart';

const _kPrimary = Color(0xFF1A6B45);
const _kPrimaryLight = Color(0xFFE8F5EE);
const _kSurface = Color(0xFFF7FAF8);
const _kCard = Colors.white;
const _kBorder = Color(0xFFDDEDE5);
const _kTextDark = Color(0xFF0F2419);
const _kTextMid = Color(0xFF4A6358);
const _kTextLight = Color(0xFF8BA899);

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
      if (mounted) { setState(() => isLoading = false); _showSnack('Failed to load posts: $e'); }
    }
  }

  Future<void> createPost() async {
    final text = postController.text.trim();
    if (text.isEmpty) return;
    try {
      await forum.createPost(text);
      postController.clear();
      await loadPosts();
    } catch (e) { _showSnack('Failed to post: $e'); }
  }

  Future<void> toggleLike(int index) async {
    final post = posts[index];
    final postId = post['id'] as String;
    final wasLiked = post['liked_by_me'] as bool? ?? false;
    setState(() {
      posts[index]['liked_by_me'] = !wasLiked;
      posts[index]['like_count'] = ((post['like_count'] as int? ?? 0) + (wasLiked ? -1 : 1)).clamp(0, 999999);
    });
    try {
      await forum.toggleLike(postId, wasLiked);
    } catch (e) {
      if (mounted) {
        setState(() {
          posts[index]['liked_by_me'] = wasLiked;
          posts[index]['like_count'] = (post['like_count'] as int? ?? 0).clamp(0, 999999);
        });
        _showSnack('Like failed: $e');
      }
    }
  }

  void showPostDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Post',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kTextDark)),
              const SizedBox(height: 16),
              TextField(
                controller: postController,
                maxLines: 4,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Share something with the community...',
                  hintStyle: const TextStyle(color: _kTextLight, fontSize: 13),
                  filled: true,
                  fillColor: _kSurface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _kBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _kBorder)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _kPrimary, width: 2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: _kTextMid)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () { Navigator.pop(context); createPost(); },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Post', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void openReplies(Map<String, dynamic> post) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _RepliesPage(post: post, forum: forum)));
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 4)));
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
      backgroundColor: _kSurface,
      body: Row(
        children: [
          _Sidebar(activeRoute: '/forum'),
          Expanded(
            child: Column(
              children: [
                // TopBar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(color: _kCard, border: Border(bottom: BorderSide(color: _kBorder))),
                  child: Row(
                    children: [
                      const Text('Community Forum',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kTextDark)),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: showPostDialog,
                        icon: const Icon(Icons.edit_rounded, size: 15),
                        label: const Text('New Post', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kPrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 36, height: 36,
                        decoration: const BoxDecoration(color: _kPrimaryLight, shape: BoxShape.circle),
                        child: const Icon(Icons.person_outline_rounded, size: 20, color: _kPrimary),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(_kPrimary), strokeWidth: 2.5))
                      : posts.isEmpty
                          ? Center(
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.forum_outlined, size: 52, color: _kTextLight),
                                const SizedBox(height: 12),
                                const Text('No posts yet. Be the first!',
                                    style: TextStyle(color: _kTextLight, fontSize: 15)),
                              ]),
                            )
                          : RefreshIndicator(
                              onRefresh: loadPosts,
                              color: _kPrimary,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: posts.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (_, i) => _PostCard(
                                  post: posts[i],
                                  onLike: () => toggleLike(i),
                                  onReply: () => openReplies(posts[i]),
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Post Card ───────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onLike;
  final VoidCallback onReply;

  const _PostCard({required this.post, required this.onLike, required this.onReply});

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    try { return timeago.format(DateTime.parse(iso).toLocal()); } catch (_) { return ''; }
  }

  @override
  Widget build(BuildContext context) {
    final usersMap = post['users'];
    final authorName = usersMap is Map ? (usersMap['name'] as String? ?? 'Anonymous') : 'Anonymous';
    final content = post['content'] as String? ?? '';
    final likeCount = post['like_count'] as int? ?? 0;
    final likedByMe = post['liked_by_me'] as bool? ?? false;
    final time = _timeAgo(post['created_at'] as String?);
    final initials = authorName.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: _kPrimary,
            child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(authorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _kTextDark)),
            if (time.isNotEmpty) Text(time, style: const TextStyle(color: _kTextLight, fontSize: 12)),
          ]),
        ]),
        const SizedBox(height: 12),
        Text(content, style: const TextStyle(fontSize: 14, height: 1.6, color: _kTextMid)),
        const SizedBox(height: 14),
        Row(children: [
          InkWell(
            onTap: onLike,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    likedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    key: ValueKey(likedByMe),
                    color: likedByMe ? Colors.red : _kTextLight,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 5),
                Text('$likeCount', style: TextStyle(color: likedByMe ? Colors.red : _kTextLight, fontWeight: FontWeight.w600, fontSize: 13)),
              ]),
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: onReply,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(children: const [
                Icon(Icons.chat_bubble_outline_rounded, color: _kTextLight, size: 17),
                SizedBox(width: 5),
                Text('Reply', style: TextStyle(color: _kTextLight, fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ── Replies Page ─────────────────────────────────────────────────────────────

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
  void initState() { super.initState(); loadReplies(); }

  Future<void> loadReplies() async {
    try {
      final data = await widget.forum.getReplies(widget.post['id'] as String);
      if (mounted) setState(() { replies = data; isLoading = false; });
    } catch (e) {
      if (mounted) { setState(() => isLoading = false); _showSnack('Failed to load replies: $e'); }
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      });
    } catch (e) { _showSnack('Failed to reply: $e'); }
    finally { if (mounted) setState(() => isSending = false); }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 4)));
  }

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    try { return timeago.format(DateTime.parse(iso).toLocal()); } catch (_) { return ''; }
  }

  @override
  void dispose() { replyController.dispose(); scrollController.dispose(); focusNode.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final usersMap = widget.post['users'];
    final authorName = usersMap is Map ? (usersMap['name'] as String? ?? 'Anonymous') : 'Anonymous';
    final content = widget.post['content'] as String? ?? '';
    final likeCount = widget.post['like_count'] as int? ?? 0;
    final time = _timeAgo(widget.post['created_at'] as String?);
    final initials = authorName.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

    return Scaffold(
      backgroundColor: _kSurface,
      appBar: AppBar(
        title: const Text('Replies', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kTextDark)),
        backgroundColor: _kCard,
        foregroundColor: _kTextDark,
        elevation: 0,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: _kBorder)),
      ),
      body: Column(children: [
        // Original post pinned
        Container(
          color: _kCard,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 18, backgroundColor: _kPrimary,
                  child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11))),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(authorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _kTextDark)),
                if (time.isNotEmpty) Text(time, style: const TextStyle(color: _kTextLight, fontSize: 11)),
              ]),
            ]),
            const SizedBox(height: 10),
            Text(content, style: const TextStyle(fontSize: 14, height: 1.5, color: _kTextMid)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.favorite_rounded, color: Colors.red, size: 14),
              const SizedBox(width: 4),
              Text('$likeCount likes', style: const TextStyle(color: _kTextLight, fontSize: 12)),
            ]),
          ]),
        ),
        Container(height: 1, color: _kBorder),

        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(_kPrimary), strokeWidth: 2.5))
              : replies.isEmpty
                  ? const Center(child: Text('No replies yet.\nBe the first to reply!',
                      textAlign: TextAlign.center, style: TextStyle(color: _kTextLight, fontSize: 14)))
                  : ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(14),
                      itemCount: replies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final r = replies[i];
                        final rUsers = r['users'];
                        final rName = rUsers is Map ? (rUsers['name'] as String? ?? 'Anonymous') : 'Anonymous';
                        final rInitials = rName.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();
                        final rTime = _timeAgo(r['created_at'] as String?);

                        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          CircleAvatar(radius: 15, backgroundColor: const Color(0xFFE2E8F0),
                              child: Text(rInitials, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _kTextMid))),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: _kBorder)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  Text(rName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _kTextDark)),
                                  if (rTime.isNotEmpty) ...[
                                    const SizedBox(width: 8),
                                    Text(rTime, style: const TextStyle(color: _kTextLight, fontSize: 11)),
                                  ],
                                ]),
                                const SizedBox(height: 3),
                                Text(r['content'] as String? ?? '',
                                    style: const TextStyle(fontSize: 13, height: 1.5, color: _kTextMid)),
                              ]),
                            ),
                          ),
                        ]);
                      },
                    ),
        ),

        // Reply input
        Container(
          color: _kCard,
          padding: EdgeInsets.only(
            left: 12, right: 8, top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8,
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: replyController,
                focusNode: focusNode,
                minLines: 1, maxLines: 4,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Write a reply...',
                  hintStyle: const TextStyle(color: _kTextLight, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  filled: true,
                  fillColor: _kSurface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: _kBorder)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: _kBorder)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: _kPrimary, width: 2)),
                ),
              ),
            ),
            const SizedBox(width: 4),
            isSending
                ? const Padding(padding: EdgeInsets.all(12),
                    child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(_kPrimary))))
                : IconButton(
                    onPressed: submitReply,
                    icon: const Icon(Icons.send_rounded),
                    color: _kPrimary,
                    iconSize: 24,
                  ),
          ]),
        ),
      ]),
    );
  }
}

// ── Sidebar & NavItem ───────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final String activeRoute;
  const _Sidebar({required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220, color: _kCard,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Row(children: [
            Container(width: 34, height: 34,
                decoration: BoxDecoration(color: _kPrimary, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 20)),
            const SizedBox(width: 10),
            const Text('DoseUp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kPrimary, letterSpacing: -0.3)),
          ]),
        ),
        const Divider(height: 1, color: _kBorder),
        const SizedBox(height: 8),
        _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard', route: '/dashboard', activeRoute: activeRoute),
        _NavItem(icon: Icons.search_rounded, label: 'Search', route: '/search', activeRoute: activeRoute),
        _NavItem(icon: Icons.compare_arrows_rounded, label: 'Compare Prices', route: '/compare', activeRoute: activeRoute),
        _NavItem(icon: Icons.receipt_long_rounded, label: 'Prescription', route: '/prescription', activeRoute: activeRoute),
        _NavItem(icon: Icons.forum_rounded, label: 'Community', route: '/forum', activeRoute: activeRoute),
        _NavItem(icon: Icons.warning_amber_rounded, label: 'Shortage Reports', route: '/shortage', activeRoute: activeRoute),
        _NavItem(icon: Icons.smart_toy_rounded, label: 'AI Assistant', route: '/chatbot', activeRoute: activeRoute),
      ]),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final String activeRoute;
  const _NavItem({required this.icon, required this.label, required this.route, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    final isActive = route == activeRoute;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: InkWell(
        onTap: () { if (!isActive) Navigator.pushNamed(context, route); },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: isActive ? _kPrimaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Icon(icon, size: 19, color: isActive ? _kPrimary : _kTextMid),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? _kPrimary : _kTextMid)),
            if (isActive) ...[const Spacer(), Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: _kPrimary))],
          ]),
        ),
      ),
    );
  }
}