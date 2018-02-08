public with sharing class SObjectHelper {
	/**
    * @description check if an Sobject has a field
    * @param fieldName - the name of the field you want to see exists
    * @param objName - the api name of the object you are checking for the field
    */
    public static boolean hasSObjectField(String fieldName, String objName)
    {
        SObject so = Schema.getGlobalDescribe().get(objName).newSObject();
        return hasSObjectField(fieldName, so);
    }


    /**
    * @description check if an Sobject has a field
    * @param fieldName - the name of the field you want to see exists
    * @param objName - the object you are checking for the field
    */
    public static boolean hasSObjectField(String fieldName, SObject so)
    {
        fieldName = fieldName.toLowerCase();
        return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName);
    }
}