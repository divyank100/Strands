import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:threads_clone/models/Comment.dart';
import 'package:threads_clone/models/post.dart';
import 'package:threads_clone/models/user.dart';
import 'package:threads_clone/services/auth/auth_service.dart';
import 'package:threads_clone/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();
  final _auth = AuthService();

  Future<UserProfile?> userProfile(String uid) => _db.getUser(uid);

  // update the user bio
  Future<void> updateUserBioInFirebase(String bio) =>
      _db.updateUserBioInFirebase(bio);

  // local list for all posts
  List<Post> _allPosts = [];
  List<Post> _followingPosts = [];

  List<Post> get allPosts => _allPosts;
  List<Post> get followingPosts => _followingPosts;

  // Post a message
  Future<void> postMessage(String message) async {
    await _db.postMessageInFirebase(message);
    await getAllPosts();
  }

  // Get all posts
  Future<void> getAllPosts() async {
    final allPosts = await _db.getAllPostsFromFirebase();
    // get blocked userIds
    final blockedUerIds = await _db.getBlockedUIdsFromFirebase();
    _allPosts =
        allPosts.where((post) => !blockedUerIds.contains(post.uid)).toList();

    await loadFollowingPosts();
    initLikeMap();
    notifyListeners();
  }

  // Get post for given uid
  List<Post> filterPost(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  Future<void> loadFollowingPosts() async{
    String currentUserId=_auth.getCurrentUserId();
    final followingUids= await _db.getFollowingUidsFromFirebase(currentUserId);
    // print("following uids ${followingUids.length}");
    _followingPosts=_allPosts.where((post)=>followingUids.contains(post.uid)).toList();

    notifyListeners();
    print("following posts ${_followingPosts.length}");

  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);
    await getAllPosts();
  }

  //Local map to track like counts for each post
  Map<String, int> _likeCount = {};

  // Local list to track posts liked by current user
  List<String> _likedPosts = [];

  // Is post liked by curr user
  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  // get like count of a post
  int getLikeCount(String postId) => _likeCount[postId] ?? 0;

  // initialize like map locally
  void initLikeMap() {
    final currentUserId = _auth.getCurrentUserId();
    _likedPosts.clear();
    _searchResults.clear();
    for (var post in _allPosts) {
      _likeCount[post.id] = post.likeCount;
      if (post.likedBy.contains(currentUserId)) {
        _likedPosts.add(post.id);
      }
    }
  }

  // Toggle Like a post
  Future<void> toggleLike(String postId) async {
    final likedPostsOriginal = _likedPosts;
    final likeCountOriginal = _likeCount;

    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCount[postId] = (_likeCount[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCount[postId] = (_likeCount[postId] ?? 0) + 1;
    }

    notifyListeners();

    try {
      await _db.likeToggleInFirebase(postId);
    } catch (e) {
      _likedPosts = likedPostsOriginal;
      _likeCount = likeCountOriginal;
      notifyListeners();
    }
  }

  /*

    Comments(MAP of posts-comments)
    {
      postId : [comment1,comment2]
      postId : [comment1,comment2]
      postId : [comment1,comment2]
    }

   */

  // local list of comments for each post
  Map<String, List<Comment>> _comments = {};

  // fetch comments locally
  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  // fetch comments from db for a post
  Future<void> loadComments(String postId) async {
    final allComments = await _db.fetchCommentsOnPost(postId);
    _comments[postId] = allComments;
    notifyListeners();
  }

  // add a comment
  Future<void> addComment(String postId, message) async {
    await _db.addCommentInFirebase(postId, message);
    await loadComments(postId);
  }

  // delete a comment
  Future<void> deleteComment(String commentId, postId) async {
    await _db.deleteCommentInFirebase(commentId);
    await loadComments(postId);
  }

  /*
  ACCOUNT STUFF
   */

  // local list of blocked users
  List<UserProfile> _blockedUsers = [];

  List<UserProfile> get blockedUser => _blockedUsers;

  // fetch blocked users
  Future<void> loadBlockedUsers() async {
    final blockedUids = await _db.getBlockedUIdsFromFirebase();

    final blockedUserData = await Future.wait(
      blockedUids.map((id) => _db.getUser(id)),
    );

    _blockedUsers = blockedUserData.whereType<UserProfile>().toList();

    notifyListeners();
  }

  //block user
  Future<void> blockUser(String userId) async {
    await _db.blockUserInFirebase(userId);

    await loadBlockedUsers();

    await getAllPosts();
  }

  // unblock user
  Future<void> unblockUser(String userId) async {
    await _db.unblockUserInFirebase(userId);

    await loadBlockedUsers();

    await getAllPosts();
  }

  // report user & post
  Future<void> reportUser(String postId, userId) async {
    await _db.reportPostInFirebase(postId, userId);
  }

  // Follow / Unfollow

  Map<String, List<String>> _followers = {};
  Map<String, List<String>> _following = {};
  Map<String, int> _followerCount = {};
  Map<String, int> _followingCount = {};

  int getFollowersCount(String uid) => _followerCount[uid] ?? 0;

  int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

  // load Followers
  Future<void> loadUserFollowers(String uid) async {
    final listOfFollowersUids = await _db.getFollowersUidsFromFirebase(uid);
    _followers[uid] = listOfFollowersUids;
    _followerCount[uid] = listOfFollowersUids.length;

    notifyListeners();
  }

  // load following
  Future<void> loadUserFollowing(String uid) async {
    final listOfFollowingUids = await _db.getFollowingUidsFromFirebase(uid);
    print("loadUserFollowing ${listOfFollowingUids}");
    _following[uid] = listOfFollowingUids;
    _followingCount[uid] = listOfFollowingUids.length;

    notifyListeners();
  }

  // Follow user
  Future<void> followUser(String targetUserId) async {
    String currentUserId = _auth.getCurrentUserId();
    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    if (!_followers[targetUserId]!.contains(currentUserId)) {
      _followers[targetUserId]?.add(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

      _following[currentUserId]?.add(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;
    }

    notifyListeners();
    print("FOLLOWING ${_following}");
    print("followers ${_followers}");

    try {
      await _db.followUserinFirebase(targetUserId);

      await loadUserFollowers(currentUserId);
      await loadUserFollowing(currentUserId);

    } catch (e) {
      print(e);
      // If some error occurs , undo everything
      _followers[targetUserId]?.remove(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) - 1;

      _following[currentUserId]?.remove(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) - 1;

      notifyListeners();
    }
  }

  // Unfollow user
  Future<void> unfollowUser(String targetUserId) async {
    String currentUserId = _auth.getCurrentUserId();
    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    if (_followers[targetUserId]!.contains(currentUserId)) {
      _followers[targetUserId]?.remove(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) - 1;

      _following[currentUserId]?.remove(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) - 1;
    }

    notifyListeners();

    print("unFOLLOWING ${_following.length}");
    print("unfollowers ${_followers.length}");

    try {
      await _db.unfollowUserInFirebase(targetUserId);

      await loadUserFollowers(currentUserId);
      await loadUserFollowing(currentUserId);
    } catch (e) {
      print(e);
      // If some error occurs , undo everything
      _followers[targetUserId]?.add(currentUserId);
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

      _following[currentUserId]?.add(targetUserId);
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;

      notifyListeners();
    }
  }

  bool isFollowing(String uid) {
    final currentUserId = _auth.getCurrentUserId();
    return _followers[uid]?.contains(currentUserId) ?? false;
  }

  final Map<String,List<UserProfile>> _followersProfile={};
  final Map<String,List<UserProfile>> _followingProfile={};

  // list of following
  List<UserProfile> getListOfFollowing(String uid) => _followingProfile[uid] ?? [];

  // list of followers
  List<UserProfile> getListOfFollowers(String uid) => _followersProfile[uid] ?? [];


  // load followers for given uid
  Future<void> loadFollowersProfile(String uid) async{
    try{
      final followersIds=await _db.getFollowersUidsFromFirebase(uid);

      List<UserProfile> followersProfile=[];

      for(String followerId in followersIds){
        UserProfile? followerProfile =await _db.getUser(followerId);
        if(followerProfile !=null){
          followersProfile.add(followerProfile);
        }
      }

      _followersProfile[uid] = followersProfile;

      notifyListeners();

    }
    catch(e){
      print(e);
    }
  }

  // load following for given uid
  Future<void> loadFollowingProfile(String uid) async{
    try{
      final followingIds=await _db.getFollowingUidsFromFirebase(uid);

      List<UserProfile> followingsProfile=[];

      for(String followingId in followingIds){
        UserProfile? followingProfile =await _db.getUser(followingId);
        if(followingProfile !=null){
          followingsProfile.add(followingProfile);
        }
      }

      _followingProfile[uid] = followingsProfile;

      notifyListeners();

    }
    catch(e){
      print(e);
    }
  }

  List<UserProfile> _searchResults=[];
  List<UserProfile> get searchResults => _searchResults;
  // Search users
  Future<void> searchUsers(String query) async{
    try{
      final results=await _db.searchUsers(query);
      _searchResults=results;
      notifyListeners();
    }
    catch(e){
      print(e);
    }
  }

}
