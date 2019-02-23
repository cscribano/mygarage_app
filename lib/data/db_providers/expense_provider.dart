import '../../models/expensemodel.dart';
import '../base_providers.dart';

class ExpenseProvider extends GenericProvider<Expense> {
  ExpenseProvider._() : super(model: "Expense", fromJson: (Map<String, dynamic> jsonData) => Expense.fromJson(jsonData));
  static final ExpenseProvider _ep = ExpenseProvider._(); //singleton
  factory ExpenseProvider() => _ep;

  //Todo: add other utility methods
}