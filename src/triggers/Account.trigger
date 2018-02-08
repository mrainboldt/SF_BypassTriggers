trigger Account on Account (
	before insert, 
	before update, 
	before delete, 
	after insert, 
	after update, 
	after delete, 
	after undelete) {

	if(Account_TriggerHandler.runTrigger())
	{
		TriggerFactory.createHandler();
	}
}