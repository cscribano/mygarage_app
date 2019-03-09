import '../../models/expensemodel.dart';
import '../base_providers.dart';

class ExpenseProvider extends GenericProvider<Expense> {

  ExpenseProvider._() : super(model: "Expense", fromJson: (Map<String, dynamic> jsonData) => Expense.fromJson(jsonData));
  static final ExpenseProvider _ep = ExpenseProvider._(); //singleton
  factory ExpenseProvider() => _ep;

  //Todo: add other utility methods
  Future<List<Expense>> getAllExpenses({String vehicle, ExpenseEnum type}) async {
    final db = await database;


    String baseWhere = "is_deleted = ?";
    List<dynamic> baseArgs = [0];

    //Return expenses for a particular Vehicle or all vehicles
    if(vehicle != null){
      baseWhere += " AND vehicle = ?";
      baseArgs.add(vehicle);
    }

    //Return expenses of one type or any type
    if(type != null){
      if(type != ExpenseEnum.ANY){
        baseWhere += " AND expense_type = ?";
        baseArgs.add(eeToString(type));
      }
    }
    var res = await db.query("Expense",  where: baseWhere, whereArgs: baseArgs).timeout(const Duration(seconds: 2));

    List<Expense> list = res.isNotEmpty ? res.map((c) => Expense.fromJson(c)).toList() : [];
    return list;
  }

  markAsDeleted(String guid) async{
    final db = await database;
    var ret = await db.update("Expense", {'is_deleted': '1', 'is_dirty' : '1'}, where: 'guid = ?', whereArgs: [guid]);
    return ret;
  }

}