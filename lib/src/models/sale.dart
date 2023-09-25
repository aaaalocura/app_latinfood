

class PosApiModel {
  final int cliente;
  final double total;
  final double efectivo;
  final double change;
  final List<Item> items;

  PosApiModel({
    required this.cliente,
    required this.total,
    required this.efectivo,
    required this.change,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> itemsJson = items.map((item) => item.toJson()).toList();

    return {
      "cliente": cliente,
      "total": total,
      "efectivo": efectivo,
      "change": change,
      "itemsQuantity": items.fold(0, (sum, item) => sum + item.quantity),
      "items": itemsJson,
    };
  }
}

class Item {
  final int id;
  final int quantity;
  int? tam;

  Item({
    required this.id,
    required this.quantity,
    this.tam, 
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quantity": quantity,
    };
  }
}
