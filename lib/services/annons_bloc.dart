import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:student_market_app/services/database.dart';
import 'package:student_market_app/global.dart' as global;

import '../global.dart';

class AnnonsBloc {
  DatabaseService databaseService;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;

  BehaviorSubject<List<DocumentSnapshot>> annonsController;

  BehaviorSubject<bool> showIndicatorController;

  AnnonsBloc() {
    annonsController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    databaseService = DatabaseService();
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get annonsStream => annonsController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList(String filter) async {
    try {
      documentList = await databaseService.fetchFirstList(filter);
      print(documentList);
      annonsController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          annonsController.sink.addError(global.currentLanguage == Language.eng
              ? "No Data Available"
              : "Ingen data tillgänglig");
        }
      } catch (e) {}
    } on SocketException {
      annonsController.sink.addError(SocketException(global.currentLanguage == Language.eng
          ? "No Internet Connection"
          : "Ingen internetanslutning"));
    } catch (e) {
      print(e.toString());
      annonsController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextAnnons() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList =
          await databaseService.fetchNextList(documentList);
      documentList.addAll(newDocumentList);
      annonsController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          annonsController.sink.addError(global.currentLanguage == Language.eng
              ? "No Data Available"
              : "Ingen data tillgänglig");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      annonsController.sink.addError(SocketException(
          global.currentLanguage == Language.eng
              ? "No Internet Connection"
              : "Ingen internetanslutning"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      annonsController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    annonsController.close();
    showIndicatorController.close();
  }
}
