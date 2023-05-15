import 'package:bloc/bloc.dart';
import 'dart:math' as math;
class NameBloc extends Cubit<String?>{
  NameBloc():super(null);

  List<String> names=["foo","bar","foo bar"];


  pickRnadomNmae()
  {
    emit( names.getRandom());
  }



}
extension GetRandomName<T> on Iterable<T>
{
  T getRandom()=>elementAt(math.Random().nextInt(length));
}