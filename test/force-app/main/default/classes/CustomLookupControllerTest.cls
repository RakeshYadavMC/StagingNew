@isTest
public class CustomLookupControllerTest {

    @testSetup static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'beamtu', Email = 'standarduser@testorg.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Chicago', UserName = 'beamsuntorytestuser@test-user-system.com.test-only');
        insert u;

        Account acct = new Account();
        acct.Name = 'Test Account';
        acct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').getRecordTypeId();

        Account offPremiseAccount = new Account();
        offPremiseAccount.Name = 'Test Off Premise';
        offPremiseAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('OffPremise').getRecordTypeId();

        Account distAccount = new Account();
        distAccount.Name = 'Test Dist';
        distAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Distributor').getRecordTypeId();

        insert new List<Account> {acct, offPremiseAccount, distAccount};

        Contact c = new Contact();
        c.AccountId = distAccount.Id;
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        insert c;
        
        //insert Vendor Account for PR Header
        Account objVendorAccount = new Account();
        objVendorAccount.Name = 'Test Vendor Account';
        objVendorAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Vendor').getRecordTypeId();
        insert objVendorAccount;
        
        //insert SAP Company Code for PR Header
        SAP_Company_Code__c sapCode = new SAP_Company_Code__c();
        sapCode.Name = 'Test SAP Code';
        sapCode.Status__c = 'Active';
        sapCode.VendorCompanycodeKey__c = 'TestSapCodeExternalId';
        sapCode.Account__c = objVendorAccount.Id;
        insert sapCode;
        
        //insert PR Header Record
        PR_Header__c prHeader = new PR_Header__c();
        prHeader.Vendor_Name__c = objVendorAccount.Id;
        prHeader.SAP_Company_Code__c = sapCode.Id;
        prHeader.Payment_Terms__c = 'Standard Terms';
        prHeader.PR_Currency__c = 'USD';
        prHeader.Request_Date__c = Date.today();
        prHeader.SAP_Support__c = 'XHPOTRU';
        insert prHeader; 
    }

    public static List<Account> getAccountByName(String name) {
        return [select id, Name from Account where Name = :name];
    }

    public static testMethod void testLookingUpAccount() {
        Test.startTest();

        List<Account> accounts = CustomLookupController.fetchLookUpValues('Test Acco', 'Account');

        Test.stopTest();

        System.assertEquals(1, accounts.size());
        System.assertEquals('Test Account', accounts[0].Name);
    }

    public static testMethod void testGetBaseUrl() {
        Test.startTest();

        String baseUrl = CustomLookupController.getEnvironmentUrl();

        Test.stopTest();

        System.assertNotEquals(NULL, baseUrl);
    }


    public static testMethod void getDistributorRecordTypeTest() {
        Test.startTest();

        List<Account> accounts = CustomLookupController.getDistributorRecordType('Test D', 'Account', 10);

        Test.stopTest();

        System.assertEquals(1, accounts.size());
        System.assertEquals('Test Dist', accounts[0].Name);
    }

    public static testMethod void getPremiseRecordTypeTest() {
        Test.startTest();

        List<Account> accounts = CustomLookupController.getPremiseRecordType('Test Off', 'Account', 10);

        Test.stopTest();

        System.assertEquals(1, accounts.size());
        System.assertEquals('Test Off Premise', accounts[0].Name);
    }

    public static testMethod void getDistributorContactForAccountTest() {
        List<Account> a = getAccountByName('Test Dist');
        Test.startTest();

        List<Contact> contacts = CustomLookupController.getDistributorContactForAccount('Test', 'Contact', Id.valueOf(a[0].Id));

        Test.stopTest();

        System.assertEquals(1, contacts.size());
        System.assertEquals('Test Contact', contacts[0].Name);
    }
    
    public static testMethod void testGetSAPCompanyForVendorAccount() {
        Account acc = [select Id, Name from Account where Name = 'Test Vendor Account'];
        test.startTest();
        List <SAP_Company_Code__c> sapList = CustomLookupController.getSAPCompanyForVendorAccount(acc.Id);
        test.stopTest();
        System.assert(sapList.size()>0, 'Account should have atleast one SAP Company Code');
    }
	
    public static testMethod void testgetAccountAndSAPCompanyCodeDetails() {
        PR_Header__c objPRHeader = [Select Id From PR_Header__c Where Vendor_Name__r.Name = 'Test Vendor Account'];
        test.startTest();
        Map<String, Object> returnMap = CustomLookupController.getAccountAndSAPCompanyCodeDetails(objPRHeader.Id);
        test.stopTest();
        System.assert(returnMap.size()>0,'PR Header Record should have Vendor & SAP Company Code');
    }
    
    public static testMethod void testUpdatePRHeader() {
        PR_Header__c objPRHeader = [Select Id, Vendor_Name__c, SAP_Company_Code__c, Payment_Terms__c, PR_Currency__c,
                                   Request_Date__c, SAP_Support__c From PR_Header__c Where Vendor_Name__r.Name = 'Test Vendor Account' Limit 1];
        String jsonPRHeader = '[{"Id":"' + objPRHeader.Id + '",'
		                   	+ '"Vendor_Name__c" : "' + objPRHeader.Vendor_Name__c + '",'
		                   	+ '"SAP_Company_Code__c" : "' + objPRHeader.SAP_Company_Code__c + '",'
            			   	+ '"Payment_Terms__c" : "' + objPRHeader.Payment_Terms__c + '",'
            				+ '"PR_Currency__c" : "' + objPRHeader.PR_Currency__c + '",'
            				+ '"Request_Date__c" : "2019-12-26",'
            				+ '"SAP_Support__c" : "' + objPRHeader.SAP_Support__c +'"}]';
        test.startTest();
        String retString = CustomLookupController.updatePRHeader(jsonPRHeader);
        test.stopTest();
        System.assert(retString.length()>0, 'PR Record Saved Successfully');
    }
    
    public static testMethod void testGetMyAccounts() {
        Account acc = [select Id, Name from Account where Name = 'Test Vendor Account'];
        test.startTest();
        List <Account> sapList = CustomLookupController.getMyAccounts('test', 'Account', acc.Id);
        test.stopTest();
    }
    
}