import 'package:equatable/equatable.dart';

class PaginationEntity extends Equatable {
  final int total;
  final int perPage;
  final int currentPage;
  final int pagesCount;

  const PaginationEntity({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.pagesCount,
  });

  @override
  List<Object?> get props => [total, perPage, currentPage, pagesCount];
}
