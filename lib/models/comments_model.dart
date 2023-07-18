import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  Map? data;
  String? profilePicture;
  String? userID;
  String? userName;
  String? docID;
  bool? isVidUploaded;
  bool? isImgUploaded;
  bool? textOnly;
  String? text;
  String? textLang;
  Timestamp? date;
  String? dateString;
  int? likes;
  int? dislikes;
  int? reps;
  String? image;
  String? imagePath;
  String? vid;
  String? vidname;
  String? vidthumb;
  String? vidpath;
  String? storageref;
  String? storagerefVid;
  String? storagerefThumb;
  String? token;

  CommentsModel({
    this.data,
    this.profilePicture,
    this.userID,
    this.userName,
    this.docID,
    this.isVidUploaded,
    this.isImgUploaded,
    this.textOnly,
    this.text,
    this.textLang,
    this.date,
    this.dateString,
    this.likes,
    this.dislikes,
    this.reps,
    this.vid,
    this.vidname,
    this.vidthumb,
    this.vidpath,
    this.image,
    this.imagePath,
    this.storageref,
    this.storagerefVid,
    this.storagerefThumb,
    this.token,
  });

  CommentsModel.fromMap(Map<String, dynamic> snapshot) {
    data = snapshot;
    profilePicture = snapshot['pfp'];
    userID = snapshot['UserID'];
    userName = snapshot['username'];
    docID = snapshot['commentID'];
    isVidUploaded = snapshot['isVidUploaded'];
    isImgUploaded = snapshot['isImgUploaded'];
    textOnly = snapshot['textOnly'];
    text = snapshot['text'];
    textLang = snapshot['textLANG'];
    date = snapshot['date'];
    dateString = snapshot['dateSTRING'];
    likes = snapshot['likes'];
    dislikes = snapshot['dislikes'];
    reps = snapshot['reps'];
    vid = snapshot['vid'];
    vidname = snapshot['vidname'];
    vidthumb = snapshot['vidthumb'];
    vidpath = snapshot['vidpath'];
    image = snapshot['image'];
    imagePath = snapshot['imagepath'];
    storageref = snapshot['storageref'];
    storagerefVid = snapshot['storageref_vid'];
    storagerefThumb = snapshot['storageref_thumb'];
    token = snapshot['token'];
  }
}
