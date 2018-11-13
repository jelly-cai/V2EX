class Member {
  String userName;
  String website;
  String github;
  String psn;
  String avatarNormal;
  String bio;
  String url;
  String tagLine;
  String twitter;
  int created;
  String avatarLarge;
  String avatarMini;
  String location;
  String btc;
  int id;
  String info;

  Member(
      {this.userName,
      this.website,
      this.github,
      this.psn,
      this.avatarNormal,
      this.bio,
      this.url,
      this.tagLine,
      this.twitter,
      this.created,
      this.avatarLarge,
      this.avatarMini,
      this.location,
      this.btc,
      this.id,
      this.info});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        userName: json['username'],
        website: json['website'],
        github: json['github'],
        psn: json['psn'],
        avatarNormal: json['avatar_normal'],
        bio: json['bio'],
        url: json['url'],
        tagLine: json['tagline'],
        twitter: json['twitter'],
        created: json['created'],
        avatarLarge: json['avatar_large'],
        avatarMini: json['avatar_mini'],
        location: json['location'],
        btc: json['btc'],
        id: json['id'],
        info: json['info']);
  }
}
