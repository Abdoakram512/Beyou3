import 'package:equatable/equatable.dart';

class FaqModel extends Equatable {
  final String question;
  final String answer;

  const FaqModel({required this.question, required this.answer});

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'question': question, 'answer': answer};
  }

  @override
  List<Object?> get props => [question, answer];
}
