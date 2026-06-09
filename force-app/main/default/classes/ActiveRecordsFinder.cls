/*********************************************************************************************************************
 * @Author: Suryakant
 * @Company: Salesforce
 * @Description: Class "ActiveRecordsFinder" Retrieves all active Accounts and Contacts
 *               and logs their details.
 *               Account uses picklist field Active__c = 'Active'.
 *               Contact uses boolean field vlocity_cmt__IsActive__c = true.
 * @Test class : ActiveRecordsFinderTest
 * @History:
 *   <Date>      <Authors Name>     <Brief Description of Change>
 *
 *********************************************************************************************************************/
public with sharing class ActiveRecordsFinder {

    /**
     * Entry point — fetches active Accounts and Contacts and logs each record.
     */
    public static void findActiveAccountsAndContacts() {
        List<Account> activeAccounts = fetchActiveAccounts();
        List<Contact> activeContacts = fetchActiveContacts();

        logAccounts(activeAccounts);
        logContacts(activeContacts);
    }

    /**
     * Queries all Account records where Active__c picklist equals 'Active'.
     * @return List of active Accounts ordered by Name.
     */
    @TestVisible
    private static List<Account> fetchActiveAccounts() {
        return [
            SELECT Id, Name, Type, Industry, Phone
            FROM Account
            WHERE Active__c = 'Active'
            ORDER BY Name
        ];
    }

    /**
     * Queries all Contact records where vlocity_cmt__IsActive__c is true.
     * @return List of active Contacts ordered by LastName then FirstName.
     */
    @TestVisible
    private static List<Contact> fetchActiveContacts() {
        return [
            SELECT Id, FirstName, LastName, Email, Phone, AccountId
            FROM Contact
            WHERE vlocity_cmt__IsActive__c = TRUE
            ORDER BY LastName, FirstName
        ];
    }

    /**
     * Logs details of each Account to the debug log.
     * @param activeAccounts List of active Account records to log.
     */
    private static void logAccounts(List<Account> activeAccounts) {
        System.debug('=== Active Accounts (' + activeAccounts.size() + ') ===');
        for (Account acc : activeAccounts) {
            System.debug(
                'Account Id: ' + acc.Id +
                ' | Name: ' + acc.Name +
                ' | Type: ' + acc.Type +
                ' | Industry: ' + acc.Industry
            );
        }
    }

    /**
     * Logs details of each Contact to the debug log.
     * @param activeContacts List of active Contact records to log.
     */
    private static void logContacts(List<Contact> activeContacts) {
        System.debug('=== Active Contacts (' + activeContacts.size() + ') ===');
        for (Contact con : activeContacts) {
            System.debug(
                'Contact Id: ' + con.Id +
                ' | Name: ' + con.FirstName + ' ' + con.LastName +
                ' | Email: ' + con.Email +
                ' | AccountId: ' + con.AccountId
            );
        }
    }
}
