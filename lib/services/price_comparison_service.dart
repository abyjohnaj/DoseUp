import 'shop_data_service.dart';

class PriceRecord {
  final String medicineName;
  final String shopName;
  final String shopId;
  final double price;

  PriceRecord({
    required this.medicineName,
    required this.shopName,
    required this.shopId,
    required this.price,
  });
}

class PriceComparisonResult {
  final bool found;
  final String message;
  final List<PriceRecord> allPrices;
  final PriceRecord? cheapest;
  final PriceRecord? costliest;
  final double? averagePrice;

  PriceComparisonResult({
    required this.found,
    required this.message,
    required this.allPrices,
    this.cheapest,
    this.costliest,
    this.averagePrice,
  });
}

class PriceComparisonService {
  final ShopDataService _shopDataService = ShopDataService();

  /// Get price comparison for a medicine
  /// INPUT: medicine_name (partial name is OK)
  /// LOGIC:
  /// 1. GET all shops and their medicines
  /// 2. IF no matches found: SHOW "No price data available"
  /// 3. Collect all matching prices from all shops
  /// 4. SORT prices_list by price ASCENDING
  /// 5. Calculate cheapest, costliest, average price
  /// 6. RETURN all results
  PriceComparisonResult comparePrices(String medicineName) {
    final shops = _shopDataService.getAllShops();
    final pricesList = <PriceRecord>[];
    final searchQuery = medicineName.toLowerCase();

    // Step 1 & 2: Get all records matching the medicine name (partial match)
    for (var shop in shops) {
      final matchingMedicine = shop.medicines.firstWhere(
        (medicine) =>
            medicine.name.toLowerCase().contains(searchQuery),
        orElse: () => Medicine(name: '', available: false, price: 0),
      );

      if (matchingMedicine.name.isNotEmpty) {
        pricesList.add(
          PriceRecord(
            medicineName: matchingMedicine.name,
            shopName: shop.name,
            shopId: shop.shopId,
            price: matchingMedicine.price,
          ),
        );
      }
    }

    // Check if empty
    if (pricesList.isEmpty) {
      return PriceComparisonResult(
        found: false,
        message: 'No price data available for "$medicineName"',
        allPrices: [],
        cheapest: null,
        costliest: null,
        averagePrice: null,
      );
    }

    // Step 4: Sort by price ascending
    pricesList.sort((a, b) => a.price.compareTo(b.price));

    // Step 5: Calculate statistics
    final cheapest = pricesList.first;
    final costliest = pricesList.last;
    final averagePrice =
        pricesList.fold(0.0, (sum, record) => sum + record.price) /
            pricesList.length;

    return PriceComparisonResult(
      found: true,
      message: 'Found ${pricesList.length} price options for "$medicineName"',
      allPrices: pricesList,
      cheapest: cheapest,
      costliest: costliest,
      averagePrice: averagePrice,
    );
  }

  /// Get all available medicine names
  List<String> getAllMedicineNames() {
    return _shopDataService.getAllMedicineNames();
  }

  /// Get price comparison for a medicine in a specific location
  PriceComparisonResult comparePricesByLocation(
      String medicineName, String location) {
    final shops = _shopDataService.getAllShops();
    final searchQuery = medicineName.toLowerCase();
    final locationLower = location.toLowerCase();
    
    final pricesList = <PriceRecord>[];

    // Filter shops by location and medicine
    for (var shop in shops) {
      if (shop.location.toLowerCase() == locationLower) {
        final matchingMedicine = shop.medicines.firstWhere(
          (medicine) =>
              medicine.name.toLowerCase().contains(searchQuery),
          orElse: () => Medicine(name: '', available: false, price: 0),
        );

        if (matchingMedicine.name.isNotEmpty) {
          pricesList.add(
            PriceRecord(
              medicineName: matchingMedicine.name,
              shopName: shop.name,
              shopId: shop.shopId,
              price: matchingMedicine.price,
            ),
          );
        }
      }
    }

    if (pricesList.isEmpty) {
      return PriceComparisonResult(
        found: false,
        message:
            'No price data available for "$medicineName" in $location',
        allPrices: [],
        cheapest: null,
        costliest: null,
        averagePrice: null,
      );
    }

    pricesList.sort((a, b) => a.price.compareTo(b.price));

    final cheapest = pricesList.first;
    final costliest = pricesList.last;
    final averagePrice =
        pricesList.fold(0.0, (sum, record) => sum + record.price) /
            pricesList.length;

    return PriceComparisonResult(
      found: true,
      message:
          'Found ${pricesList.length} price options for "$medicineName" in $location',
      allPrices: pricesList,
      cheapest: cheapest,
      costliest: costliest,
      averagePrice: averagePrice,
    );
  }
}
