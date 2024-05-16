@isTest
public class LogDetailControllerTest {
    
    @TestSetup
    public static void setData() {
        // As record.
        Log_Detail__c log1 = new Log_Detail__c();
        // As log record.
        Log_Detail__c log2 = new Log_Detail__c();
        List<Log_Detail__c> logs = new List<Log_Detail__c> ();
        logs.add(log1);
        logs.add(log2);
        insert logs;
        
        // Add entries
        List<Log_Entry__c> logEntries = new List<Log_Entry__c>();
        logEntries.add(new Log_Entry__c(Record_Id__c = logs[0].Id,
                                        Log_Detail__c = logs[1].Id));
        insert logEntries;
        
        ContentVersion objCV = new ContentVersion(
            Title = 'Log File.txt',
            PathOnClient = 'test.txt',
            VersionData = Blob.valueOf('testData')
        );
        insert objCV;
        objCV = [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE Id =: objCV.Id
        ];
        ContentDocumentLink objCDL = new ContentDocumentLink(
            ContentDocumentId = objCV.ContentDocumentId,
            LinkedEntityId = logs[1].Id,
            Visibility = 'AllUsers'
        );
        insert objCDL;
    }
    
    @isTest
    public static void testGetLogDetails() {
        List<Log_Detail__c> logs = [SELECT Id FROM Log_Detail__c];
        Test.startTest();
        	LogDetailController.getLogDetails(logs[0].Id, 0, 1);
        	LogDetailController.getLogDetails(logs[1].Id, 0, 1);
        Test.stopTest();
    }
    
    @isTest
    public static void testGetLogDetailsWithError() {
        List<Log_Detail__c> logs = [SELECT Id FROM Log_Detail__c];
        Test.startTest();
        	LogDetailController.getLogDetails(logs[0].Id, null, null);
        Test.stopTest();
    }
}