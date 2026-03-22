class Medicine {
  final String name;
  final bool available;
  final double price;

  Medicine({
    required this.name,
    required this.available,
    required this.price,
  });
}

class Shop {
  final String shopId;
  final String name;
  final String location;
  final List<Medicine> medicines;

  Shop({
    required this.shopId,
    required this.name,
    required this.location,
    required this.medicines,
  });
}

class ShopDataService {
  static final ShopDataService _instance = ShopDataService._internal();

  factory ShopDataService() {
    return _instance;
  }

  ShopDataService._internal();

  late final List<Shop> shops = _initializeShops();

  List<Shop> _initializeShops() {
    return [
      Shop(
        shopId: 'MS001',
        name: 'Kerala Medicals',
        location: 'Thiruvananthapuram',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 25),
          Medicine(name: 'Amoxicillin 250mg', available: false, price: 80),
          Medicine(name: 'Insulin', available: true, price: 450),
        ],
      ),
      Shop(
        shopId: 'MS002',
        name: 'City Care Pharmacy',
        location: 'Kochi',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 27),
          Medicine(name: 'Azithromycin 500mg', available: true, price: 120),
          Medicine(name: 'Insulin', available: false, price: 460),
        ],
      ),
      Shop(
        shopId: 'MS003',
        name: 'HealthPlus Medicals',
        location: 'Kozhikode',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 30),
          Medicine(name: 'Cefixime 200mg', available: true, price: 150),
          Medicine(name: 'Amoxicillin 250mg', available: true, price: 85),
        ],
      ),
      Shop(
        shopId: 'MS004',
        name: 'Green Cross Pharmacy',
        location: 'Thrissur',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: false, price: 26),
          Medicine(name: 'Insulin', available: true, price: 455),
          Medicine(name: 'Metformin 500mg', available: true, price: 60),
        ],
      ),
      Shop(
        shopId: 'MS005',
        name: 'CareWell Medicals',
        location: 'Kollam',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 24),
          Medicine(name: 'Azithromycin 500mg', available: false, price: 115),
          Medicine(name: 'Metformin 500mg', available: true, price: 58),
        ],
      ),
      Shop(
        shopId: 'MS006',
        name: 'Apollo Pharmacy',
        location: 'Kochi',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 28),
          Medicine(name: 'Insulin', available: true, price: 470),
          Medicine(name: 'Cefixime 200mg', available: false, price: 155),
        ],
      ),
      Shop(
        shopId: 'MS007',
        name: 'MediCare Hub',
        location: 'Kottayam',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 32),
          Medicine(name: 'Metformin 500mg', available: true, price: 62),
          Medicine(name: 'Azithromycin 500mg', available: true, price: 118),
        ],
      ),
      Shop(
        shopId: 'MS008',
        name: 'LifeLine Pharmacy',
        location: 'Alappuzha',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: false, price: 26),
          Medicine(name: 'Amoxicillin 250mg', available: true, price: 82),
          Medicine(name: 'Insulin', available: true, price: 452),
        ],
      ),
      Shop(
        shopId: 'MS009',
        name: 'WellCare Medicals',
        location: 'Palakkad',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 23),
          Medicine(name: 'Metformin 500mg', available: false, price: 59),
          Medicine(name: 'Cefixime 200mg', available: true, price: 148),
        ],
      ),
      Shop(
        shopId: 'MS010',
        name: 'Prime Health Pharmacy',
        location: 'Kannur',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 31),
          Medicine(name: 'Insulin', available: true, price: 465),
          Medicine(name: 'Azithromycin 500mg', available: false, price: 122),
        ],
      ),
      Shop(
        shopId: 'MS011',
        name: 'Trust Medicals',
        location: 'Malappuram',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 25),
          Medicine(name: 'Amoxicillin 250mg', available: true, price: 78),
          Medicine(name: 'Insulin', available: false, price: 455),
        ],
      ),
      Shop(
        shopId: 'MS012',
        name: 'CarePlus Pharmacy',
        location: 'Kasaragod',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: false, price: 26),
          Medicine(name: 'Metformin 500mg', available: true, price: 61),
          Medicine(name: 'Cefixime 200mg', available: true, price: 150),
        ],
      ),
      Shop(
        shopId: 'MS013',
        name: 'HealthFirst Medicals',
        location: 'Pathanamthitta',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 29),
          Medicine(name: 'Insulin', available: true, price: 460),
          Medicine(name: 'Azithromycin 500mg', available: true, price: 117),
        ],
      ),
      Shop(
        shopId: 'MS014',
        name: 'GoodLife Pharmacy',
        location: 'Idukki',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 24),
          Medicine(name: 'Amoxicillin 250mg', available: false, price: 81),
          Medicine(name: 'Metformin 500mg', available: true, price: 57),
        ],
      ),
      Shop(
        shopId: 'MS015',
        name: 'SmartCare Medicals',
        location: 'Ernakulam',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 33),
          Medicine(name: 'Insulin', available: true, price: 468),
          Medicine(name: 'Cefixime 200mg', available: false, price: 152),
        ],
      ),
      Shop(
        shopId: 'MS016',
        name: 'CityMed Pharmacy',
        location: 'Thrissur',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: false, price: 27),
          Medicine(name: 'Azithromycin 500mg', available: true, price: 119),
          Medicine(name: 'Metformin 500mg', available: true, price: 60),
        ],
      ),
      Shop(
        shopId: 'MS017',
        name: 'HealthMart',
        location: 'Kollam',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 25),
          Medicine(name: 'Insulin', available: false, price: 455),
          Medicine(name: 'Cefixime 200mg', available: true, price: 147),
        ],
      ),
      Shop(
        shopId: 'MS018',
        name: 'PharmaCare',
        location: 'Kozhikode',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 30),
          Medicine(name: 'Amoxicillin 250mg', available: true, price: 84),
          Medicine(name: 'Metformin 500mg', available: true, price: 59),
        ],
      ),
      Shop(
        shopId: 'MS019',
        name: 'MediPlus',
        location: 'Kochi',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 28),
          Medicine(name: 'Azithromycin 500mg', available: false, price: 121),
          Medicine(name: 'Insulin', available: true, price: 470),
        ],
      ),
      Shop(
        shopId: 'MS020',
        name: 'Care Pharmacy',
        location: 'Kannur',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 26),
          Medicine(name: 'Cefixime 200mg', available: true, price: 149),
          Medicine(name: 'Metformin 500mg', available: false, price: 58),
        ],
      ),
      Shop(
        shopId: 'MS021',
        name: 'LifeCare',
        location: 'Palakkad',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 31),
          Medicine(name: 'Insulin', available: true, price: 462),
          Medicine(name: 'Azithromycin 500mg', available: true, price: 116),
        ],
      ),
      Shop(
        shopId: 'MS022',
        name: 'Apollo Meds',
        location: 'Trivandrum',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 27),
          Medicine(name: 'Amoxicillin 250mg', available: true, price: 79),
          Medicine(name: 'Metformin 500mg', available: true, price: 61),
        ],
      ),
      Shop(
        shopId: 'MS023',
        name: 'HealthHub',
        location: 'Kottayam',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: false, price: 26),
          Medicine(name: 'Insulin', available: true, price: 465),
          Medicine(name: 'Cefixime 200mg', available: true, price: 150),
        ],
      ),
      Shop(
        shopId: 'MS024',
        name: 'PharmaPoint',
        location: 'Alappuzha',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 32),
          Medicine(name: 'Azithromycin 500mg', available: true, price: 118),
          Medicine(name: 'Metformin 500mg', available: true, price: 60),
        ],
      ),
      Shop(
        shopId: 'MS025',
        name: 'Wellness Pharmacy',
        location: 'Malappuram',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 24),
          Medicine(name: 'Amoxicillin 250mg', available: false, price: 82),
          Medicine(name: 'Insulin', available: true, price: 455),
        ],
      ),
      Shop(
        shopId: 'MS026',
        name: 'MedLife',
        location: 'Kasaragod',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 25),
          Medicine(name: 'Metformin 500mg', available: true, price: 59),
          Medicine(name: 'Cefixime 200mg', available: true, price: 148),
        ],
      ),
      Shop(
        shopId: 'MS027',
        name: 'PrimeCare',
        location: 'Idukki',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 33),
          Medicine(name: 'Insulin', available: false, price: 460),
          Medicine(name: 'Azithromycin 500mg', available: true, price: 120),
        ],
      ),
      Shop(
        shopId: 'MS028',
        name: 'City Pharmacy',
        location: 'Ernakulam',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 28),
          Medicine(name: 'Amoxicillin 250mg', available: true, price: 80),
          Medicine(name: 'Metformin 500mg', available: true, price: 62),
        ],
      ),
      Shop(
        shopId: 'MS029',
        name: 'GreenLife Meds',
        location: 'Thrissur',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: false, price: 26),
          Medicine(name: 'Cefixime 200mg', available: true, price: 149),
          Medicine(name: 'Insulin', available: true, price: 470),
        ],
      ),
      Shop(
        shopId: 'MS030',
        name: 'CareHub',
        location: 'Kollam',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 30),
          Medicine(name: 'Azithromycin 500mg', available: true, price: 117),
          Medicine(name: 'Metformin 500mg', available: false, price: 58),
        ],
      ),
      Shop(
        shopId: 'MS031',
        name: 'HealthWay',
        location: 'Kozhikode',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 25),
          Medicine(name: 'Insulin', available: true, price: 460),
          Medicine(name: 'Cefixime 200mg', available: true, price: 150),
        ],
      ),
      Shop(
        shopId: 'MS032',
        name: 'MediTrust',
        location: 'Kochi',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 27),
          Medicine(name: 'Amoxicillin 250mg', available: true, price: 79),
          Medicine(name: 'Metformin 500mg', available: true, price: 60),
        ],
      ),
      Shop(
        shopId: 'MS033',
        name: 'LifePlus',
        location: 'Kannur',
        medicines: [
          Medicine(name: 'Paracetamol 650mg', available: true, price: 32),
          Medicine(name: 'Azithromycin 500mg', available: false, price: 119),
          Medicine(name: 'Insulin', available: true, price: 468),
        ],
      ),
      Shop(
        shopId: 'MS034',
        name: 'PharmaWorld',
        location: 'Palakkad',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: true, price: 24),
          Medicine(name: 'Cefixime 200mg', available: true, price: 148),
          Medicine(name: 'Metformin 500mg', available: true, price: 59),
        ],
      ),
      Shop(
        shopId: 'MS035',
        name: 'CareFirst',
        location: 'Trivandrum',
        medicines: [
          Medicine(name: 'Paracetamol 500mg', available: false, price: 26),
          Medicine(name: 'Insulin', available: true, price: 465),
          Medicine(name: 'Azithromycin 500mg', available: true, price: 118),
        ],
      ),
    ];
  }

  /// Get all shops
  List<Shop> getAllShops() {
    return shops;
  }

  /// Get unique medicine names across all shops
  List<String> getAllMedicineNames() {
    final medicineSet = <String>{};
    for (var shop in shops) {
      for (var medicine in shop.medicines) {
        medicineSet.add(medicine.name);
      }
    }
    return medicineSet.toList()..sort();
  }

  /// Get unique locations
  List<String> getAllLocations() {
    final locationSet = <String>{};
    for (var shop in shops) {
      locationSet.add(shop.location);
    }
    return locationSet.toList()..sort();
  }

  /// Find shops with a specific medicine in a given location
  List<Shop> getShopsInLocationWithMedicine(
      String location, String medicineName) {
    return shops
        .where((shop) =>
            shop.location.toLowerCase() == location.toLowerCase() &&
            shop.medicines.any((medicine) =>
                medicine.name.toLowerCase() == medicineName.toLowerCase()))
        .toList();
  }

  /// Get shortage report for a medicine in a location
  Map<String, dynamic> getShortageReport(String medicineName,
      {String? location}) {
    List<Shop> shopsList = shops;
    final searchQuery = medicineName.toLowerCase();
    
    if (location != null) {
      shopsList = shops
          .where((shop) =>
              shop.location.toLowerCase() == location.toLowerCase())
          .toList();
    }

    final matchingShops = shopsList
        .where((shop) => shop.medicines.any((medicine) =>
            medicine.name.toLowerCase().contains(searchQuery)))
        .toList();

    final available = matchingShops
        .where((shop) => shop.medicines.firstWhere(
                (medicine) =>
                    medicine.name.toLowerCase().contains(searchQuery),
                orElse: () => Medicine(
                    name: 'N/A', available: false, price: 0)) // fallback
            .available)
        .toList();

    final unavailable = matchingShops
        .where((shop) => !shop.medicines.firstWhere(
                (medicine) =>
                    medicine.name.toLowerCase().contains(searchQuery),
                orElse: () => Medicine(
                    name: 'N/A', available: true, price: 0)) // fallback
            .available)
        .toList();

    return {
      'medicineName': medicineName,
      'location': location ?? 'All Locations',
      'totalShops': matchingShops.length,
      'availableCount': available.length,
      'unavailableCount': unavailable.length,
      'availableInShops': available.map((s) => s.name).toList(),
      'unavailableInShops': unavailable.map((s) => s.name).toList(),
    };
  }
}