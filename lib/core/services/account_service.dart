import '../models/account.dart';

class AccountService {
  Future<List<Account>> getAccounts() async {
    // Mock data for now
    return [
      Account(
        id: '1',
        name: 'Main Bank',
        type: 'Checking',
        balance: 12500.50,
        monthlyIncome: 4500.00,
        monthlyExpense: 3200.00,
        icon: 'bank',
      ),
      Account(
        id: '2',
        name: 'Savings',
        type: 'Savings',
        balance: 45000.00,
        monthlyIncome: 500.00,
        monthlyExpense: 0.00,
        icon: 'savings',
      ),
    ];
  }
}
