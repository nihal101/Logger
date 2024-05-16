@isTest
public class LoggerTest {
    
    @TestSetup
    public static void setData() {
        TriggerSetting__c setting = new TriggerSetting__c(); 
        setting.IsActive__c = true;
        setting.Name = 'LogEntryEventTrigger';
        insert setting;
        
        Log_Detail__c logDetail = new Log_Detail__c();
        Logger.debug('This is debug');
        logDetail.Transaction_Id__c = Logger.getTransactionId() + '_test';
        insert logDetail;
        Logger.saveLog();
    }
    
    @isTest
    public static void testLogEntriesInsertWithoutId() {
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 200));
            Logger.error('This is error');
            Logger.debug('This is debug');
            Logger.saveLog();
        Test.stopTest();
    }
    
    @isTest
    public static void testLogEntriesInsertWithId() {
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 200));
            List<Log_Detail__c> logDetail = [SELECT Id FROM Log_Detail__c];
            Logger.error('This is error', logDetail[0].Id);
            Logger.debug('This is debug', logDetail[0].Id);
            Logger.saveLog();
        Test.stopTest();
    }
    
    @isTest
    public static void testLogEntriesInsertWithSobject() {
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 200));
            List<Log_Detail__c> logDetail = [SELECT Id FROM Log_Detail__c];
            Logger.error('This is error', logDetail[0]);
            Logger.debug('This is debug', logDetail[0]);
            Logger.saveLog();
        Test.stopTest();
    }
    
    @isTest
    public static void testLogEntriesInsertWithSobjectList() {
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 200));
            List<Log_Detail__c> logDetail = [SELECT Id FROM Log_Detail__c];
            Logger.error('This is error', logDetail);
            Logger.debug('This is debug', logDetail);
            Logger.saveLog();
        Test.stopTest();
    }
    
    @isTest
    public static void testLogEntriesInsertBlankId() {
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 200));
            Log_Detail__c logDetail = new Log_Detail__c();
            Logger.error('This is error', logDetail);
            Logger.debug('This is debug', logDetail);
            Logger.saveLog();
        Test.stopTest();
    }
    
    @isTest
    public static void testLogEntriesInsertBlankSobject() {
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 200));
            Log_Detail__c logDetail = new Log_Detail__c();
            Logger.error('This is error', logDetail);
            Logger.debug('This is debug', logDetail);
            Logger.saveLog();
        Test.stopTest();
    }
    
    @isTest
    public static void testParentTransactionLogMapping() {
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 200));
            List<Log_Detail__c> logDetail = [SELECT Id, Transaction_Id__c FROM Log_Detail__c];
            Logger.error('This is error', logDetail);
            Logger.debug('This is debug', logDetail);
            Logger.setParentTransactionId(logDetail[0].Transaction_Id__c);
            Logger.saveLog();
        Test.stopTest();
    }
    
    @isTest
    public static void testLogEntriesInsertWithFileLog() {
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 200));
            List<Log_Detail__c> logDetail = [SELECT Id FROM Log_Detail__c];
            Logger.error('This is error', logDetail);
            Logger.debug('This is debug', logDetail);
            Logger.saveLog();
        Test.stopTest();
    }
    
    public class LoggerTestMock implements HttpCalloutMock {
        
        String body;
        Integer statusCode;
        
        public LoggerTestMock(String body, Integer statusCode) {
            this.body = body;
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(this.body);
            res.setStatusCode(this.statusCode);
            return res;
        }
    }
}