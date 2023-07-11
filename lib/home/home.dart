import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import '../call/call_page.dart';
import '../post/add_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          color: Colors.purple,
          title: message.notification!.title,
          body: message.notification!.body,
          category: NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          backgroundColor: Colors.purple,
          displayOnForeground: true,
          displayOnBackground: true,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'REJECT',
            label: 'Reject',
            autoDismissible: true,
            color: Colors.red,
            buttonType: ActionButtonType.Default,
          ),
          NotificationActionButton(
            key: 'ACCEPT',
            label: 'Accept',
            autoDismissible: true,
            color: Colors.green,
            buttonType: ActionButtonType.Default,
          ),
        ],
      );
      AwesomeNotifications().actionStream.listen((event) async {
        String callId = await FirebaseFirestore.instance
            .collection('Call')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) => value.data()!['callId']);
        String type = await FirebaseFirestore.instance
            .collection('Call')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) => value.data()!['type']);
        if (event.buttonKeyPressed == 'ACCEPT') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallPage(
                callID: callId,
                callType: type,
                userID: FirebaseAuth.instance.currentUser!.uid,
                userName: FirebaseAuth.instance.currentUser!.displayName!,
              ),
            ),
          );
        } else if (event.buttonKeyPressed == 'REJECT') {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 12,
              channelKey: 'basic_channel',
              color: Colors.purple,
              title: 'Rejected',
              body: 'You have rejected the call',
              category: NotificationCategory.Call,
            ),
          );
        }
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          color: Colors.purple,
          title: message.notification!.title,
          body: message.notification!.body,
          category: NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          backgroundColor: Colors.purple,
          displayOnForeground: true,
          displayOnBackground: true,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'REJECT',
            label: 'Reject',
            autoDismissible: true,
            color: Colors.red,
            buttonType: ActionButtonType.Default,
          ),
          NotificationActionButton(
            key: 'ACCEPT',
            label: 'Accept',
            autoDismissible: true,
            color: Colors.green,
            buttonType: ActionButtonType.Default,
          ),
        ],
      );
      AwesomeNotifications().actionStream.listen((event) async {
        String callId = await FirebaseFirestore.instance
            .collection('Call')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) => value.data()!['callId']);
        String type = await FirebaseFirestore.instance
            .collection('Call')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) => value.data()!['type']);
        if (event.buttonKeyPressed == 'ACCEPT') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallPage(
                callID: callId,
                callType: type,
                userID: FirebaseAuth.instance.currentUser!.uid,
                userName: FirebaseAuth.instance.currentUser!.displayName!,
              ),
            ),
          );
        } else if (event.buttonKeyPressed == 'REJECT') {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 12,
              channelKey: 'basic_channel',
              color: Colors.purple,
              title: 'Rejected',
              body: 'You have rejected the call',
              category: NotificationCategory.Call,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            color: Colors.grey[300],
            height: 4,
          ),
        ),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          // welcome if the name is too long or if doesn't exist
          child: Text(
            FirebaseAuth.instance.currentUser!.displayName == null
                ? 'Welcome'
                : 'Welcome, ${FirebaseAuth.instance.currentUser!.displayName!.split(' ')[0]}!',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddPostPage(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: const ViewPostListView(),
    );
  }
}

class ViewPostListView extends StatefulWidget {
  const ViewPostListView({super.key});

  @override
  State<ViewPostListView> createState() => _ViewPostListViewState();
}

class _ViewPostListViewState extends State<ViewPostListView> {
  void deletePost(String postId, BuildContext context) {}

  Stream<QuerySnapshot> getPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No Posts'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return PostCard(
              postName: snapshot.data!.docs[index]['name'],
              description: snapshot.data!.docs[index]['description'],
              imageUrl: snapshot.data!.docs[index]['imageUrl'],
              userId: snapshot.data!.docs[index]['postedBy'],
              createdAt: snapshot.data!.docs[index]['createdAt'].toDate(),
              likes: snapshot.data!.docs[index]['likes'],
              comments: snapshot.data!.docs[index]['comments'],
              onDeletePressed: () async {
                await FirebaseFirestore.instance
                    .collection('posts')
                    .doc(snapshot.data!.docs[index].id)
                    .delete()
                    .then(
                  (value) async {
                    await FirebaseStorage.instance
                        .refFromURL(snapshot.data!.docs[index]['imageUrl'])
                        .delete()
                        .then(
                      (value) {
                        setState(
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Post Deleted Successfully'),
                              ),
                            );
                          },
                        );
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              onLikePressed: () async {
                snapshot.data!.docs[index]['likes'].contains(
                  FirebaseAuth.instance.currentUser!.uid,
                )
                    ? await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(snapshot.data!.docs[index].id)
                        .update(
                        {
                          'likes': FieldValue.arrayRemove(
                            [
                              FirebaseAuth.instance.currentUser!.uid,
                            ],
                          ),
                        },
                      )
                    : await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(snapshot.data!.docs[index].id)
                        .update(
                        {
                          'likes': FieldValue.arrayUnion(
                            [
                              FirebaseAuth.instance.currentUser!.uid,
                            ],
                          ),
                        },
                      );

                setState(() {});
              },
              onCommentPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentPage(
                      postId: snapshot.data!.docs[index].id,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class CommentPage extends StatefulWidget {
  final String postId;

  const CommentPage({super.key, required this.postId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();

  void addComment(String postId, String comment) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update(
      {
        'comments': FieldValue.arrayUnion(
          [
            {
              'comment': comment,
              'commentedBy': FirebaseAuth.instance.currentUser!.uid,
              'createdAt': DateTime.now(),
            },
          ],
        ),
      },
    );
    setState(() {});
  }

  Future<String> getUserName(String userId) async {
    final DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('Register')
        .doc(userId)
        .get();
    return user['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No Comments'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!['comments'].length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<String>(
                      future: getUserName(
                        snapshot.data!['comments'][index]['commentedBy'],
                      ),
                      builder: (context, snapshot1) {
                        if (snapshot1.hasError) {
                          return const Center(
                            child: Text('Something went wrong'),
                          );
                        }

                        if (snapshot1.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot1.hasData) {
                          return const Center(
                            child: Text('No Comments'),
                          );
                        }

                        return ListTile(
                          title: Text(snapshot1.data!),
                          subtitle: Text(
                            snapshot.data!['comments'][index]['comment'],
                          ),
                          trailing: Text(
                            DateFormat.timeAgoSinceDate(
                              date: snapshot.data!['comments'][index]
                                      ['createdAt']
                                  .toDate(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.05,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Add Comment',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: _commentController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                addComment(
                                    widget.postId, _commentController.text);
                                _commentController.clear();
                              },
                              icon: const Icon(Icons.send),
                            )
                          : const SizedBox(),
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

class DateFormat {
  static String timeAgoSinceDate({required DateTime date}) {
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return '1 year ago';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return '1 month ago';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return '1 week ago';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return '1 day ago';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return '1 hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return '1 minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

class PostCard extends StatelessWidget {
  final String postName;
  final String description;
  final String imageUrl;
  final String userId;
  final DateTime createdAt;
  final List<dynamic> likes;
  final List<dynamic> comments;
  final void Function()? onDeletePressed;
  final void Function()? onLikePressed;
  final void Function()? onCommentPressed;

  const PostCard({
    super.key,
    required this.postName,
    required this.description,
    required this.imageUrl,
    required this.userId,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.onDeletePressed,
    required this.onLikePressed,
    required this.onCommentPressed,
  });

  Future<String> getUserName(String userId) async {
    return await FirebaseFirestore.instance
        .collection('Register')
        .doc(userId)
        .get()
        .then((value) => value.data()!['name']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  postName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Image.network(imageUrl),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          FutureBuilder<String>(
            future: getUserName(userId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListTile(
                title: Text(
                  snapshot.data!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                    '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute}'),
                trailing: FirebaseAuth.instance.currentUser!.uid == userId ||
                        FirebaseAuth.instance.currentUser!.email ==
                            'admin@gmail.com'
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete Post'),
                                content: const Text(
                                    'Are you sure you want to delete this post?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: onDeletePressed,
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete),
                      )
                    : null,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  likes.contains(FirebaseAuth.instance.currentUser!.uid)
                      ? IconButton(
                          onPressed: onLikePressed,
                          icon: const Icon(Icons.favorite),
                          color: Colors.red,
                        )
                      : IconButton(
                          onPressed: onLikePressed,
                          icon: const Icon(Icons.favorite_border),
                        ),
                  Text('${likes.length}'),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onCommentPressed,
                    icon: const Icon(Icons.comment),
                  ),
                  Text('${comments.length}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
