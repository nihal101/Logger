public class EventLiveStreamController {
    
    @AuraEnabled
    public static Response getUserDetail(String userId) {
        Response response = new Response();
        try {
            List<User> users = [SELECT Id, UserName FROM User WHERE Id =: userId];
            if(!users.isEmpty()) {
                response.user = users[0];
                response.isSuccess = true;
                return response;
            }
            response.message = 'Selected User Not Found.';
            response.isSuccess = false;
        } catch(Exception ex) {
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
        public User user;
    }
}