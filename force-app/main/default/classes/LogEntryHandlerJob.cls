public class LogEntryHandlerJob {
    
    public String transactionId;
    public List<Log_Entry_Event__e> entries;
    
    public LogEntryHandlerJob(String transactionId,  List<Log_Entry_Event__e> entries) {
        this.transactionId = transactionId;
        this.entries = entries;
    }
    
    /* This method will be called from LogEntryEventTriggerHelper for each unique transaction id.*/
    public void execute() {

		// Check log detail record already exists with the transaction id or not.        
        List<Log_Detail__c> logDetails = SobjectHelper.getLogDetails(new Set<String>{this.transactionId});
        Log_Detail__c logDetail = null;
        if(!logDetails.isEmpty()) {
            // If yes, then get the details.
            logDetail = logDetails[0];
        }else {
            // If not, then create new log detail record.
            logDetail = LogEntryEventTriggerHelper.createLogDetail(SobjectHelper.getAllApexLog(this.transactionId));
        }
        
        if(logDetail == null) {
            return;
        }
        
        // Initialize below
        logDetail.Callouts__c = 0;
        logDetail.CPU_Time__c = 0;
        logDetail.DML_Statements__c = 0;
        logDetail.Heap_Size__c = 0;
        logDetail.SOQL_Queries__c = 0;
        logDetail.SOSL_Queries__c = 0;
        logDetail.SOSL_Queries__c = 0;
        logDetail.Aggregate_Queries__c = 0;
        logDetail.Async_Calls__c = 0;
        logDetail.DML_Rows__c = 0;
        logDetail.Email_Invocations__c = 0;
        logDetail.Future_Calls__c = 0;
        logDetail.Queueable_Jobs__c = 0;
        logDetail.Query_Rows__c = 0;
        logDetail.Query_Locator_Rows__c = 0;
        
        List<Log_Entry__c> enrtiesNeedToCreate = new List<Log_Entry__c>();
        Set<String> recordIds = new Set<String>();
        Set<String> objectApiNames = new Set<String>();
        Set<String> transactionIds = new Set<String>();
        for(Log_Entry_Event__e entry : entries) {
            
            if(entry.Type__c == 'MappingParent' && String.isNotBlank(entry.Parent_Transaction_Id__c)) {
                transactionIds.add(entry.Parent_Transaction_Id__c);
                continue;
            }
            
            if(entry.Type__c == 'LogDetail') {
                logDetail.Component_Type__c = entry.Component_Type__c;
                logDetail.Callouts_Limit__c = entry.Callouts_Limit__c;
                logDetail.CPU_Time_Limit__c = entry.CPU_Time_Limit__c;
                logDetail.DML_Statements_Limit__c = entry.DML_Statements_Limit__c;
                logDetail.Heap_Size_Limit__c = entry.Heap_Size_Limit__c;
                logDetail.SOQL_Queries_Limit__c = entry.SOQL_Queries_Limit__c;
                logDetail.SOSL_Queries_Limit__c = entry.SOSL_Queries_Limit__c;
                logDetail.Aggregate_Queries_Limit__c = entry.Aggregate_Queries_Limit__c;
                logDetail.Async_Calls_Limit__c = entry.Async_Calls_Limit__c;
                logDetail.DML_Rows_Limit__c = entry.DML_Rows_Limit__c;
                logDetail.Email_Invocations_Limit__c = entry.Email_Invocations_Limit__c;
                logDetail.Future_Calls_Limit__c = entry.Future_Calls_Limit__c;
                logDetail.Queueable_Jobs_Limit__c = entry.Queueable_Jobs_Limit__c;
                logDetail.Query_Rows_Limit__c = entry.Query_Rows_Limit__c;
                logDetail.Query_Locator_Rows_Limit__c = entry.Query_Locator_Rows_Limit__c;
                logDetail.Callouts__c = logDetail.Callouts__c < entry.Callouts__c ? entry.Callouts__c : logDetail.Callouts__c;
                logDetail.CPU_Time__c = logDetail.CPU_Time__c < entry.CPU_Time__c ? entry.CPU_Time__c : logDetail.CPU_Time__c;
                logDetail.DML_Statements__c = logDetail.DML_Statements__c < entry.DML_Statements__c ? entry.DML_Statements__c : logDetail.DML_Statements__c;
                logDetail.Heap_Size__c = logDetail.Heap_Size__c < entry.Heap_Size__c ? entry.Heap_Size__c : logDetail.Heap_Size__c;
                logDetail.SOQL_Queries__c = logDetail.SOQL_Queries__c < entry.SOQL_Queries__c ? entry.SOQL_Queries__c : logDetail.SOQL_Queries__c;
                logDetail.SOSL_Queries__c = logDetail.SOSL_Queries__c < entry.SOSL_Queries__c ? entry.SOSL_Queries__c : logDetail.SOSL_Queries__c;
                logDetail.Aggregate_Queries__c = logDetail.Aggregate_Queries__c < entry.Aggregate_Queries__c ? entry.Aggregate_Queries__c : logDetail.Aggregate_Queries__c;
                logDetail.Async_Calls__c = logDetail.Async_Calls__c < entry.Async_Calls__c ? entry.Async_Calls__c : logDetail.Async_Calls__c;
                logDetail.DML_Rows__c = logDetail.DML_Rows__c < entry.DML_Rows__c ? entry.DML_Rows__c : logDetail.DML_Rows__c;
                logDetail.Email_Invocations__c = logDetail.Email_Invocations__c < entry.Email_Invocations__c ? entry.Email_Invocations__c : logDetail.Email_Invocations__c;
                logDetail.Future_Calls__c = logDetail.Future_Calls__c < entry.Future_Calls__c ? entry.Future_Calls__c : logDetail.Future_Calls__c;
                logDetail.Queueable_Jobs__c = logDetail.Queueable_Jobs__c < entry.Queueable_Jobs__c ? entry.Queueable_Jobs__c : logDetail.Queueable_Jobs__c;
                logDetail.Query_Rows__c = logDetail.Query_Rows__c < entry.Query_Rows__c ? entry.Query_Rows__c : logDetail.Query_Rows__c;
                logDetail.Query_Locator_Rows__c = logDetail.Query_Locator_Rows__c < entry.Query_Locator_Rows__c ? entry.Query_Locator_Rows__c : logDetail.Query_Locator_Rows__c;
            }
            
            String sobjectName = String.isNotBlank(entry.Record_Id__c) ? ((Id)entry.Record_Id__c).getSObjectType().getDescribe().getName() : '';
            String origin = getOrigin(entry.Origin__c);
            enrtiesNeedToCreate.add(new Log_Entry__c(Record_Id__c = entry.Record_Id__c, 
                                                     Log_Detail__c = logDetail.Id,
                                                     Object_Api_Name__c = sobjectName,
                                                     Entry__c = entry.Entry__c,
                                                     Level_Text__c = entry.Level__c,
                                                     Message__c = entry.Message__c,
                                                     Origin__c = origin,
                                                     Class_Name__c = getClassName(origin),
                                                     Message_Stacktrace__c = getStacktrace(entry.Origin__c),
                                                     Component_Type__c = entry.Component_Type__c));
            if(String.isNotBlank(entry.Record_Id__c)) {
                recordIds.add(entry.Record_Id__c);
            }
            if(String.isNotBlank(sobjectName)) {
                objectApiNames.add(sobjectName);
            }
        }
        
        Map<String, sObject> idToSObjectDetail = SobjectHelper.getSobjectDetail(recordIds, objectApiNames);
        if(!idToSObjectDetail.isEmpty()) {
            for(Log_Entry__c logEntry : enrtiesNeedToCreate) {
                logEntry.Record_Name__c = idToSObjectDetail.containsKey(logEntry.Record_Id__c) ? String.valueOf(idToSObjectDetail.get(logEntry.Record_Id__c).get('Name')) : '';
            }
        }
        
        if(!enrtiesNeedToCreate.isEmpty()) {
            insert enrtiesNeedToCreate;
        }
        
        Map<String, sObject> transactionIdToLogDetail = SobjectHelper.getMap(SobjectHelper.getLogDetails(transactionIds), 'Transaction_Id__c');
        for(String transactionId : transactionIdToLogDetail.keySet()) {
            if(String.isNotBlank(String.valueOf(transactionIdToLogDetail.get(transactionId).get('Id')))) {
                logDetail.Parent_Log__c = String.valueOf(transactionIdToLogDetail.get(transactionId).get('Id'));
                break;
            }
        }
        update logDetail;
    }
    
    private static String getOrigin(String origin) {
        if(String.isBlank(origin)) {
            return origin;
        }
        if(!origin.contains('\n')) {
            return origin.contains(',') ? origin.split(',')[0] : origin;
        }
        List<String> originList = origin.split('\n');
        if(originList.size() >= 2 && String.isNotBlank(originList.get(1)) && originList.get(1).contains(',')) {
            return originList.get(1).split(',')[0];
        }else if(originList.size() >= 2 && String.isNotBlank(originList.get(1))) {
            return originList.get(1);
        }
        return '';
    }
    
    public static String getClassName(String origin) {
        if(String.isBlank(origin)) {
            return origin;
        }
        try {
            return origin.contains('.') ? origin.substringAfter('.').substringBefore('.') : origin;
        }catch(Exception ex) {
            return 'Unknown';
        }
    }
    
    private static String getStacktrace(String origin) {
        if(String.isBlank(origin)) {
            return origin;
        }
        if(!origin.contains('\n')) {
            return origin.contains(',') ? origin.split(',')[0] : origin;
        }
        List<String> originList = origin.split('\n');
        String result = '';
        for(Integer i = 1; i < originList.size(); i++) {
            result += originList.get(i).contains(',') ? originList.get(i).split(',')[0] + '\n' : originList.get(i) + '\n';
        }
        return result;
    }
}