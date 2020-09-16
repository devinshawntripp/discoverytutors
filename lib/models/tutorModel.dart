class Tutor {
  int totalVotes;
  int contributions;
  String firstName;
  int rating;
  String docid;
  int rate;
  List<String> classes;
  bool prof;
  String tutorID;

  Tutor.fromMap(Map<String, dynamic> data, String docid) {
    this.totalVotes = data['totalvotes'];
    this.docid = docid;
    this.rating = data['rating'];
    this.rate = data['rate'];
    this.prof = data['prof'] ?? false;
    this.tutorID = data['tutorid'];
    try {
      this.classes = data['classes'].cast<String>();
    } catch (error) {}

    this.firstName = data['firstname'];
    this.contributions = data['Contributions'];
  }

  Tutor(
      {this.firstName,
      this.rating,
      this.docid,
      this.classes,
      this.rate,
      this.contributions,
      this.totalVotes,
      this.prof});
}
