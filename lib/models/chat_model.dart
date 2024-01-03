import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  Map? data;
  String? profilePicture;
  String? userID;
  String? userName;
  Timestamp? date;
  String? dateString;
  bool? reply;
  String? storageref;
  int? messageID;
  String? repliedMessage;
  String? message;
  String? messLANG;
  String? image;
  int? imgID;
  String? imagePath;
  bool? isImgUploaded;
  String? vid;
  String? vidName;
  String? vidPath;
  String? vidThumbPath;
  String? vidThumb;
  int? vidID;
  bool? isVidUploaded;
  String? storagerefVid;
  String? storagerefThumb;
  String? toLANG;
  String? toType;
  String? repliedTo;
  String? repliedImg;
  String? repliedVid;
  String? voice;
  bool? isVoiceUploaded;
  int? repliedMessID;
  String? duration;

  ChatModel({
    this.data,
    this.profilePicture,
    this.userID,
    this.userName,
    this.date,
    this.dateString,
    this.reply,
    this.storageref,
    this.messageID,
    this.message,
    this.messLANG,
    this.image,
    this.imgID,
    this.imagePath,
    this.isImgUploaded,
    this.vid,
    this.vidName,
    this.vidPath,
    this.vidThumbPath,
    this.vidThumb,
    this.vidID,
    this.isVidUploaded,
    this.storagerefVid,
    this.storagerefThumb,
    this.toLANG,
    this.toType,
    this.repliedTo,
    this.repliedImg,
    this.repliedVid,
    this.repliedMessID,
    this.voice,
    this.duration,
    this.isVoiceUploaded,
  });

  ChatModel.fromMap(Map<String, dynamic> snapshot) {
    data = snapshot;
    repliedMessage = snapshot['repliedMess'];
    profilePicture = snapshot['pfp'];
    userID = snapshot['UserID'];
    userName = snapshot['username'];
    date = snapshot['date'];
    dateString = snapshot['dateSTRING'];
    storageref = snapshot['storageref'];
    messageID = snapshot['messageID'];
    message = snapshot['message'];
    messLANG = snapshot['messLANG'];
    image = snapshot['image'];
    imgID = snapshot['imgID'];
    imagePath = snapshot['imagepath'];
    isImgUploaded = snapshot['isImgUploaded'];
    vid = snapshot['vid'];
    vidName = snapshot['vidname'];
    vidPath = snapshot['vidpath'];
    vidThumbPath = snapshot['vidthumbpath'];
    vidThumb = snapshot['vidthumb'];
    vidID = snapshot['vidID'];
    isVidUploaded = snapshot['isVidUploaded'];
    storagerefVid = snapshot['storageref_vid'];
    storagerefThumb = snapshot['storageref_thumb'];
    reply = snapshot['reply'];
    toLANG = snapshot['ToLang'];
    toType = snapshot['ToType'];
    repliedTo = snapshot['repliedTO'];
    repliedImg = snapshot['repliedImg'];
    repliedVid = snapshot['repliedVid'];
    repliedMessID = snapshot['repliedMessID'];
    voice = snapshot.containsKey('voice') ? snapshot['voice'] : null;
    duration = snapshot.containsKey('duration') ? snapshot['duration'] : null;
    isVoiceUploaded = snapshot.containsKey('isVoiceUploaded')
        ? snapshot['isVoiceUploaded']
        : null;
  }
}
