import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Array "mo:base/Array";  
import Nat "mo:base/Nat";

actor ATM {
  private type Account = {
    id: Nat;
    name: Text; 
    balance: Nat;
    transactionHistory: [Text];
  };

  var accounts = HashMap.HashMap<Nat, Account>(1, Nat.equal, Hash.hash);
  var currentId: Nat = 0;

  
  public func createAccount(name: Text): async Account {
    currentId += 1;
    let newAccount: Account = {
      id = currentId;
      name = name; 
      balance = 0;
      transactionHistory = [];
    };
    accounts.put(currentId, newAccount);
    return newAccount;
  };

  
  public func deposit(id: Nat, amount: Nat): async ?Account {
    switch (accounts.get(id)) {
      case (?account) {
        let updatedAccount = {
          id = account.id;
          name = account.name;
          balance = account.balance + amount;
          transactionHistory = Array.append(account.transactionHistory, ["Deposited " # Nat.toText(amount)]);
        };
        accounts.put(id, updatedAccount);
        return ?updatedAccount;
      };
      case null return null; 
    }
  };

  
  public func withdraw(id: Nat, amount: Nat): async ?Nat {
    switch (accounts.get(id)) {
      case (?account) {
        if (account.balance < amount) {
          return null; 
        };
        var updatedAccount = {
          id = account.id;
          name = account.name;
          balance = account.balance - amount;
          transactionHistory = Array.append(account.transactionHistory, ["Withdrew " # Nat.toText(amount)]);
        };
        accounts.put(id, updatedAccount);
        return ?updatedAccount.balance;
      };
      case null return null; 
    }
  };

  
  public query func getBalance(id: Nat): async ?Nat {
    switch (accounts.get(id)) {
      case (?account) return ?account.balance;
      case null return null; 
    }
  };

  
  public query func getTransactionHistory(id: Nat): async ?[Text] {
    switch (accounts.get(id)) {
      case (?account) return ?account.transactionHistory;
      case null return null; 
    }
  };

  
  public query func findAccount(id: Nat): async ?Account {
    return accounts.get(id);
  };
};
