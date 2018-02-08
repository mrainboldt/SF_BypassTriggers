public with sharing class Account_TriggerHandler  extends TriggerFactoryHandler{
	public static Boolean runWhenRunningTest = true;
	public static Boolean bypassTrigger = false;
	public static Boolean runTrigger()
	{
		return (!bypassTrigger && !Test.isRunningTest())
				|| (!bypassTrigger && (runWhenRunningTest && Test.isRunningTest()));
	}

	//Methods
	override public void OnBeforeInsert(List<SObject> newMappings){
		if(Test.isRunningTest()){
			newMappings = changeName(newMappings);
		}
	}

	private static List<Account> changeName(List<Account> newMappings){
		for(Account a: newMappings){
			a.Name = a.Name + 'trigger';
		}

		return newMappings;
	}
}