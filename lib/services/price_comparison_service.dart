class PriceRecord {
  final String medicineName;
  final String shopName;
  final int shopId;
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
  // Mock database of prices
  final List<PriceRecord> mockDatabase = [
    PriceRecord(
      medicineName: 'Paracetamol',
      shopName: 'MediCare Pharmacy',
      shopId: 1,
      price: 120.00,
    ),
    PriceRecord(
      medicineName: 'Paracetamol',
      shopName: 'Health Plus',
      shopId: 2,
      price: 150.00,
    ),
    PriceRecord(
      medicineName: 'Paracetamol',
      shopName: 'City Pharmacy',
      shopId: 3,
      price: 135.00,
    ),
    PriceRecord(
      medicineName: 'Paracetamol',
      shopName: 'Wellness Store',
      shopId: 4,
      price: 145.00,
    ),
    PriceRecord(
      medicineName: 'Paracetamol',
      shopName: 'GenericMeds',
      shopId: 5,
      price: 125.00,
    ),
    PriceRecord(
      medicineName: 'Aspirin',
      shopName: 'MediCare Pharmacy',
      shopId: 1,
      price: 80.00,
    ),
    PriceRecord(
      medicineName: 'Aspirin',
      shopName: 'Health Plus',
      shopId: 2,
      price: 95.00,
    ),
    PriceRecord(
      medicineName: 'Aspirin',
      shopName: 'City Pharmacy',
      shopId: 3,
      price: 88.00,
    ),
    PriceRecord(
      medicineName: 'Aspirin',
      shopName: 'Wellness Store',
      shopId: 4,
      price: 92.00,
    ),
    PriceRecord(
      medicineName: 'Ibuprofen',
      shopName: 'MediCare Pharmacy',
      shopId: 1,
      price: 175.00,
    ),
    PriceRecord(
      medicineName: 'Ibuprofen',
      shopName: 'Health Plus',
      shopId: 2,
      price: 200.00,
    ),
    PriceRecord(
      medicineName: 'Ibuprofen',
      shopName: 'City Pharmacy',
      shopId: 3,
      price: 185.00,
    ),
    PriceRecord(
      medicineName: 'Metformin',
      shopName: 'MediCare Pharmacy',
      shopId: 1,
      price: 250.00,
    ),
    PriceRecord(
      medicineName: 'Metformin',
      shopName: 'Health Plus',
      shopId: 2,
      price: 280.00,
    ),
    PriceRecord(
      medicineName: 'Metformin',
      shopName: 'City Pharmacy',
      shopId: 3,
      price: 300.00,
    ),
    PriceRecord(
      medicineName: 'Metformin',
      shopName: 'Wellness Store',
      shopId: 4,
      price: 265.00,
    ),
    PriceRecord(
      medicineName: 'Metformin',
      shopName: 'GenericMeds',
      shopId: 5,
      price: 290.00,
    ),
  ];

  /// Get price comparison for a medicine
  /// INPUT: medicine_name
  /// LOGIC:
  /// 1. GET all records WHERE medicine_name matches input
  /// 2. IF prices_list is empty: SHOW "No price data available"
  /// 3. FOR each record: attach shop_name using shop_id
  /// 4. SORT prices_list by price ASCENDING
  /// 5. Calculate cheapest, costliest, average price
  /// 6. RETURN all results
  PriceComparisonResult comparePrices(String medicineName) {
    // Step 1: Get all records matching the medicine name
    final pricesList = mockDatabase
        .where((record) =>
            record.medicineName.toLowerCase() ==
            medicineName.toLowerCase())
        .toList();

    // Step 2: Check if empty
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

    // Step 3: Shop names are already attached (shopName field)
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
}
