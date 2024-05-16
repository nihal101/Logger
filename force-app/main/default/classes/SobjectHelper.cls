public class SobjectHelper {
    
    public static Map<String, sObject> getSobjectDetail(Set<String> recordIds, Set<String> objectApiNames) {
        Map<String, sObject> idToSobjectDetail = new Map<String, sObject>();
        
        if(recordIds.isEmpty() || objectApiNames.isEmpty()) {
            return idToSobjectDetail;
        }
        
        for(String objectApiName : objectApiNames) {
            idToSobjectDetail.putAll(getSobjectDetail(recordIds, objectApiName));
        }
        return idToSobjectDetail;
    }
    
    public static List<Log_Detail__c> getLogDetails(Set<String> transactionIds) {
        return [SELECT Id,
                Transaction_Id__c,
                Apex_Log_Id__c
                FROM Log_Detail__c
                WHERE Transaction_Id__c IN : transactionIds];
    }
    
    public static Map<String, sObject> getMap(List<sObject> records, String fieldApiName) {
        Map<String, sObject> idToSobjectDetail = new Map<String, sObject>();
        
        for(sObject obj : records) {
            idToSobjectDetail.put(String.valueOf(obj.get(fieldApiName)), obj);
        }
        return idToSobjectDetail;
    }
    
    public static Boolean isFileSavingEnabled() {
        List<Logger_Configuration__mdt> configurationDetails = [SELECT Id,
                                                                Don_t_Save_Log_File__c
                                                                FROM Logger_Configuration__mdt LIMIT 1];
        return !(configurationDetails.isEmpty() ? false : configurationDetails[0].Don_t_Save_Log_File__c);
    }

    /* This method will be called from ToolingApiController & LogEntryHandlerJob to get the All ApexLog Detail from transactionId */
    public static List<ApexLog> getAllApexLog(String transactionId) {
        List<ApexLog> apexLogs = new List<ApexLog>();
        if(String.isBlank(transactionId)) {
            return apexLogs;
        }
        // Run only for test class.
        if(Test.isRunningTest()) {
            return [SELECT Id, 
                    Request, 
                    Operation, 
                    Application, 
                    Status, 
                    DurationMilliseconds, 
                    StartTime, 
                    RequestIdentifier, 
                    LogUserId,
                    LogLength
                    FROM ApexLog
                    ORDER By LastModifiedDate LIMIT 1];
        }
        return [SELECT Id, 
                Request, 
                Operation, 
                Application, 
                Status, 
                DurationMilliseconds, 
                StartTime, 
                RequestIdentifier, 
                LogUserId,
                LogLength
                FROM ApexLog
                WHERE RequestIdentifier =: transactionId];
    }
    
    private static Map<String, sObject> getSobjectDetail(Set<String> recordIds, String objectApiName) {
        System.debug('SELECT Id, Name FROM ' + objectApiName + ' WHERE Id IN :recordIds');
        return new Map<String, sObject>(Database.query('SELECT Id, Name FROM ' + objectApiName + ' WHERE Id IN :recordIds'));
    }
}