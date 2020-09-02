library datos;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_middleware/MultipleCollectionStreamSystem.dart';
import 'package:flutter_firebase_middleware/ComponenteBD.dart';

class Datos {
  static StreamBuilder<QuerySnapshot> obtenerStreamBuilderCollectionBD(
      String collectionPath,
      Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return obtenerStreamBuilderCollectionBDFromReference(
        obtenerColeccion(collectionPath), builder);
  }

  static MultipleCollectionStreamSystem obtenerStreamsCollectionsBD(
          Map<Type, String> collectionPaths) =>
      MultipleCollectionStreamSystem(collectionPaths.map(
          (type, collectionPath) => MapEntry(type, obtenerColeccion(collectionPath).snapshots())));

  static StreamBuilder<Map<Type, QuerySnapshot>>
      obtenerStreamBuilderFromMultipleCollectionStreamSystem(
          MultipleCollectionStreamSystem multipleCollectionStreamSystem,
          Widget Function(BuildContext, AsyncSnapshot<Map<Type, QuerySnapshot>>)
              builder) {
    return StreamBuilder<Map<Type, QuerySnapshot>>(
      stream: multipleCollectionStreamSystem.stream,
      builder: builder,
    );
  }

  static StreamBuilder<QuerySnapshot>
      obtenerStreamBuilderCollectionBDFromReference(
          CollectionReference collectionReference,
          Widget Function(BuildContext, AsyncSnapshot<QuerySnapshot>) builder) {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionReference.snapshots(),
      builder: builder,
    );
  }

  static StreamBuilder<DocumentSnapshot> obtenerStreamBuilderDocumentBD(
      String documentPath,
      Widget Function(BuildContext, AsyncSnapshot<DocumentSnapshot>) builder) {
    return obtenerStreamBuilderDocumentBDFromReference(
        obtenerDocumento(documentPath), builder);
  }

  static StreamBuilder<DocumentSnapshot>
      obtenerStreamBuilderDocumentBDFromReference(
          DocumentReference documentReference,
          Widget Function(BuildContext, AsyncSnapshot<DocumentSnapshot>)
              builder) {
    return StreamBuilder<DocumentSnapshot>(
      stream: documentReference.snapshots(),
      builder: builder,
    );
  }

  static CollectionReference obtenerColeccion(String collectionPath) =>
      FirebaseFirestore.instance.collection(collectionPath);
  static DocumentReference obtenerDocumento(String documentPath) =>
      FirebaseFirestore.instance.doc(documentPath);

  static Future<DocumentReference> crearDocument(
      String collectionPath, Map<String, dynamic> data) {
    return FirebaseFirestore.instance.collection(collectionPath).add(data);
  }

  static Future<void> eliminarTodosLosComponentes<T extends ComponenteBD>(
          Iterable<T> listado) =>
      Future.forEach(listado, (componente) => componente.deleteFromBD());

  static Widget obtenerListViewItem<T>(
      {T item,
      String displayName,
      bool selected = false,
      Color selectedColor = Colors.blue,
      Function(T) onSelected}) {
    Function onTap;
    if (onSelected != null) {
      onTap = () => onSelected(item);
    }

    return Container(
      color: selected ? selectedColor : null,
      child: ListTile(
        title: Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            Text(
              displayName,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
