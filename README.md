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

## Salesforce DX Project: Next Steps

	Will enable the log entry functionality from the flow.  

## Configure Logger in Salesforce Org

## Documentation


