/*********************************************************************************************************************
 * @Author: Suryakant
 * @Company: Salesforce
 * @Description: Class "ActiveRecordsFinderTest" Test class for ActiveRecordsFinder.
 *               Covers positive and negative scenarios for fetching active Accounts and Contacts.
 * @Test class : N/A (this is the test class)
 * @History:
 *   <Date>      <Authors Name>     <Brief Description of Change>
 *
 *********************************************************************************************************************/
@IsTest
private class ActiveRecordsFinderTest {

    /**
     * Sets up test data: one active Account, one inactive Account,
     * one active Contact, and one inactive Contact.
     */
    @TestSetup
    static void setupTestData() {
        Account activeAccount = new Account(Name = 'Active Account', Active__c = 'Active');
        Account inactiveAccount = new Account(Name = 'Inactive Account', Active__c = 'Inactive');
        insert new List<Account>{ activeAccount, inactiveAccount };

        Contact activeContact = new Contact(
            FirstName = 'Active',
            LastName = 'Contact',
            Email = 'active@test.com',
            vlocity_cmt__IsActive__c = true,
            AccountId = activeAccount.Id
        );
        Contact inactiveContact = new Contact(
            FirstName = 'Inactive',
            LastName = 'Contact',
            Email = 'inactive@test.com',
            vlocity_cmt__IsActive__c = false,
            AccountId = inactiveAccount.Id
        );
        insert new List<Contact>{ activeContact, inactiveContact };
    }

    /**
     * Positive: fetchActiveAccounts should return only accounts where Active__c = 'Active'.
     */
    @IsTest
    static void testFetchActiveAccounts_returnsOnlyActiveAccounts() {
        Test.startTest();
        List<Account> result = ActiveRecordsFinder.fetchActiveAccounts();
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Should return exactly one active account');
        System.assertEquals('Active Account', result[0].Name, 'Returned account name should match');
    }

    /**
     * Negative: fetchActiveAccounts should return empty list when no active accounts exist.
     */
    @IsTest
    static void testFetchActiveAccounts_returnsEmptyWhenNoneActive() {
        Account acc = [SELECT Id FROM Account WHERE Active__c = 'Active' LIMIT 1];
        acc.Active__c = 'Inactive';
        update acc;

        Test.startTest();
        List<Account> result = ActiveRecordsFinder.fetchActiveAccounts();
        Test.stopTest();

        System.assertEquals(0, result.size(), 'Should return empty list when no active accounts exist');
    }

    /**
     * Positive: fetchActiveContacts should return only contacts where vlocity_cmt__IsActive__c = true.
     */
    @IsTest
    static void testFetchActiveContacts_returnsOnlyActiveContacts() {
        Test.startTest();
        List<Contact> result = ActiveRecordsFinder.fetchActiveContacts();
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Should return exactly one active contact');
        System.assertEquals('Active', result[0].FirstName, 'Returned contact first name should match');
    }

    /**
     * Negative: fetchActiveContacts should return empty list when no active contacts exist.
     */
    @IsTest
    static void testFetchActiveContacts_returnsEmptyWhenNoneActive() {
        Contact con = [SELECT Id FROM Contact WHERE vlocity_cmt__IsActive__c = TRUE LIMIT 1];
        con.vlocity_cmt__IsActive__c = false;
        update con;

        Test.startTest();
        List<Contact> result = ActiveRecordsFinder.fetchActiveContacts();
        Test.stopTest();

        System.assertEquals(0, result.size(), 'Should return empty list when no active contacts exist');
    }

    /**
     * Positive: findActiveAccountsAndContacts should execute without exceptions.
     */
    @IsTest
    static void testFindActiveAccountsAndContacts_executesSuccessfully() {
        Test.startTest();
        try {
            ActiveRecordsFinder.findActiveAccountsAndContacts();
            System.assert(true, 'Method should complete without exception');
        } catch (Exception ex) {
            System.assert(false, 'Unexpected exception: ' + ex.getMessage());
        }
        Test.stopTest();
    }
}
