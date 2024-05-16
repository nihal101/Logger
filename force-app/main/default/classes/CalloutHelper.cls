public class CalloutHelper {
    
    public String endPointUrl;//
    public String body;
    public String method;
    public Integer statusCode;
    public Map<String, String> headers;
    public HttpResponse response;
    
    public Boolean isSuccess() {
        return this.statusCode == 200 ? true : false;
    }
    
    public CalloutHelper(String endPointUrl, String body, String method) {
        this.endPointUrl = endPointUrl;
        this.body = body;
        this.method = method;
    }
    
    public void setHeaders(String key, String value) {
        if(this.headers == null) {
            headers = new Map<String, String>();
        }
        this.headers.put(key, value);
    }
    
    private void setHeaders(HttpRequest httpRequest) {
        if(this.headers != null && !this.headers.isEmpty()) {
            for(String key : this.headers.keySet()) {
                httpRequest.setHeader(key, this.headers.get(key));
            }
        }
    }
    
    public HttpRequest getHttpRequest() {
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        this.setHeaders(httpRequest);
        httpRequest.setTimeout(60000);
        httpRequest.setEndpoint(this.endPointUrl);
        httpRequest.setMethod(this.method);
        return httpRequest;
    }
    
    public void sendRequest(HttpRequest httpRequest) {
        this.response = new Http().send(httpRequest);
        this.statusCode = this.response.getStatusCode();
    }
}
