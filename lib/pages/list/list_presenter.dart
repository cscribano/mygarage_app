import '../../models/mockupmodel.dart';
import '../generic_presenter.dart';


abstract class ListViewContract extends AuthViewContract<List<Mock>>{}

class ListPresenter extends BaseAuthPresenter<List<Mock>>{

  ListPresenter(GenericViewContract<List<Mock>> view) : super(view);

  getList(){
    //var auth_headers = this.view.getAuth();
    //fetchData(api.getMocks(auth_headers));
    fetchData(db.getAllMocks());
  }
}