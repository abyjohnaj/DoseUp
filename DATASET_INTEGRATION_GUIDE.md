# DoseUp Medicine Dataset Integration Guide

## Overview
The DoseUp app now integrates a comprehensive dataset of 35 medical shops across Kerala, India with detailed information about medicine availability and pricing.

## Data Structure

### Medicine Data
- **Medicine Class**: Contains medicine details
  - `name`: Medicine name (e.g., "Paracetamol 500mg")
  - `available`: Boolean indicating availability
  - `price`: Double representing the price

### Shop Data
- **Shop Class**: Contains shop details
  - `shopId`: Unique shop identifier (MS001-MS035)
  - `name`: Shop name
  - `location`: Kerala location (14 unique cities)
  - `medicines`: List of Medicine objects

### Dataset Coverage
**35 Shops** across these Kerala locations:
- Thiruvananthapuram (Trivandrum)
- Kochi
- Kozhikode
- Thrissur
- Kollam
- Kottayam
- Alappuzha
- Palakkad
- Kannur
- Malappuram
- Kasaragod
- Pathanamthitta
- Idukki
- Ernakulam

**7 Unique Medicines**:
1. Paracetamol (500mg & 650mg)
2. Insulin
3. Amoxicillin 250mg
4. Azithromycin 500mg
5. Metformin 500mg
6. Cefixime 200mg

**Price Range**: ₹23 - ₹470 depending on medicine type and shop

## Services

### 1. ShopDataService (`lib/services/shop_data_service.dart`)
Singleton service managing all shop and medicine data.

**Key Methods**:
```dart
getAllShops()                                    // Returns List<Shop>
getAllMedicineNames()                           // Returns List<String>
getAllLocations()                               // Returns List<String>
getShopsInLocationWithMedicine(location, name)  // Returns List<Shop>
getShortageReport(medicineName, {location})    // Returns Map<String, dynamic>
```

**Example Usage**:
```dart
final shopService = ShopDataService();
final shops = shopService.getAllShops();
final locations = shopService.getAllLocations();
final shortageInfo = shopService.getShortageReport('Insulin', location: 'Kochi');
```

### 2. PriceComparisonService (`lib/services/price_comparison_service.dart`)
Enhanced service for price comparison across shops.

**Key Methods**:
```dart
comparePrices(medicineName)                     // Returns PriceComparisonResult
comparePricesByLocation(medicineName, location) // Returns PriceComparisonResult
getAllMedicineNames()                           // Returns List<String>
```

**Returns PriceComparisonResult** with:
- `found`: Boolean
- `message`: Description string
- `allPrices`: List<PriceRecord>
- `cheapest`: PriceRecord
- `costliest`: PriceRecord
- `averagePrice`: Double

**Example Usage**:
```dart
final priceService = PriceComparisonService();
final result = priceService.comparePrices('Paracetamol 500mg');
final locationResult = priceService.comparePricesByLocation('Insulin', 'Kochi');

if (result.found) {
  print('Cheapest: ${result.cheapest?.shopName} - ₹${result.cheapest?.price}');
  print('Most Expensive: ${result.costliest?.shopName} - ₹${result.costliest?.price}');
  print('Average Price: ₹${result.averagePrice}');
}
```

## Updated Pages

### ComparePage (`lib/compare_page.dart`)
- Searches for medicine prices across all shops
- Displays cheapest, costliest, and average prices
- Shows all available prices for comparison

### ShortageReportPage (`lib/shortage_report_page.dart`)
- Now uses Kerala locations from actual dataset
- Reports real shortage information
- Shows availability count in different shops
- Provides detailed shortage analysis

## How to Use in Your Code

### For Price Comparison UI
```dart
final priceService = PriceComparisonService();
final result = priceService.comparePrices(_medicineController.text);

if (result.found) {
  // Display all prices
  for (var record in result.allPrices) {
    print('${record.shopName}: ₹${record.price}');
  }
}
```

### For Shortage Reports
```dart
final shopService = ShopDataService();
final report = shopService.getShortageReport('Insulin', location: 'Kochi');

print('Available in ${report["availableCount"]} shops');
print('Unavailable in ${report["unavailableCount"]} shops');
```

### For Medicine Autocomplete
```dart
final priceService = PriceComparisonService();
final medicines = priceService.getAllMedicineNames();
// Use for TypeAhead/Autocomplete widget
```

### For Location Dropdown
```dart
final shopService = ShopDataService();
final locations = shopService.getAllLocations();
// Use for DropdownButton items
```

## Data Features

### Availability Tracking
- Each medicine in each shop has an `available` flag
- Shortage reports track which shops have products in stock
- Supports location-specific availability queries

### Price Comparison
- Compare prices across all shops for the same medicine
- Filter by location for local price comparison
- Shows cheapest, costliest, and average prices
- Multiple pharmacies per location for fair competition analysis

### Realistic Data
- Prices vary by shop and location
- Stock varies realistically (not all items in all shops)
- Medical-grade medicines with proper dosage specifications
- Multiple formulations (e.g., Paracetamol 500mg vs 650mg)

## Integration Notes

1. **No Backend Required**: All data is local in the app (hardcoded for now)
2. **Singleton Pattern**: ShopDataService uses singleton for efficient data access
3. **Memory Efficient**: Data is initialized once on first access
4. **String IDs**: Shop IDs are strings (MS001-MS035) for extensibility
5. **Case Insensitive**: Medicine name searches ignore case

## Future Enhancements

Potential improvements:
- Connect to backend API for real-time data
- Add database for persistent storage
- Implement medicine ratings/reviews
- Add user geolocation for automatic location selection
- Implement wish list/price alerts
- Add shop ratings and user reviews
