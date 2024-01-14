class FeetObservations {
  // Feet

  bool normalArched;
  bool lowArched;
  bool highArched;
  bool flatFeet;

  // Knock Knees

  bool leftNormal;
  bool leftKnockKnee;
  bool leftBowLeg;
  bool leftRecurvatum;
  bool rightNormal;
  bool rightKnockKnee;
  bool rightBowLeg;
  bool rightRecurvatum;

  FeetObservations({
    this.normalArched = false,
    this.lowArched = false,
    this.highArched = false,
    this.flatFeet = false,
    this.leftNormal = false,
    this.leftKnockKnee = false,
    this.leftBowLeg = false,
    this.leftRecurvatum = false,
    this.rightNormal = false,
    this.rightKnockKnee = false,
    this.rightBowLeg = false,
    this.rightRecurvatum = false,
  });

  factory FeetObservations.fromJson(Map<String, dynamic> json) {
    return FeetObservations(
      normalArched: json['normal_arched'],
      lowArched: json['low_arched'],
      highArched: json['high_arched'],
      flatFeet: json['flat_feet'],
      leftNormal: json['left_normal'],
      leftKnockKnee: json['left_knock_knee'],
      leftBowLeg: json['left_bow_leg'],
      leftRecurvatum: json['left_recurvatum'],
      rightNormal: json['right_normal'],
      rightKnockKnee: json['right_knock_knee'],
      rightBowLeg: json['right_bow_leg'],
      rightRecurvatum: json['right_recurvatum'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'normal_arched': normalArched,
      'low_arched': lowArched,
      'high_arched': highArched,
      'flat_feet': flatFeet,
      'left_normal': leftNormal,
      'left_knock_knee': leftKnockKnee,
      'left_bow_leg': leftBowLeg,
      'left_recurvatum': leftRecurvatum,
      'right_normal': rightNormal,
      'right_knock_knee': rightKnockKnee,
      'right_bow_leg': rightBowLeg,
      'right_recurvatum': rightRecurvatum,
    };
  }
}
