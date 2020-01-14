import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:student_market_app/services/database.dart';

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
          annonsController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      annonsController.sink.addError(SocketException("No Internet Connection"));
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
          annonsController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      annonsController.sink.addError(SocketException("No Internet Connection"));
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