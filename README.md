# LogLinker

**LogLinker** is a tool specifically designed to work with Apex, Flow, Processbuilder and Salesforce users, providing robust logging capabilities.

## Method: Apex

LogLinker supports two primary logging methods: `debug` and `error`.

### 1. `debug(String message)`

Logs a text message at a specific milestone during execution.

- **Example**: 
    ```apex
    Logger.debug('Debug 1');
    ```

### 2. `debug(String message, Id recordId)`

Logs a message associated with an sObject record by passing the sObject record ID (supports both standard and custom sObjects).

- **Example**: 
    ```apex
    Logger.debug('Debug 1', recordId);
    ```

### 3. `debug(String message, sObject sObj)`

Logs a message associated with an sObject record by passing the sObject reference (supports both standard and custom sObjects).

- **Example**:
    ```apex
    List<Account> accs = [SELECT Id FROM Account];
    Logger.debug('Debug 1', accs[0]);
    ```

### 4. `debug(String message, List<sObject> listOfSobj)`

Logs a message associated with each record in a collection (supports both standard and custom sObjects).

- **Example**:
    ```apex
    List<Account> accs = [SELECT Id FROM Account];
    Logger.debug('Debug 1', accs);
    ```

### 5. `debug(Exception ex)`

Logs an exception by creating a debug log entry with all related information.

- **Example**:
    ```apex
    try {
        Integer num = 26 / 0;
    } catch (Exception ex) {
        Logger.debug(ex);
        Logger.saveLog();
    }
    ```
  
**Note:** You can link a record to the log entry created from the exception using:
- `Logger.debug(ex, recordId);`
- `Logger.debug(ex, sObjectReference);`

### 6. `error(String message)`

Logs an error message.

- **Example**:
    ```apex
    Logger.error('Error 1');
    ```

### 7. `error(String message, Id recordId)`

Logs an error message associated with an sObject record by passing the sObject record ID (supports both standard and custom sObjects).

- **Example**:
    ```apex
    Logger.error('Error 1', recordId);
    ```

### 8. `error(String message, sObject sObj)`

Logs an error message associated with an sObject record by passing the sObject reference (supports both standard and custom sObjects).

- **Example**:
    ```apex
    List<Account> accs = [SELECT Id FROM Account];
    Logger.error('Error 1', accs[0]);
    ```

### 9. `error(String message, List<sObject> listOfSobj)`

Logs an error message associated with each record in a collection (supports both standard and custom sObjects).

- **Example**:
    ```apex
    List<Account> accs = [SELECT Id FROM Account];
    Logger.error('Error 1', accs);
    ```

### 10. `error(Exception ex)`

Logs an exception by creating an error log entry.

- **Example**:
    ```apex
    try {
        Integer num = 26 / 0;
    } catch (Exception ex) {
        Logger.error(ex);
        Logger.saveLog();
    }
    ```

**Note:** You can link a record to the log entry created from the exception using:
- `Logger.error(ex, recordId);`
- `Logger.error(ex, sObjectReference);`

Here's how to incorporate the `saveLog()` method into the documentation:

---

### 11. `saveLog()`

The `saveLog()` method finalizes and creates the log entries initiated by the logging methods mentioned above. It's crucial to ensure that `Logger.saveLog()` is executed successfully; otherwise, no log entry records will be created, even if the logging methods have been called.

- **Example**:
    ```apex
    Logger.debug('This is save');
    Logger.saveLog();
    ```

Make sure that `Logger.saveLog()` is always called after your logging operations to ensure that the log entries are properly recorded.

---

## Examples

### Example 1: Create a Simple Debug/Error Entry

```apex
Logger.debug('Debug 1');
Logger.error('Error 1');
Logger.saveLog();
```

### Example 2: Create an Entry Related to a Record

```apex
List<Account> accs = [SELECT Id FROM Account];
Logger.debug('Record Id', accs[0].Id);
Logger.debug('Reference', accs[0]);
Logger.debug('List', accs);
Logger.saveLog();
```

### Example 3: Apex Class Example

```apex
public class ValidateNewAccount {
    public static Boolean isValidAccount(Account newAccount) {
        Boolean isSuccess = true;
        try {
            if (newAccount.Name.contains('Test')) {
                Logger.error('Account name can\'t contain \'Test\' keyword', newAccount);
                isSuccess = false;
            }
            if (newAccount.BillingAddress == null) {
                Logger.error('Account billing address can\'t be empty', newAccount);
                isSuccess = false;
            }
            return isSuccess;
        } catch (Exception ex) {
            Logger.error(ex.getMessage(), newAccount);
            isSuccess = false;
        } finally {
            Logger.saveLog();
        }
        return isSuccess;
    }
}
```

### Example 4: Set Parent Log (Asynchronous Apex)

```apex
public class CaseRetentionBatch implements Database.Batchable<sObject>, Database.Stateful {

    String parentTransactionId = '';

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Logger.debug('Running SOQL to get all one-year case records');
        parentTransactionId = Logger.getTransactionId();
        Logger.saveLog();
        return Database.getQueryLocator([SELECT Id FROM Case WHERE CreatedDate <= NEXT_N_YEARS:1]);
    }

    public void execute(Database.BatchableContext bc, List<Case> cases) {
        try {
            delete cases;
            Logger.debug('Deleted the case record: ' + cases.size());
            Logger.setParentTransactionId(parentTransactionId);
            Logger.saveLog();
        } catch (Exception ex) {
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
```

---

## Configuration in Salesforce Org

### 1. Generate Log Files

To generate debug log files:
1. Go to the log record detail page.
2. Click on the button **"Generate Log File(s)"**.
3. The debug file will be saved under **"Files"**.

![image](https://github.com/nihal101/Logger/assets/46245110/5d003e26-29b8-4fcc-90eb-4b5a22fbfebc)

![image](https://github.com/nihal101/Logger/assets/46245110/d4aab057-df68-40de-8c11-48706a360318)

### 2. Live Streaming

To view log entries live:
1. Go to the **"Home"** page.
2. Navigate to the **"Live Stream"** tab.
3. Click on the button **"Start"**.

![image](https://github.com/nihal101/Logger/assets/46245110/99567e6c-c2fa-413a-925f-1c90e4cea1a2)

![image](https://github.com/nihal101/Logger/assets/46245110/05529d19-7f97-48b4-9a82-c23e529cdb07)

#### 1. Filter Options

LogLinker provides the following filter options to refine log entries:

1. **Logged By**: Select the user who executed the class or flow.
2. **Origin Location**: Enter the class name or method from entry has been created.
3. **Logging Level**: Choose the level of logs to display - 'All', 'DEBUG', 'ERROR', or 'EXCEPTION'.
4. **Message Contains**: Search for specific keywords within the log messages.

---

### 3. See Transaction Metrics

On the log record detail page, navigate to the "Governor Limits" tab to view all utilized Apex limits.

![image](https://github.com/user-attachments/assets/6d3c124a-d884-45b1-9db0-adaaf3b2fa70)

---

## Salesforce DX Project: Next Steps

- Batch to delete the log entry record.

---

This format provides a cleaner and more structured way to document your LogLinker tool, making it easier for users to understand and implement.
