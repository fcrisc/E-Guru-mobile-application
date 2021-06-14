class Student {
  String referenceId;
  String firsName;
  String lastName;

  Student(this.referenceId, this.firsName, this.lastName);

  factory Student.fromasdasdasdasd(json) =>
      new Student(json['reference_id'], json['first_name'], json['last_name']);
}
