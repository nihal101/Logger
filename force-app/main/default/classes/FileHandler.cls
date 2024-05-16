public class FileHandler {
    
    private static List<ContentVersion> contentVersions = new List<ContentVersion>();
    
    public static void addLogFile(String logData) {
        String base64Content = EncodingUtil.Base64Encode( 
            Blob.valueOf(logData) 
        );
        Blob blobContent = EncodingUtil.base64Decode( base64Content );
        ContentVersion objCV = new ContentVersion(
            Title = 'Log File.txt',
            PathOnClient = 'test.txt',
            VersionData = blobContent 
        );
        contentVersions.add(objCV);
    }
    
    public static void createFile() {
        if(!contentVersions.isEmpty()) {
            insert contentVersions;
        }
    }
    
    public static void relateFileToRecord(String recordId) {
        if(contentVersions.isEmpty() || String.isBlank(recordId)) {
            return;
        }
        List<ContentVersion> listOfCvs = [SELECT ContentDocumentId FROM ContentVersion WHERE Id IN : contentVersions];
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        for(ContentVersion cv : listOfCvs) {
            contentDocumentLinks.add(new ContentDocumentLink(
                ContentDocumentId = cv.ContentDocumentId,
                LinkedEntityId = recordId,
                Visibility = 'AllUsers'
            ));
        }
        if(!contentDocumentLinks.isEmpty()) {
            insert contentDocumentLinks;
        }
    }
}