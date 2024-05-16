public class LogEntryEventTriggerHelper {
    
    public static Map<String, List<Log_Entry_Event__e>> transactionIdToEntries = new Map<String, List<Log_Entry_Event__e>>();
    public static Map<String, Log_Detail__c> transactionIdToLogDetail = new Map<String, Log_Detail__c>();
    
    public static void handleNewPublishedEvent(List<Log_Entry_Event__e> newEvents) {
        for(Log_Entry_Event__e event : newEvents) {
            if(transactionIdToEntries.containsKey(event.Transaction_Id__c)) {
                List<Log_Entry_Event__e> newList = transactionIdToEntries.get(event.Transaction_Id__c);
                newList.add(event);
                transactionIdToEntries.put(event.Transaction_Id__c, newList); 
            }else {
                transactionIdToEntries.put(event.Transaction_Id__c, new List<Log_Entry_Event__e>{event});
            }
        }
        if(!transactionIdToEntries.isEmpty()) {
            for(String transactionId : transactionIdToEntries.keySet()) {
                if(transactionIdToEntries.get(transactionId) != null && !transactionIdToEntries.get(transactionId).isEmpty()) {
                   new LogEntryHandlerJob(transactionId, transactionIdToEntries.get(transactionId)).execute();
                }
            }
        }
    }
    
    /* This method will be called from LogEntryHandlerJob to create the LogDetail record from ApexLog. */
    public static Log_Detail__c createLogDetail(List<ApexLog> apexLogs) {
        try {
            Log_Detail__c newLogDetail = new Log_Detail__c();
            newLogDetail.Duration__c = 0;
            newLogDetail.Log_Length__c = 0;
            for(ApexLog log : apexLogs) {
                newLogDetail.Duration__c = log.DurationMilliseconds;
                newLogDetail.Log_Length__c = log.LogLength;
                newLogDetail.Request_Type__c = log.Request;
                newLogDetail.Start_Time__c = log.StartTime;
                newLogDetail.Status__c = log.Status;
                newLogDetail.Transaction_Id__c = log.RequestIdentifier;
                newLogDetail.User__c = log.LogUserId;
                //newLogDetail.Apex_Log_Id__c = log.Id;
            }
            insert newLogDetail;
            return newLogDetail;
        }catch(Exception ex) {
            return null;
        }
    }
}