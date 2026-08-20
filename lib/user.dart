class User {
  const User({
    required this.name,
    required this.age,
    required this.headline,
    required this.learningTrack,
  });

  final String name;
  final int age;
  final String headline;
  final String learningTrack;

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      age: map['age'] as int,
      headline: map['headline'] as String,
      learningTrack: map['learningTrack'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'headline': headline,
      'learningTrack': learningTrack,
    };
  }
}
