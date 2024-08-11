@isTest
public class FlowLoggerForSingleSobjectTest {
    
    @TestSetup
    public static void setData() {
        Log_Detail__c logDetail = new Log_Detail__c();
        Logger.debug('This is debug');
        logDetail.Transaction_Id__c = Logger.getTransactionId() + '_test';
        insert logDetail;
    }
    
    @isTest
    public static void testAddEntryForDebug() {
        FlowLoggerForSingleSobject.FlowVariable flowVariable = new FlowLoggerForSingleSobject.FlowVariable();
        flowVariable.logType = false;
        flowVariable.sObj = [SELECT Id FROM Log_Detail__c LIMIT 1];
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleSobject.addEntry(new List<FlowLoggerForSingleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryForError() {
        FlowLoggerForSingleSobject.FlowVariable flowVariable = new FlowLoggerForSingleSobject.FlowVariable();
        flowVariable.logType = true;
        flowVariable.sObj = [SELECT Id FROM Log_Detail__c LIMIT 1];
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleSobject.addEntry(new List<FlowLoggerForSingleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenInputIsEmpty() {

        Test.startTest();
        FlowLoggerForSingleSobject.addEntry(new List<FlowLoggerForSingleSobject.FlowVariable>());
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenSobjIsNull1() {
        FlowLoggerForSingleSobject.FlowVariable flowVariable = new FlowLoggerForSingleSobject.FlowVariable();
        flowVariable.logType = true;
        flowVariable.sObj = null;
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleSobject.addEntry(new List<FlowLoggerForSingleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenSobjIsNull2() {
        FlowLoggerForSingleSobject.FlowVariable flowVariable = new FlowLoggerForSingleSobject.FlowVariable();
        flowVariable.logType = false;
        flowVariable.sObj = null;
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleSobject.addEntry(new List<FlowLoggerForSingleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenMessageIsBlank() {
        FlowLoggerForSingleSobject.FlowVariable flowVariable = new FlowLoggerForSingleSobject.FlowVariable();
        flowVariable.logType = true;
        flowVariable.sObj = null;
        flowVariable.message = '';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForSingleSobject.addEntry(new List<FlowLoggerForSingleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
}