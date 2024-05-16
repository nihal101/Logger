public class LogFileGenerator {
    
    @InvocableMethod(label='Create Log File' description='Used to create log files for transaction id.')
    public static List<FlowOutput> startJob(List<FlowInput> input) {
        if(input.isEmpty()) {
            return new List<FlowOutput>{new FlowOutput('Input can\t be empty.')};
        }
        if(String.isBlank(input[0].transactionId)) {
            return new List<FlowOutput>{new FlowOutput('Transaction Id can\t be blank')};
        }
        Database.executeBatch(new BatchLoadLogFile(input[0].transactionId, input[0].recordId), 1); 
        return new List<FlowOutput>{new FlowOutput('Job has been submitted successfully. Log file will be created in a while.')};
    }
    
    public class FlowInput {
        @InvocableVariable
        public String transactionId;
        @InvocableVariable
        public String recordId;
    }
    
    public class FlowOutput {
        @InvocableVariable
        public String message;
        
        public FlowOutput(String message) {
            this.message = message;
        }
    }
}