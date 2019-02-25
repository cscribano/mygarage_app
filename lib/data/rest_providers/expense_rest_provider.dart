import '../../models/expensemodel.dart';
import '../base_providers.dart';
import '../rest_helper.dart';
import '../../utils/network_util.dart';

class ExpenseRestProvider implements SyncRestBaseProvider<Expense>{

  RestData _api = RestData();
  NetworkUtil _netutil = NetworkUtil();

  ExpenseRestProvider._();
  static final ExpenseRestProvider _erp = ExpenseRestProvider._(); //singleton
  factory ExpenseRestProvider() => _erp;

  @override
  Future<List<Expense>> getUpdatedItems({Map<String, String> auth_headers, int revision}) async{
    var response = await _netutil.get(_api.urls['get_updated_expenses']+revision.toString(), headers: auth_headers);
    List<Expense> list = response.isNotEmpty ? response.map<Expense>((c) => Expense.fromJson(c)).toList() : [];
    return list;
  }

  @override
  Future<dynamic> upsert(Map<String, String> auth_headers, Expense newItem, int revision) async{
    var post = newItem.toJson_API(rev: revision?? 1);
    return await _netutil.post(_api.urls['get_expenses'], headers: auth_headers, body: post);
  }

  Future<List<Expense>>getVehicles(Map<String,String> auth_headers) async {
    var response = await _netutil.get(_api.urls['get_expenses'], headers: auth_headers);
    List<Expense> list = response.isNotEmpty ? response.map<Expense>((c) => Expense.fromJson(c)).toList() : [];
    return list;
  }

  @override
  Future<int> getModelMaxRev({Map<String, String> auth_headers}) async {
    var response = await _netutil.get(_api.urls['get_updated_expenses'], headers: auth_headers);
    return response['rev_sync__max']?? 0; //danger?
  }
}