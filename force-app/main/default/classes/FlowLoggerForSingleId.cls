public class FlowLoggerForSingleId {
    
    @InvocableMethod(label='Add Entry Against Record Id' description='Used to create log entry' iconName='slds:standard:timesheet_entry')
    public static void addEntry(List<FlowVariable> flowVariable) {
        if(flowVariable.isEmpty()) {
            return;
        }
        if(String.isBlank(flowVariable[0].message)) {
            return;
        }
        Logger.componentType = 'FLOW';
        Logger.flowAPIName = flowVariable[0].flowAPIName;
        if(flowVariable[0].logType == true) {
            handleErrorLog(flowVariable);
        }else if(flowVariable[0].logType == false) {
            handleDebugLog(flowVariable);
        }
    }
    
    private static void handleDebugLog(List<FlowVariable> flowVariable) {
        Boolean isMessageSaved = false;
        if(String.isNotBlank(flowVariable[0].recordId)) {
            Logger.debug(flowVariable[0].message, flowVariable[0].recordId);
            isMessageSaved = true;
        }
        if(isMessageSaved == false) {
            Logger.debug(flowVariable[0].message);
        }
    }
    
    private static void handleErrorLog(List<FlowVariable> flowVariable) {
        Boolean isMessageSaved = false;
        if(String.isNotBlank(flowVariable[0].recordId)) {
            Logger.error(flowVariable[0].message, flowVariable[0].recordId);
            isMessageSaved = true;
        }
        if(isMessageSaved == false) {
            Logger.error(flowVariable[0].message);
        }
    }
    
    public class FlowVariable {
        @InvocableVariable(label='Flow API Name' description='Enter Flow API Name' required=true)
        public String flowAPIName;
        @InvocableVariable(label='Entry Message' description='Message want to log' required=true)
        public String message;
        @InvocableVariable(label='Error Log ?' description='If set to true then error log will be created otherwise success log will be created')
        public Boolean logType;
        @InvocableVariable(label='Record Id' description='Put the value of record id against which log entry should be created.')
        public String recordId;
    }
}