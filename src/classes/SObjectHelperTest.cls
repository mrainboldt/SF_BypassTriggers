@isTest
private class SObjectHelperTest {
	
	@isTest static void test_hasSObjectField_False() {
		Boolean result = SObjectHelper.hasSObjectField('Lead__c', 'Bypass_Trigger__c');
		System.assertEquals(false, result);
	}
	
}