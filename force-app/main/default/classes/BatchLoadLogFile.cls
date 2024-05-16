public class BatchLoadLogFile implements Database.Batchable<sObject> {
    
    public String transactionId;
    public String recordId;
    
    public BatchLoadLogFile(String transactionId, String recordId) {
        this.transactionId = transactionId;
        this.recordId = recordId;
    }
    
    public Iterable<sObject> start(Database.BatchableContext bc) {
        return SobjectHelper.getAllApexLog(transactionId);
    }
    
    public void execute(Database.BatchableContext bc, List<ApexLog> logRecords) {
        if(logRecords.isEmpty() || String.isBlank(recordId)) {
            return;
        }
        String baseURL = Url.getOrgDomainURL().toExternalForm();
        String endPointUrl = baseUrl + '/services/data/v58.0/sobjects/ApexLog/' + logRecords[0].Id + '/Body';
        CalloutHelper helper = new CalloutHelper(endPointUrl, null, 'GET');
        helper.setHeaders('Authorization', 'Bearer ' + UserInfo.getSessionId());
        helper.sendRequest(helper.getHttpRequest());
        
        if(helper.isSuccess()) {
            FileHandler.addLogFile(helper.response.getBody());
        }else {
            System.debug('Error ' + helper.response.getBody());
        }
        FileHandler.createFile();
        FileHandler.relateFileToRecord(recordId);
    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
}