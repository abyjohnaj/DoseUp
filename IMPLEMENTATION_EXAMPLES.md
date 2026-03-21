# Implementation Examples - DoseUp Medicine Dataset

## Example 1: Display Medicine Autocomplete

```dart
import 'services/price_comparison_service.dart';

class MedicineSearch extends StatefulWidget {
  @override
  State<MedicineSearch> createState() => _MedicineSearchState();
}

class _MedicineSearchState extends State<MedicineSearch> {
  final PriceComparisonService _priceService = PriceComparisonService();
  List<String> _medicineList = [];
  List<String> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _medicineList = _priceService.getAllMedicineNames();
    _filteredList = _medicineList;
  }

  void _filterMedicines(String query) {
    setState(() {
      _filteredList = _medicineList
          .where((medicine) =>
              medicine.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: _filterMedicines,
          decoration: InputDecoration(hintText: 'Search medicines...'),
        ),
        ListView.builder(
          itemCount: _filteredList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_filteredList[index]),
              onTap: () {
                _searchController.text = _filteredList[index];
              },
            );
          },
        ),
      ],
    );
  }
}
```

## Example 2: Display Price Comparison Results

```dart
import 'services/price_comparison_service.dart';
import 'package:intl/intl.dart';

class PriceComparisonWidget extends StatelessWidget {
  final String medicineName;
  final PriceComparisonService _priceService = PriceComparisonService();

  PriceComparisonWidget({required this.medicineName});

  @override
  Widget build(BuildContext context) {
    final result = _priceService.comparePrices(medicineName);

    if (!result.found) {
      return Center(child: Text('No prices found for $medicineName'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              _buildStatCard(
                title: 'Cheapest',
                value: '₹${result.cheapest?.price}',
                shop: result.cheapest?.shopName ?? '',
                color: Colors.green,
              ),
              SizedBox(width: 16),
              _buildStatCard(
                title: 'Most Expensive',
                value: '₹${result.costliest?.price}',
                shop: result.costliest?.shopName ?? '',
                color: Colors.red,
              ),
              SizedBox(width: 16),
              _buildStatCard(
                title: 'Average',
                value: '₹${result.averagePrice?.toStringAsFixed(2)}',
                shop: '${result.allPrices.length} shops',
                color: Colors.blue,
              ),
            ],
          ),
          SizedBox(height: 24),
          // Price List Table
          Text('All Prices:', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12),
          DataTable(
            columns: [
              DataColumn(label: Text('Shop Name')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Difference from Cheapest')),
            ],
            rows: result.allPrices.map((record) {
              final diff = record.price - (result.cheapest?.price ?? 0);
              return DataRow(cells: [
                DataCell(Text(record.shopName)),
                DataCell(Text('₹${record.price}')),
                DataCell(Text(
                  diff == 0 ? 'Cheapest' : '+₹$diff',
                  style: TextStyle(
                    color: diff == 0 ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String shop,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(shop, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Example 3: Shortage Report Widget

```dart
import 'services/shop_data_service.dart';

class ShortageReportWidget extends StatefulWidget {
  @override
  State<ShortageReportWidget> createState() => _ShortageReportWidgetState();
}

class _ShortageReportWidgetState extends State<ShortageReportWidget> {
  final ShopDataService _shopService = ShopDataService();
  String? _selectedMedicine;
  String? _selectedLocation;
  Map<String, dynamic>? _report;

  List<String> _medicines = [];
  List<String> _locations = [];

  @override
  void initState() {
    super.initState();
    _medicines = _shopService.getAllMedicineNames();
    _locations = _shopService.getAllLocations();
  }

  void _generateReport() {
    if (_selectedMedicine != null && _selectedLocation != null) {
      final report = _shopService.getShortageReport(
        _selectedMedicine!,
        location: _selectedLocation,
      );
      setState(() {
        _report = report;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text('Select Medicine'),
                value: _selectedMedicine,
                items: _medicines.map((String medicine) {
                  return DropdownMenuItem<String>(
                    value: medicine,
                    child: Text(medicine),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedMedicine = value;
                  });
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text('Select Location'),
                value: _selectedLocation,
                items: _locations.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: _generateReport,
              child: Text('Generate Report'),
            ),
          ],
        ),
        SizedBox(height: 24),
        if (_report != null)
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shortage Report: ${_report!['medicineName']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Location: ${_report!['location']}'),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildReportStat(
                        'Total Shops',
                        _report!['totalShops'].toString(),
                        Colors.blue,
                      ),
                      SizedBox(width: 16),
                      _buildReportStat(
                        'Available In',
                        _report!['availableCount'].toString(),
                        Colors.green,
                      ),
                      SizedBox(width: 16),
                      _buildReportStat(
                        'Unavailable In',
                        _report!['unavailableCount'].toString(),
                        Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if ((_report!['availableInShops'] as List).isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available In:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...((_report!['availableInShops'] as List<dynamic>)
                            .map((shop) => Text('• $shop'))),
                      ],
                    ),
                  if ((_report!['unavailableInShops'] as List).isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Text('Unavailable In:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ...((_report!['unavailableInShops'] as List<dynamic>)
                            .map((shop) => Text('• $shop'))),
                      ],
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReportStat(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value,
              style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
```

## Example 4: Location-Based Price Comparison

```dart
import 'services/price_comparison_service.dart';

class LocationBasedPricing extends StatefulWidget {
  @override
  State<LocationBasedPricing> createState() => _LocationBasedPricingState();
}

class _LocationBasedPricingState extends State<LocationBasedPricing> {
  final PriceComparisonService _priceService = PriceComparisonService();
  String _selectedMedicine = '';
  String _selectedLocation = '';

  void _searchByLocation() {
    if (_selectedMedicine.isEmpty || _selectedLocation.isEmpty) return;

    final result = _priceService.comparePricesByLocation(
      _selectedMedicine,
      _selectedLocation,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Prices in $_selectedLocation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (result.found)
              ...result.allPrices.map((record) => ListTile(
                    title: Text(record.shopName),
                    trailing: Text('₹${record.price}'),
                  ))
            else
              Text('No prices found in this location'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) => setState(() => _selectedMedicine = value),
          decoration: InputDecoration(
            hintText: 'Enter medicine name',
            label: Text('Medicine'),
          ),
        ),
        TextField(
          onChanged: (value) => setState(() => _selectedLocation = value),
          decoration: InputDecoration(
            hintText: 'Enter location',
            label: Text('Location'),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _searchByLocation,
          child: Text('Search Prices by Location'),
        ),
      ],
    );
  }
}
```

## Example 5: All Shops with Medicine Display

```dart
import 'services/shop_data_service.dart';

class AllShopsDisplay extends StatelessWidget {
  final ShopDataService _shopService = ShopDataService();

  @override
  Widget build(BuildContext context) {
    final shops = _shopService.getAllShops();

    return ListView.builder(
      itemCount: shops.length,
      itemBuilder: (context, index) {
        final shop = shops[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text(shop.name),
            subtitle: Text(shop.location),
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('Medicine')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Available')),
                ],
                rows: shop.medicines.map((medicine) {
                  return DataRow(cells: [
                    DataCell(Text(medicine.name)),
                    DataCell(Text('₹${medicine.price}')),
                    DataCell(
                      Icon(
                        medicine.available ? Icons.check : Icons.close,
                        color: medicine.available ? Colors.green : Colors.red,
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## Testing the Integration

```dart
void main() {
  // Test ShopDataService
  final shopService = ShopDataService();
  print('Total shops: ${shopService.getAllShops().length}'); // Should print 35
  print('Medicines: ${shopService.getAllMedicineNames().length}'); // Should print 7
  print('Locations: ${shopService.getAllLocations().length}'); // Should print 14

  // Test PriceComparisonService
  final priceService = PriceComparisonService();
  final result = priceService.comparePrices('Paracetamol 500mg');
  print('Found prices: ${result.found}'); // Should print true
  print('Cheapest: ₹${result.cheapest?.price}'); // Should print a price
  print('Average: ₹${result.averagePrice}'); // Should print an average
}
```
