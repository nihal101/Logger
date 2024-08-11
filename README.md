# Overview

	LogLinker is designed to work only with Apex and Salesforce users.

 # Method - Apex

 	We primarily use two types of logging methods: debug and error. The debug method logs entries when specific milestones are reached during execution. The error method is used to log entries when an unexpected event occurs.

 ## debug(String message)

 	Text message want to log.
  	Eg: Logger.debug('Debug 1');

## debug(String message, Id recordId)

 	Log entry against the sobject record by passing sobject record id(Including standard & custom sObject).
  	Eg: Logger.debug('Debug 1', {recordId});

## debug(String message, sObject sObj)

 	Log entry against the sobject record by passing sobject record reference(Including standard & custom sObject).
  	Eg: List<Account> accs = [SELECT Id FROM Account];
  	    Logger.debug('Debug 1', accs[0]);

## debug(message, listOfSobj)

	Log entry against the sobject record by passing collection(Including standard & custom sObject). An entry will be created for each record in the collection.
 	Eg: List<Account> accs = [SELECT Id FROM Account];
   	    Logger.debug('Debug 1', accs);

 ## debug(Exception ex)
        Using this method, we can pass instance of exception & it'll create a debug log entry record and also store all info related to the exception.
 	try {
  	     Integer num = 26/0;
  	}catch(Exception ex) {
   	     Logger.debug(ex);
	     Logger.saveLog();
   	}
    Note: There're two more method where we can link record to the Log Entry created via from Exception.
    1. Logger.debug(ex, recordId);
    2. Logger.debug(ex, sObjectReference);

 ## error(String message)

 	Text message want to log.
  	Eg: Logger.debug('Debug 1');

## error(String message, Id recordId)

 	Log entry against the sobject record by passing sobject record id(Including standard & custom sObject).
  	Eg: Logger.error('Error 1', {recordId});

## error(String message, sObj)

 	Log entry against the sobject record by passing sobject record reference(Including standard & custom sObject).
  	Eg: List<Account> accs = [SELECT Id FROM Account];
  	    Logger.error('Error 1', accs[0]);

## error(message, listOfSobj)

	Log entry against the sobject record by passing collection(Including standard & custom sObject). An entry will be created for each record in the collection.
 	Eg: List<Account> accs = [SELECT Id FROM Account];
   	    Logger.error('Error 1', accs);
	
 ## error(Exception ex)
        It's same as debug, it'll only create the error log entry record.
 	try {
  	     Integer num = 26/0;
  	}catch(Exception ex) {
   	     Logger.error(ex);
	     Logger.saveLog();
   	}
    Note: There're two more method where we can link record to the Log Entry created via from Exception.
    1. Logger.error(ex, recordId);
    2. Logger.error(ex, sObjectReference);

# Example

## Example 1
Create a simple debug/error entry

 	Logger.debug('Debug 1');
   	Logger.error('Error 1');
  	Logger.saveLog();

## Example 2
Create an entry & related to the record using either record ID or reference or list collection.

	List<Account> accs = [SELECT Id FROM Account];
 	Logger.debug('Record Id', accs[0].Id);
  	Logger.debug('Reference', accs[0]);
   	Logger.debug('List', accs);
  	Logger.saveLog();

## Example 3

Below an example of an apex class.

	public class ValidateNewAcccount {
	    public static Boolean isValidAccount(Account newAccount) {
	        Boolean isSuccess = true;
	        try {
	            if(newAccount.Name.contains('Test')) {
	                Logger.error('Account name can\'t contains \'Test\' keyword', newAccount);
	                isSuccess = false;
	            }
	            if(newAccount.BillingAddress == null) {
	                Logger.error('Account billing address can\'t be empty', newAccount);
	                isSuccess = false;
	            }
	            return isSuccess;
	        }catch(Exception ex) {
	            Logger.error(ex.getMessage(), newAccount);
	            isSuccess = false;
	        }finally {
	            Logger.saveLog();
	        }
	        return isSuccess;
	    }
	}

 ## Example 4

 Set parent log. This will be helpful when we're working with asynchronous apex. By using this we can see all related logs on one page.

 	public class CaseRetentionBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    String parentTransactionId = '';
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Logger.debug('Running SOQL to get all one year case records');
        parentTransactionId = Logger.getTransactionId();
        Logger.saveLog();
        return Database.getQueryLocator([SELECT Id FROM Case WHERE CreatedDate <= NEXT_N_YEARS:1]);
    }
    
    public void execute(Database.BatchableContext bc, List<Case> cases) {
        try {
            delete cases;
            Logger.debug('Deleted the case record : ' + cases.size());
            Logger.setParentTransactionId(parentTransactionId);
            Logger.saveLog();
        }catch(Exception ex) {
            Logger.error(ex.getMessage());
            Logger.saveLog();
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        Logger.debug('Job has been finished');
        Logger.setParentTransactionId(parentTransactionId);
        Logger.saveLog();
    }
}

# Configure Logger in Salesforce Org

## 1 Generate log files:

	 To generate the debug log files, Go to the log record detail page & click on the button "Generate Log File(s)" and after this under "Files" the debug file will be saved.
 ![image](https://github.com/nihal101/Logger/assets/46245110/5d003e26-29b8-4fcc-90eb-4b5a22fbfebc)

 ![image](https://github.com/nihal101/Logger/assets/46245110/d4aab057-df68-40de-8c11-48706a360318)

## 2 Live Streaming:

	To see the log entry live, use the following page. Go to the "Home" page -> "Live Stream" tab -> click on the button "Start"

 ![image](https://github.com/nihal101/Logger/assets/46245110/99567e6c-c2fa-413a-925f-1c90e4cea1a2)

 ![image](https://github.com/nihal101/Logger/assets/46245110/05529d19-7f97-48b4-9a82-c23e529cdb07)


## Salesforce DX Project: Next Steps

	Working on functionality to log the entry from the flow, process builder, and exception class.  


