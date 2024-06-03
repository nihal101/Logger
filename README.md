# Overview

	LogLinker is designed to work only with Apex and Salesforce users.

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
 

## Salesforce DX Project: Next Steps

	Will enable the log entry functionality from the flow and process builder.  

## Configure Logger in Salesforce Org

## Documentation


