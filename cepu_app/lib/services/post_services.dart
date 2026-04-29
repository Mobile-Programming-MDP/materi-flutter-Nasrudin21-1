import 'package:cepu_app/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;
  static final CollectionReference _postsCollection = _database.collection('posts');

  static Future<void> addPost(Post post) async {
    Map<String, dynamic> newPost = {
      'image': post.image,
      'description': post.description,
      'category': post.category,
      'longitude': post.longitude,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'user_id': post.userId,
      'user_fullname': post.userFullname,
    };
    await _postsCollection.add(newPost);
  }

  static Future<List<Post>> getPosts() async {
    QuerySnapshot snapshot = await _postsCollection
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data =
          doc.data() as Map<String, dynamic>;

      data['id'] = doc.id;

      return Post.fromJson(data);
    }).toList();
  }

  static Stream<List<Post>> streamPosts() {
    return _postsCollection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data =
            doc.data() as Map<String, dynamic>;

        data['id'] = doc.id;

        return Post.fromJson(data);
      }).toList();
    });
  }

  static Future<void> updatePost(
      String docId, Post post) async {
    await _postsCollection.doc(docId).update({
      'image': post.image,
      'description': post.description,
      'category': post.category,
      'longitude': post.longitude,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deletePost(String docId) async {
    await _postsCollection.doc(docId).delete();
  }

  static Future<Post?> getPostById(String docId) async {
    DocumentSnapshot doc =
        await _postsCollection.doc(docId).get();

    if (doc.exists) {
      Map<String, dynamic> data =
          doc.data() as Map<String, dynamic>;

      data['id'] = doc.id;

      return Post.fromJson(data);
    }

    return null;
  }
}