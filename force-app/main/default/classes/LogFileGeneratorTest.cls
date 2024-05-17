@isTest
public class LogFileGeneratorTest {
    
    @TestSetup
    public static void setData() {
        Log_Detail__c logDetail = new Log_Detail__c();
        Logger.debug('This is debug');
        logDetail.Transaction_Id__c = Logger.getTransactionId() + '_test';
        insert logDetail;
        Logger.saveLog();
    }
    
    @isTest
    public static void testStartJobWithSuccess() {
        List<Log_Detail__c> logDetail = [SELECT Id, Transaction_Id__c FROM Log_Detail__c];
        LogFileGenerator.FlowInput input = new LogFileGenerator.FlowInput();
        input.recordId = logDetail[0].Id;
        input.transactionId = logDetail[0].Transaction_Id__c;
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 200));
        	LogFileGenerator.startJob(new List<LogFileGenerator.FlowInput>{input});
        Test.stopTest();
    }
    
    @isTest
    public static void testStartJobWithError() {
        List<Log_Detail__c> logDetail = [SELECT Id, Transaction_Id__c FROM Log_Detail__c];
        LogFileGenerator.FlowInput input = new LogFileGenerator.FlowInput();
        input.recordId = logDetail[0].Id;
        input.transactionId = logDetail[0].Transaction_Id__c;
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new LoggerTestMock('Test Log', 400));
        	LogFileGenerator.startJob(new List<LogFileGenerator.FlowInput>{input});
        Test.stopTest();
    }
    
    @isTest
    public static void testStartJobWithBlankArgument() {
        List<Log_Detail__c> logDetail = [SELECT Id, Transaction_Id__c FROM Log_Detail__c];
        LogFileGenerator.FlowInput input = new LogFileGenerator.FlowInput();
        input.recordId = logDetail[0].Id;
        input.transactionId = '';
        Test.startTest();
        	LogFileGenerator.startJob(new List<LogFileGenerator.FlowInput>{input});
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