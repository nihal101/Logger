public class LogDetailController {
    
    private static Map<String, String> recordIdToContentDocumentId = new Map<String, String>();
    
    @AuraEnabled
    public static Response getLogDetails(String recordId, Integer offSet, Integer numberOfRecord) {
        Response response = new Response();
        try {
            List<Log_Detail__c> listOfLogDetail = [SELECT Id,
                                                   Name,
                                                   Log_Length__c,
                                                   Status__c,
                                                   Start_Time__c,
                                                   User__c,
                                                   User__r.Name
                                                   FROM Log_Detail__c
                                                   WHERE Id IN (SELECT Log_Detail__c FROM Log_Entry__c WHERE Record_Id__c =: recordId)
                                                   ORDER BY CreatedDate DESC
                                                   LIMIT : numberOfRecord
                                                   OFFSET : offSet];
            Set<Id> recordIds = new Set<Id>();
            if(!listOfLogDetail.isEmpty()) {
                List<LogDetail> records = new List<LogDetail>();
                for(Log_Detail__c logDetail : listOfLogDetail) {
                    records.add(new LogDetail(logDetail));
                    recordIds.add(logDetail.Id);
                }
                for(ContentDocumentLink cdl : [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN : recordIds ORDER BY SystemModstamp DESC LIMIT 1]) {
                    if(!recordIdToContentDocumentId.containsKey(cdl.LinkedEntityId)) {
                        recordIdToContentDocumentId.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
                    }
                }
                for(LogDetail logDetail : records) {
                    logDetail.contentDocumentId = recordIdToContentDocumentId.containsKey(logDetail.recordId) ? recordIdToContentDocumentId.get(logDetail.recordId) : null;
                }
                response.records = records;
                response.isSuccess = true;
            }else {
                response.message = 'No Log Detail(s) found.';
                response.isSuccess = false;
            }
        }catch(Exception ex) {
            response.message = ex.getMessage();
            response.isSuccess = false;
        }
        return response;
    }
    
    public class Response {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public List<LogDetail> records;
    }
    
    public class LogDetail {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String userName;
        @AuraEnabled
        public Integer logLength;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String startTime;
        @AuraEnabled
        public String recordId;
        @AuraEnabled
        public String userId;
        @AuraEnabled
        public String contentDocumentId;
        
        public LogDetail(Log_Detail__c logDetail) {
            this.name = logDetail.Name;
            this.userName = logDetail.User__r.Name;
            this.logLength = (Integer)logDetail.Log_Length__c;
            this.status = logDetail.Status__c;
            this.startTime = String.valueOf(logDetail.Start_Time__c);
            this.recordId = logDetail.Id;
            this.userId = logDetail.User__c;
        }
    }
}