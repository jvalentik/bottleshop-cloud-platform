import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/features/auth/data/services/user_db_service.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/home/data/models/favorite_item_model.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';

class WishListService with NetworkLoggy {
  final Reader read;
  late WishListDBService? db;

  WishListService(this.read) {
    final uid = read(currentUserProvider)?.uid;
    db = uid == null
        ? null
        : WishListDBService(FirestorePaths.userFavorites(uid));
  }

  Future<void> add(String? id) async {
    if (db == null) return;

    loggy.info('adding $id');
    var ref =
        db!.db.collection(FirestoreCollections.productsCollection).doc(id);
    var item = FavoriteItemModel(product: ref, addedAt: DateTime.now());
    await db!.create(item.toMap(), id: id);
  }

  Future<void> remove(String id) async {
    if (db == null) return;

    loggy.info('removing $id');
    await db!.removeItem(id);
  }

  Stream<List<ProductModel>> get wishList =>
      db == null ? const Stream.empty() : db!.getWishListStream();
}
