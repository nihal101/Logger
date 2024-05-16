public class ToolingApiController {
    
    @Future(callout=true)
    public static void handleLogFile(String transactionId, String recordId) {
        
        List<ApexLog> apexLogs = SobjectHelper.getAllApexLog(transactionId);
        
        if(!Test.isRunningTest() && (apexLogs.isEmpty())) { 
            return;
        }
        
        String baseURL = Url.getOrgDomainURL().toExternalForm();
        for(ApexLog log : apexLogs) {
            if(Limits.getCallouts() + 10 > Limits.getLimitCallouts()) {
                break;
            }
            String endPointUrl = baseUrl + '/services/data/v58.0/sobjects/ApexLog/' + log.Id + '/Body';
            CalloutHelper helper = new CalloutHelper(endPointUrl, null, 'GET');
            helper.setHeaders('Authorization', 'Bearer ' + UserInfo.getSessionId());
            helper.sendRequest(helper.getHttpRequest());
            
            if(helper.isSuccess()) {
                FileHandler.addLogFile(helper.response.getBody());
            }else {
                System.debug('Error ' + helper.response.getBody());
            }
        }
        FileHandler.createFile();
        FileHandler.relateFileToRecord(recordId);
    }
}