public class Logger {
    
    private static List<Log_Entry_Event__e> entries = new  List<Log_Entry_Event__e>();
    private static Integer entry = 1;
    private static String origin = '';
    public static String componentType = 'APEX';
    public static String flowAPIName;
    
    public static void debug(String message) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex.getStackTraceString();
            log(message, 'DEBUG');
        }
    }
    
    public static void debug(String message, Id recordId) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex.getStackTraceString();
            log(message, recordId, 'DEBUG');
        }
    }
    
    public static void debug(String message, sObject sObj) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex.getStackTraceString();
            log(message, sObj, 'DEBUG');
        }
    }
    
    public static void debug(String message, List<sObject> listOfSobj) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex.getStackTraceString();
            log(message, listOfSobj, 'DEBUG');
        }
    }
    
    public static void error(String message) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex.getStackTraceString();
            log(message, 'ERROR');
        }
    }
    
    public static void error(String message, Id recordId) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex.getStackTraceString();
            log(message, recordId, 'ERROR');
        }
    }
    
    public static void error(String message, sObject sObj) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex.getStackTraceString();
            log(message, sObj, 'ERROR');
        }
    }
    
    public static void error(String message, List<sObject> listOfSobj) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex.getStackTraceString();
            log(message, listOfSobj, 'ERROR');
        }
    }
    
    public static void error(Exception ex) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex1) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex1.getStackTraceString();
            log(ex.getMessage(), 'EXCEPTION');
        }
    }
    
    public static void error(Exception ex, String recordId) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex1) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex1.getStackTraceString();
            log(ex.getMessage(), recordId, 'EXCEPTION');
        }
    }
    
    public static void error(Exception ex, sObject sObj) {
        try {
           throw new LoggerException(); 
        }catch(Exception ex1) {
            origin = String.isNotBlank(flowAPIName) ? flowAPIName : ex1.getStackTraceString();
            log(ex.getMessage(), sObj, 'EXCEPTION');
        }
    }
        
    private static void log(String message, String level) {
        entries.add(new Log_Entry_Event__e(Transaction_Id__c = Request.getCurrent().getRequestId(),
                                           Message__c = message,
                                           Entry__c = entry++,
                                           Level__c = level,
                                           Type__c = 'LogEntry',
                                           Origin__c = origin,
                                           User_Name__c = UserInfo.getUserName(),
                                           Component_Type__c = componentType));
    }
    
    private static void log(String message, Id recordId, String level) {
        entries.add(new Log_Entry_Event__e(Record_Id__c = recordId, 
                                           Transaction_Id__c = Request.getCurrent().getRequestId(),
                                           Message__c = message,
                                           Entry__c = entry++,
                                           Level__c = level,
                                           Type__c = 'LogEntry',
                                           Origin__c = origin,
                                           User_Name__c = UserInfo.getUserName(),
                                           Component_Type__c = componentType));
    }
    
    private static void log(String message, sObject sObj, String level) {
        if(String.isBlank(sObj.Id)) {
            return;
        }
        entries.add(new Log_Entry_Event__e(Record_Id__c = sObj.Id, 
                                           Transaction_Id__c = Request.getCurrent().getRequestId(),
                                           Message__c = message,
                                           Entry__c = entry++,
                                           Level__c = level,
                                           Type__c = 'LogEntry',
                                           Origin__c = origin,
                                           User_Name__c = UserInfo.getUserName(),
                                           Component_Type__c = componentType));
    }
    
    private static void log(String message, List<sObject> listOfSobj, String level) {
        if(listOfSobj.isEmpty()) {
            return;
        }
        for(sObject sObj : listOfSobj) {
            if(String.isBlank(sObj.Id)) {
                continue;
            }
            entries.add(new Log_Entry_Event__e(Record_Id__c = sObj.Id, 
                                               Transaction_Id__c = Request.getCurrent().getRequestId(),
                                               Message__c = message,
                                               Entry__c = entry++,
                                               Level__c = level,
                                               Type__c = 'LogEntry',
                                               Origin__c = origin,
                                               User_Name__c = UserInfo.getUserName(),
                                               Component_Type__c = componentType));
        }
    }
    
    public static String getTransactionId() {
        return Request.getCurrent().getRequestId();
    }
    
    public static void setParentTransactionId(String transactionId) {
        entries.add(new Log_Entry_Event__e(Transaction_Id__c = Request.getCurrent().getRequestId(),
                                           Parent_Transaction_Id__c = transactionId,
                                           Type__c = 'MappingParent'));
    }
    
    public static void saveLog() {
        try {
             throw new LoggerException(); 
        }catch(Exception ex) {
            origin = ex.getStackTraceString();
            entries.add(new Log_Entry_Event__e(Transaction_Id__c = Request.getCurrent().getRequestId(),
                                               Message__c = 'File Logger - Saving ' + (entry - 1) + ' via Event Bus.',
                                               Entry__c = entry++,
                                               Level__c = 'DEBUG',
                                               Type__c = 'LogDetail',
                                               Callouts__c = LIMITS.getCallouts(),
                                               CPU_Time__c = LIMITS.getCpuTime(),
                                               DML_Statements__c = LIMITS.getDMLStatements(),
                                               Heap_Size__c = LIMITS.getHeapSize(),
                                               SOQL_Queries__c = LIMITS.getQueries(),
                                               SOSL_Queries__c = LIMITS.getSoslQueries(),
                                               Aggregate_Queries__c = LIMITS.getAggregateQueries(),
                                               Async_Calls__c = LIMITS.getAsyncCalls(),
                                               DML_Rows__c = LIMITS.getDMLRows(),
                                               Email_Invocations__c = LIMITS.getEmailInvocations(),
                                               Future_Calls__c = LIMITS.getFutureCalls(),
                                               Queueable_Jobs__c = LIMITS.getQueueableJobs(),
                                               Query_Rows__c = LIMITS.getQueryRows(),
                                               Query_Locator_Rows__c = LIMITS.getQueryLocatorRows(),
                                               Callouts_Limit__c = Limits.getLimitCallouts(),
                                               CPU_Time_Limit__c = Limits.getLimitCpuTime(),
                                               DML_Statements_Limit__c = Limits.getLimitDMLStatements(),
                                               Heap_Size_Limit__c = Limits.getLimitHeapSize(),
                                               SOQL_Queries_Limit__c = Limits.getLimitQueries(),
                                               SOSL_Queries_Limit__c = Limits.getLimitSoslQueries(),
                                               Aggregate_Queries_Limit__c = LIMITS.getLimitAggregateQueries(),
                                               Async_Calls_Limit__c = LIMITS.getLimitAsyncCalls(),
                                               DML_Rows_Limit__c = LIMITS.getLimitDMLRows(),
                                               Email_Invocations_Limit__c = LIMITS.getLimitEmailInvocations(),
                                               Future_Calls_Limit__c = LIMITS.getLimitFutureCalls(),
                                               Queueable_Jobs_Limit__c = LIMITS.getLimitQueueableJobs(),
                                               Query_Rows_Limit__c = LIMITS.getLimitQueryRows(),
                                               Query_Locator_Rows_Limit__c = LIMITS.getLimitQueryLocatorRows(),
                                               Component_Type__c = componentType,
                                               Origin__c = origin));
            if(!entries.isEmpty()) {
                EventBus.publish(entries);
                clearAll();
            }
        }
    }
    
    @InvocableMethod(label='Save Log' description='Used to all log in current transaction' iconName='slds:standard:timesheet_entry')
    public static void saveFlowLog() {
        try {
             throw new LoggerException(); 
        }catch(Exception ex) {
            origin = ex.getStackTraceString();
            entries.add(new Log_Entry_Event__e(Transaction_Id__c = Request.getCurrent().getRequestId(),
                                               Message__c = 'File Logger - Saving ' + (entry - 1) + ' via Event Bus.',
                                               Entry__c = entry++,
                                               Level__c = 'DEBUG',
                                               Type__c = 'LogDetail',
                                               Callouts__c = LIMITS.getCallouts(),
                                               CPU_Time__c = LIMITS.getCpuTime(),
                                               DML_Statements__c = LIMITS.getDMLStatements(),
                                               Heap_Size__c = LIMITS.getHeapSize(),
                                               SOQL_Queries__c = LIMITS.getQueries(),
                                               SOSL_Queries__c = LIMITS.getSoslQueries(),
                                               Aggregate_Queries__c = LIMITS.getAggregateQueries(),
                                               Async_Calls__c = LIMITS.getAsyncCalls(),
                                               DML_Rows__c = LIMITS.getDMLRows(),
                                               Email_Invocations__c = LIMITS.getEmailInvocations(),
                                               Future_Calls__c = LIMITS.getFutureCalls(),
                                               Queueable_Jobs__c = LIMITS.getQueueableJobs(),
                                               Query_Rows__c = LIMITS.getQueryRows(),
                                               Query_Locator_Rows__c = LIMITS.getQueryLocatorRows(),
                                               Callouts_Limit__c = Limits.getLimitCallouts(),
                                               CPU_Time_Limit__c = Limits.getLimitCpuTime(),
                                               DML_Statements_Limit__c = Limits.getLimitDMLStatements(),
                                               Heap_Size_Limit__c = Limits.getLimitHeapSize(),
                                               SOQL_Queries_Limit__c = Limits.getLimitQueries(),
                                               SOSL_Queries_Limit__c = Limits.getLimitSoslQueries(),
                                               Aggregate_Queries_Limit__c = LIMITS.getLimitAggregateQueries(),
                                               Async_Calls_Limit__c = LIMITS.getLimitAsyncCalls(),
                                               DML_Rows_Limit__c = LIMITS.getLimitDMLRows(),
                                               Email_Invocations_Limit__c = LIMITS.getLimitEmailInvocations(),
                                               Future_Calls_Limit__c = LIMITS.getLimitFutureCalls(),
                                               Queueable_Jobs_Limit__c = LIMITS.getLimitQueueableJobs(),
                                               Query_Rows_Limit__c = LIMITS.getLimitQueryRows(),
                                               Query_Locator_Rows_Limit__c = LIMITS.getLimitQueryLocatorRows(),
                                               Component_Type__c = componentType,
                                               Origin__c = flowAPIName));
            if(!entries.isEmpty()) {
                EventBus.publish(entries);
                clearAll();
            }
        }
    }
    
    private static void clearAll() {
        entries.clear();
    }
    
    public class LoggerException extends Exception {
        
    }
}