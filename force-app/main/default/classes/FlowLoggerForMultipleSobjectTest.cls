@isTest
public class FlowLoggerForMultipleSobjectTest {
    @TestSetup
    public static void setData() {
        Log_Detail__c logDetail = new Log_Detail__c();
        Logger.debug('This is debug');
        logDetail.Transaction_Id__c = Logger.getTransactionId() + '_test';
        insert logDetail;
    }
    
    @isTest
    public static void testAddEntryForDebug() {
        FlowLoggerForMultipleSobject.FlowVariable flowVariable = new FlowLoggerForMultipleSobject.FlowVariable();
        flowVariable.logType = false;
        flowVariable.listOfSobj = [SELECT Id FROM Log_Detail__c LIMIT 1];
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForMultipleSobject.addEntry(new List<FlowLoggerForMultipleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryForError() {
        FlowLoggerForMultipleSobject.FlowVariable flowVariable = new FlowLoggerForMultipleSobject.FlowVariable();
        flowVariable.logType = true;
        flowVariable.listOfSobj = [SELECT Id FROM Log_Detail__c LIMIT 1];
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForMultipleSobject.addEntry(new List<FlowLoggerForMultipleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenInputIsEmpty() {
        
        Test.startTest();
        FlowLoggerForMultipleSobject.addEntry(new List<FlowLoggerForMultipleSobject.FlowVariable>());
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenSobjIsNull1() {
        FlowLoggerForMultipleSobject.FlowVariable flowVariable = new FlowLoggerForMultipleSobject.FlowVariable();
        flowVariable.logType = true;
        flowVariable.listOfSobj = null;
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForMultipleSobject.addEntry(new List<FlowLoggerForMultipleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenSobjIsNull2() {
        FlowLoggerForMultipleSobject.FlowVariable flowVariable = new FlowLoggerForMultipleSobject.FlowVariable();
        flowVariable.logType = false;
        flowVariable.listOfSobj = null;
        flowVariable.message = 'This is test log';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForMultipleSobject.addEntry(new List<FlowLoggerForMultipleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
    
    @isTest
    public static void testAddEntryWhenMessageIsBlank() {
        FlowLoggerForMultipleSobject.FlowVariable flowVariable = new FlowLoggerForMultipleSobject.FlowVariable();
        flowVariable.logType = true;
        flowVariable.listOfSobj = null;
        flowVariable.message = '';
        flowVariable.flowAPIName = 'Test_Flow';
        
        Test.startTest();
        FlowLoggerForMultipleSobject.addEntry(new List<FlowLoggerForMultipleSobject.FlowVariable>{flowVariable});
        Test.stopTest();
    }
}