class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  // default constructor
  TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  // factory constructor จะเรียกไปยัง default constructor อีกที
  //
  // factory constructor หมายถึง constructor ที่อาจจะสร้าง instance ของคลาสหรือไม่ก็ได้
  // ในที่นี้เราสร้าง instance ของ ToModel โดยเรียกไปที่ default constructor
  // แล้วก็ return instance นั้นกลับไป (สังเกตว่าต้อง return ซึ่งต่างจาก constructor ทั่วๆไป
  // ที่เราไม่ต้องสั่ง return เอง แต่จะเป็นการสร้าง instance เสมอ)
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    // TodoModel(...) คือการสร้าง instance ของคลาส TodoModel
    // โดยเรียกไปที่ default constructor (จะระบุหรือไม่ระบุคีย์เวิร์ด new ก็ได้)
    return TodoModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
