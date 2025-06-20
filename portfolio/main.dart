import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(StockPortfolioApp());
}

class StockPortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        cardColor: const Color(0xFF2D2D2D),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: PortfolioHomePage(),
    );
  }
}

enum TransactionType { buy, sell, dividend }

class Stock {
  final String symbol;
  final String name;
  final double currentPrice;
  final String sector;

  Stock({
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.sector,
  });
}

class StockHolding {
  final String symbol;
  final String name;
  final int quantity;
  final double purchasePrice;
  final double currentPrice;
  final String sector;

  StockHolding({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    required this.currentPrice,
    required this.sector,
  });

  double get totalValue => quantity * currentPrice;
  double get totalCost => quantity * purchasePrice;
  double get gainLoss => totalValue - totalCost;
  double get gainLossPercentage => (gainLoss / totalCost) * 100;
}

class Transaction {
  final String id;
  final String symbol;
  final TransactionType type;
  final int quantity;
  final double price;
  final DateTime date;
  final double? dividendAmount;

  Transaction({
    required this.id,
    required this.symbol,
    required this.type,
    required this.quantity,
    required this.price,
    required this.date,
    this.dividendAmount,
  });

  double get totalAmount {
    switch (type) {
      case TransactionType.buy:
        return quantity * price;
      case TransactionType.sell:
        return quantity * price;
      case TransactionType.dividend:
        return dividendAmount ?? 0;
    }
  }
}

class PortfolioData {
  final List<StockHolding> holdings;
  final List<Stock> watchlist;
  final List<Transaction> transactions;
  final double cashBalance;
  final String userName;

  PortfolioData({
    required this.holdings,
    required this.watchlist,
    required this.transactions,
    required this.cashBalance,
    required this.userName,
  });

  double get totalPortfolioValue => holdings.fold(0, (sum, holding) => sum + holding.totalValue);
  double get totalCost => holdings.fold(0, (sum, holding) => sum + holding.totalCost);
  double get totalGainLoss => totalPortfolioValue - totalCost;
  double get totalGainLossPercentage => totalCost > 0 ? (totalGainLoss / totalCost) * 100 : 0;

  Map<String, double> get sectorAllocation {
    final Map<String, double> allocation = {};
    for (final holding in holdings) {
      allocation[holding.sector] = (allocation[holding.sector] ?? 0) + holding.totalValue;
    }
    return allocation;
  }
}

class PortfolioHomePage extends StatefulWidget {
  @override
  _PortfolioHomePageState createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  late PortfolioData portfolio;

  @override
  void initState() {
    super.initState();
    portfolio = _generateInitialData();
  }

  PortfolioData _generateInitialData() {
    final random = Random();
    final holdings = [
      StockHolding(
        symbol: 'AAPL',
        name: 'Apple Inc.',
        quantity: 10,
        purchasePrice: 150.0 + random.nextDouble() * 20,
        currentPrice: 175.0 + random.nextDouble() * 20,
        sector: 'Technology',
      ),
      StockHolding(
        symbol: 'MSFT',
        name: 'Microsoft Corp.',
        quantity: 8,
        purchasePrice: 280.0 + random.nextDouble() * 30,
        currentPrice: 320.0 + random.nextDouble() * 40,
        sector: 'Technology',
      ),
      StockHolding(
        symbol: 'TSLA',
        name: 'Tesla Inc.',
        quantity: 5,
        purchasePrice: 200.0 + random.nextDouble() * 50,
        currentPrice: 240.0 + random.nextDouble() * 60,
        sector: 'Automotive',
      ),
      StockHolding(
        symbol: 'AMZN',
        name: 'Amazon.com Inc.',
        quantity: 3,
        purchasePrice: 3000.0 + random.nextDouble() * 200,
        currentPrice: 3200.0 + random.nextDouble() * 300,
        sector: 'Consumer',
      ),
    ];

    final watchlist = [
      Stock(symbol: 'NVDA', name: 'NVIDIA Corp.', currentPrice: 450.0 + random.nextDouble() * 50, sector: 'Technology'),
      Stock(symbol: 'META', name: 'Meta Platforms Inc.', currentPrice: 300.0 + random.nextDouble() * 40, sector: 'Technology'),
      Stock(symbol: 'NFLX', name: 'Netflix Inc.', currentPrice: 400.0 + random.nextDouble() * 50, sector: 'Entertainment'),
    ];

    final transactions = [
      Transaction(
        id: '1',
        symbol: 'AAPL',
        type: TransactionType.buy,
        quantity: 10,
        price: 160.0,
        date: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Transaction(
        id: '2',
        symbol: 'MSFT',
        type: TransactionType.buy,
        quantity: 8,
        price: 290.0,
        date: DateTime.now().subtract(const Duration(days: 25)),
      ),
    ];

    return PortfolioData(
      holdings: holdings,
      watchlist: watchlist,
      transactions: transactions,
      cashBalance: 15000.0,
      userName: 'Ethan Carter',
    );
  }

  void buyStock(String symbol, int quantity, double price) {
    final totalCost = quantity * price;
    if (portfolio.cashBalance >= totalCost) {
      final existingHoldingIndex = portfolio.holdings.indexWhere((h) => h.symbol == symbol);
      List<StockHolding> updatedHoldings = [...portfolio.holdings];
      if (existingHoldingIndex >= 0) {
        final existingHolding = portfolio.holdings[existingHoldingIndex];
        final newQuantity = existingHolding.quantity + quantity;
        final newAvgPrice = ((existingHolding.quantity * existingHolding.purchasePrice) + totalCost) / newQuantity;
        updatedHoldings[existingHoldingIndex] = StockHolding(
          symbol: symbol,
          name: existingHolding.name,
          quantity: newQuantity,
          purchasePrice: newAvgPrice,
          currentPrice: existingHolding.currentPrice,
          sector: existingHolding.sector,
        );
      } else {
        updatedHoldings.add(StockHolding(
          symbol: symbol,
          name: symbol,
          quantity: quantity,
          purchasePrice: price,
          currentPrice: price,
          sector: 'Unknown',
        ));
      }
      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        symbol: symbol,
        type: TransactionType.buy,
        quantity: quantity,
        price: price,
        date: DateTime.now(),
      );
      setState(() {
        portfolio = PortfolioData(
          holdings: updatedHoldings,
          watchlist: portfolio.watchlist,
          transactions: [newTransaction, ...portfolio.transactions],
          cashBalance: portfolio.cashBalance - totalCost,
          userName: portfolio.userName,
        );
      });
    }
  }

  void sellStock(String symbol, int quantity, double price) {
    final holdingIndex = portfolio.holdings.indexWhere((h) => h.symbol == symbol);
    if (holdingIndex >= 0 && portfolio.holdings[holdingIndex].quantity >= quantity) {
      final holding = portfolio.holdings[holdingIndex];
      final updatedHoldings = [...portfolio.holdings];
      if (holding.quantity == quantity) {
        updatedHoldings.removeAt(holdingIndex);
      } else {
        updatedHoldings[holdingIndex] = StockHolding(
          symbol: holding.symbol,
          name: holding.name,
          quantity: holding.quantity - quantity,
          purchasePrice: holding.purchasePrice,
          currentPrice: holding.currentPrice,
          sector: holding.sector,
        );
      }
      final totalSale = quantity * price;
      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        symbol: symbol,
        type: TransactionType.sell,
        quantity: quantity,
        price: price,
        date: DateTime.now(),
      );
      setState(() {
        portfolio = PortfolioData(
          holdings: updatedHoldings,
          watchlist: portfolio.watchlist,
          transactions: [newTransaction, ...portfolio.transactions],
          cashBalance: portfolio.cashBalance + totalSale,
          userName: portfolio.userName,
        );
      });
    }
  }

  void addToWatchlist(String symbol, String name, double price, String sector) {
    final newStock = Stock(symbol: symbol, name: name, currentPrice: price, sector: sector);
    setState(() {
      portfolio = PortfolioData(
        holdings: portfolio.holdings,
        watchlist: [...portfolio.watchlist, newStock],
        transactions: portfolio.transactions,
        cashBalance: portfolio.cashBalance,
        userName: portfolio.userName,
      );
    });
  }

  void removeFromWatchlist(String symbol) {
    setState(() {
      portfolio = PortfolioData(
        holdings: portfolio.holdings,
        watchlist: portfolio.watchlist.where((s) => s.symbol != symbol).toList(),
        transactions: portfolio.transactions,
        cashBalance: portfolio.cashBalance,
        userName: portfolio.userName,
      );
    });
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.trending_up, color: Colors.green),
              title: Text('AAPL up 2.5%', style: TextStyle(color: Colors.white)),
              subtitle: Text('2 hours ago', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: Icon(Icons.attach_money, color: Colors.blue),
              title: Text('Dividend received', style: TextStyle(color: Colors.white)),
              subtitle: Text('1 day ago', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showAddToWatchlistDialog(BuildContext context) {
    final symbolController = TextEditingController();
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final sectorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Add to Watchlist', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: symbolController,
              decoration: const InputDecoration(
                labelText: 'Symbol',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Current Price',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: sectorController,
              decoration: const InputDecoration(
                labelText: 'Sector',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              final symbol = symbolController.text.trim().toUpperCase();
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text);
              final sector = sectorController.text.trim();
              if (symbol.isNotEmpty && name.isNotEmpty && price != null && sector.isNotEmpty && price > 0) {
                addToWatchlist(symbol, name, price, sector);
                Navigator.pop(context);
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _showSellDialog(BuildContext context, StockHolding holding) {
    final quantityController = TextEditingController();
    final priceController = TextEditingController(text: holding.currentPrice.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Text('Sell ${holding.symbol}', style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available: ${holding.quantity} shares', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity to Sell',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price per Share',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text);
              final price = double.tryParse(priceController.text);
              if (quantity != null && price != null && quantity > 0 && price > 0 && quantity <= holding.quantity) {
                sellStock(holding.symbol, quantity, price);
                Navigator.pop(context);
              }
            },
            child: const Text('Sell', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => _showNotifications(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPortfolioSummary(portfolio),
            const SizedBox(height: 20),
            _buildHoldingsList(context, portfolio),
            const SizedBox(height: 20),
            _buildSectorAllocation(portfolio),
            const SizedBox(height: 20),
            _buildWatchlist(context, portfolio),
            const SizedBox(height: 20),
            _buildRecentTransactions(portfolio),
            const SizedBox(height: 20),
            _buildAccountSummary(portfolio),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioSummary(PortfolioData portfolio) {
    final isPositive = portfolio.totalGainLoss >= 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(portfolio.userName[0], style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 12),
                Text(portfolio.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Total Portfolio Value', style: TextStyle(fontSize: 14, color: Colors.white70)),
            Text('\$${portfolio.totalPortfolioValue.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Total: ', style: TextStyle(color: Colors.white70)),
                Text(
                  '${isPositive ? '+' : ''}\$${portfolio.totalGainLoss.toStringAsFixed(2)} (${portfolio.totalGainLossPercentage.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingsList(BuildContext context, PortfolioData portfolio) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Holdings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () => _showBuyDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...portfolio.holdings.map((holding) => _buildHoldingItem(context, holding)),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingItem(BuildContext context, StockHolding holding) {
    final isPositive = holding.gainLoss >= 0;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(holding.symbol[0], style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(holding.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${holding.quantity} shares', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${holding.totalValue.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${isPositive ? '+' : ''}\$${holding.gainLoss.toStringAsFixed(2)} (${holding.gainLossPercentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Buy More'),
                value: 'buy',
              ),
              const PopupMenuItem(
                child: Text('Sell'),
                value: 'sell',
              ),
            ],
            onSelected: (value) {
              if (value == 'buy') {
                _showBuyDialog(context, symbol: holding.symbol);
              } else if (value == 'sell') {
                _showSellDialog(context, holding);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectorAllocation(PortfolioData portfolio) {
    final allocation = portfolio.sectorAllocation;
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sector Allocation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...allocation.entries.map((entry) {
              final index = allocation.keys.toList().indexOf(entry.key);
              final total = allocation.values.fold(0.0, (sum, value) => sum + value);
              final percentage = (entry.value / total) * 100;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(entry.key)),
                    Text('${percentage.toStringAsFixed(1)}%'),
                    const SizedBox(width: 8),
                    Text('\$${entry.value.toStringAsFixed(2)}'),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchlist(BuildContext context, PortfolioData portfolio) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Watchlist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: () => _showAddToWatchlistDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...portfolio.watchlist.map((stock) => _buildWatchlistItem(context, stock)),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchlistItem(BuildContext context, Stock stock) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(stock.symbol[0], style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(stock.name, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Text('\$${stock.currentPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('Buy'), value: 'buy'),
              const PopupMenuItem(child: Text('Remove'), value: 'remove'),
            ],
            onSelected: (value) {
              if (value == 'buy') {
                _showBuyDialog(context, symbol: stock.symbol);
              } else if (value == 'remove') {
                removeFromWatchlist(stock.symbol);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(PortfolioData portfolio) {
    final recentTransactions = portfolio.transactions.take(5).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...recentTransactions.map((transaction) => _buildTransactionItem(transaction)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    Color color = Colors.white;
    IconData icon = Icons.swap_horiz;
    switch (transaction.type) {
      case TransactionType.buy:
        color = Colors.red;
        icon = Icons.add;
        break;
      case TransactionType.sell:
        color = Colors.green;
        icon = Icons.remove;
        break;
      case TransactionType.dividend:
        color = Colors.blue;
        icon = Icons.attach_money;
        break;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${transaction.type.toString().split('.').last.toUpperCase()} ${transaction.symbol}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${transaction.quantity} shares @ \$${transaction.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${transaction.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              Text('${transaction.date.day}/${transaction.date.month}/${transaction.date.year}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSummary(PortfolioData portfolio) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Available Cash'),
                Text('\$${portfolio.cashBalance.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Portfolio Value'),
                Text('\$${portfolio.totalPortfolioValue.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Account Value'),
                Text('\$${(portfolio.cashBalance + portfolio.totalPortfolioValue).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBuyDialog(BuildContext context, {String? symbol}) {
    final symbolController = TextEditingController(text: symbol ?? '');
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Buy Stock', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: symbolController,
              decoration: const InputDecoration(
                labelText: 'Symbol',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price per Share',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              final symbol = symbolController.text.trim().toUpperCase();
              final quantity = int.tryParse(quantityController.text);
              final price = double.tryParse(priceController.text);
              if (symbol.isNotEmpty && quantity != null && price != null && quantity > 0 && price > 0) {
                buyStock(symbol, quantity, price);
                Navigator.pop(context);
              }
            },
            child: const Text('Buy', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}