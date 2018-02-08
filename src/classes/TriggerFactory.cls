/**
* @date 2018
*
* @group Triggers
*
* @description Used to instantiate and execute Trigger Handlers associated with sObjects. 
*/
public with sharing class TriggerFactory {

    public static void createHandler()
    {  
        // Get a handler appropriate to the object being processed  
        String sObjectName = ObjectName(Trigger.old, Trigger.new);
        TriggerFactoryHandler handler = getHandler(Trigger.old, Trigger.new, sObjectName); 
        if(handler.executeTrigger())
    {
            execute(handler);  
        }
    }

    
    //private static method to control the execution of the handler  
    private static void execute(TriggerFactoryHandler handler)
    {
        if(Trigger.isBefore)
		{
            // Call the bulk before to handle any caching of data and enable bulkification 
            handler.BulkBefore();
            
            // Call the beforeDelete method of the handler
            if(Trigger.isDelete)
    		{
                handler.OnBeforeDelete(Trigger.old, Trigger.oldMap);                
            }
            
            // Call the beforeInsert method of the handler
            if(Trigger.isInsert)
    		{               
                handler.OnBeforeInsert(Trigger.new);     
                          
            }
            
            //Call the beforeUpdate method of the handler
            if(Trigger.isUpdate)
    		{               
                handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            }
        }else if(Trigger.isAfter)
    	{
            // Call the bulk before to handle any caching of data and enable bulkification 
            handler.BulkAfter();
            
            // Call the afterDelete method of the handler
            if(Trigger.isDelete)
    		{
                handler.OnAfterDelete(Trigger.old, Trigger.oldMap);             
            }
            
            if(Trigger.isUnDelete)
    		{
                handler.OnUnDelete(Trigger.new);            
            }
            
            // Call the afterinsert method of the Handler
            if(Trigger.isInsert)
    		{               
                handler.OnAfterInsert(Trigger.new, Trigger.newMap); 
                if(handler.asyncAvailable())
    			{
                    TriggerFactoryHandler.OnAfterInsertAsync(handler.asyncIds, handler.sObjectName);
                }
            }
            
            // call the afterUpdate method of the handler
            if(Trigger.isUpdate)
    		{
                handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                if(handler.asyncAvailable())
    			{
                    TriggerFactoryHandler.OnAfterUpdateAsync(handler.asyncIds, handler.sObjectName);
                }       
            }
            
            handler.BulkAfterCleanup();
        }
        
        //call the cleaup method
        handler.cleanUp();
        if(Trigger.isAfter)
    	{
            handler.firstrun = false;
            if(Trigger.isInsert)
            {
            	handler.insertHasRun = true;
            }else if(Trigger.isUpdate)
            {
            	handler.updateHasRun = true;
            }
        }
    }
    
    @testVisible
    // For this to work on any trigger you create your handler class must be the object name
    // underscores removed with _TriggerHandler appended on the end of the name
    // Example:
    // Object Name: Asset
    // Handler class name: Asset_TriggerHandler
    private static TriggerFactoryHandler getHandler(List<sObject> oldList, List<sObject> newList, String sObjectName)
    { 
        String apiName = sObjectName; 
        sObjectName = sObjectName.replaceAll('__c', '');
        sObjectName = sObjectName.replaceAll('_', '');
        TriggerFactoryHandler handler = null;
        Type t = Type.forName(sObjectName + '_TriggerHandler');
        if(t==null)
    	{
            //create instance of the default class
            t = Type.forName('TriggerFactoryHandler');
        }
        handler = (TriggerFactoryHandler) t.newInstance();
        handler.sObjectName = apiName;
        handler.setDisableTrigger(apiName);
        return handler;  
    } 

    private static String ObjectName(List <sObject >newObjectList, List <sObject >oldObjectList) {
        String objectName = '';
        if (newObjectList != null &&newObjectList [0]!= null) {
            objectName = newObjectList [0].getSObjectType().getDescribe().getName();
        }
        else if (oldObjectList != null &&oldObjectList [0]!= null)
    	{
            objectName = oldObjectList [0].getSObjectType().getDescribe().getName();
        }

        return objectName;
    }  
}