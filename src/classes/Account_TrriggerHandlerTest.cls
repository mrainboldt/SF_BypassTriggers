@isTest
private class Account_TrriggerHandlerTest {
	
	@isTest static void test_Insert_TriggerRuns() {
		// Arrange
		Account account = new Account();
		account.Name = 'Test';

		//Act
		Test.startTest();
		insert account;
		Test.stopTest();

		Account result = [SELECT Id, Name FROM Account LIMIT 1];

		//Assert
		System.assert(result.Name.contains('trigger'));
	}
	
	@isTest static void test_Insert_Handler_RunningTest_False() {
		// Arrange
		Account account = new Account();
		account.Name = 'Test';

		//Act
		Test.startTest();
		Account_TriggerHandler.runWhenRunningTest = false;
		insert account;
		Test.stopTest();

		Account result = [SELECT Id, Name FROM Account LIMIT 1];

		//Assert
		System.assert(!result.Name.contains('trigger'));
	}

	
	@isTest static void test_Insert_Handler_bypassTrigger_True() {
		// Arrange
		Account account = new Account();
		account.Name = 'Test';

		//Act
		Test.startTest();
		Account_TriggerHandler.bypassTrigger = true;
		insert account;
		Test.stopTest();

		Account result = [SELECT Id, Name FROM Account LIMIT 1];

		//Assert
		System.assert(!result.Name.contains('trigger'));
	}

	
	@isTest static void test_Insert_Bypass_All_True() {
		// Arrange
		Bypass_Trigger__c bypass = new Bypass_Trigger__c();
		bypass.SetupOwnerId = UserInfo.getUserId();
		bypass.All__c = true;
		insert bypass;

		Account account = new Account();
		account.Name = 'Test';

		//Act
		Test.startTest();
		insert account;
		Test.stopTest();

		Account result = [SELECT Id, Name FROM Account LIMIT 1];

		//Assert
		System.assert(!result.Name.contains('trigger'));
	}

	
	@isTest static void test_Insert_Bypass_Account_True() {
		// Arrange
		Bypass_Trigger__c bypass = new Bypass_Trigger__c();
		bypass.SetupOwnerId = UserInfo.getUserId();
		bypass.Account__c = true;
		insert bypass;

		Account account = new Account();
		account.Name = 'Test';

		//Act
		Test.startTest();
		insert account;
		Test.stopTest();

		Account result = [SELECT Id, Name FROM Account LIMIT 1];

		//Assert
		System.assert(!result.Name.contains('trigger'));
	}

	
	@isTest static void test_Insert_Bypass_Other() {
		// Arrange
		Bypass_Trigger__c bypass = new Bypass_Trigger__c();
		bypass.SetupOwnerId = UserInfo.getUserId();
		bypass.Other__c = 'Account;';
		insert bypass;

		Account account = new Account();
		account.Name = 'Test';

		//Act
		Test.startTest();
		insert account;
		Test.stopTest();

		Account result = [SELECT Id, Name FROM Account LIMIT 1];

		//Assert
		System.assert(!result.Name.contains('trigger'));
	}
	
}