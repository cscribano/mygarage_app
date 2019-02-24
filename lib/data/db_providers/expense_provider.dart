import '../../models/expensemodel.dart';
import '../base_providers.dart';

class ExpenseProvider extends GenericProvider<Expense> {

  ExpenseProvider._() : super(model: "Expense", fromJson: (Map<String, dynamic> jsonData) => Expense.fromJson(jsonData));
  static final ExpenseProvider _ep = ExpenseProvider._(); //singleton
  factory ExpenseProvider() => _ep;

  //Todo: add other utility methods
  Future<List<Expense>> getAllVehicleExpenses(String vehicle) async {
    final db = await database;
    var res = await db.query("Expense",  where: "is_deleted = ? AND vehicle = ?", whereArgs: [0, vehicle]).timeout(const Duration(seconds: 2));
    List<Expense> list = res.isNotEmpty ? res.map((c) => Expense.fromJson(c)).toList() : [];
    return list;
  }
}