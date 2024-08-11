@isTest
public class FlowLoggerForSingleIdTest {
    @TestSetup
    public static void setData() {
        Log_Detail__c logDetail = new Log_Detail__c();
        Logger.debug('This is debug');
        logDetail.Transaction_Id__c = Logger.getTransactionId() + '_test';
        insert logDetail;
    }
    
    @isTest
    public static void testAddEntryForDebug() {
        FlowLoggerForSingleId.FlowVariable flowVariable = new FlowLoggerForSingleId.FlowVariable();
        flowVariable.logType = false;
        flowVariable.recordId = [SELECT Id FROM Log_Detail__c LIMIT 1].Id;
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleId.addEntry(new List<FlowLoggerForSingleId.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryForError() {
        FlowLoggerForSingleId.FlowVariable flowVariable = new FlowLoggerForSingleId.FlowVariable();
        flowVariable.logType = true;
        flowVariable.recordId = [SELECT Id FROM Log_Detail__c LIMIT 1].Id;
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleId.addEntry(new List<FlowLoggerForSingleId.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenInputIsEmpty() {
        
        Test.startTest();
        FlowLoggerForSingleId.addEntry(new List<FlowLoggerForSingleId.FlowVariable>());
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenSobjIsNull1() {
        FlowLoggerForSingleId.FlowVariable flowVariable = new FlowLoggerForSingleId.FlowVariable();
        flowVariable.logType = true;
        flowVariable.recordId = null;
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleId.addEntry(new List<FlowLoggerForSingleId.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenSobjIsNull2() {
        FlowLoggerForSingleId.FlowVariable flowVariable = new FlowLoggerForSingleId.FlowVariable();
        flowVariable.logType = false;
        flowVariable.recordId = null;
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleId.addEntry(new List<FlowLoggerForSingleId.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenMessageIsBlank() {
        FlowLoggerForSingleId.FlowVariable flowVariable = new FlowLoggerForSingleId.FlowVariable();
        flowVariable.logType = true;
        flowVariable.recordId = null;
        flowVariable.message = '';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleId.addEntry(new List<FlowLoggerForSingleId.FlowVariable>{flowVariable});
        Test.stopTest();
    }
}