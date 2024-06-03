# Overview

	LogLinker is designed to work only with Apex and Salesforce users.

 # Method

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
 

## Salesforce DX Project: Next Steps

	Enable functionality to log the entry from the flow, process builder, and exception class.  

## Configure Logger in Salesforce Org

## Documentation


