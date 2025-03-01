@isTest
public class UserProfileTest {

    @isTest
    public static void testCheckIfAdmin() {
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name IN ('System Administrator', 'Administrateur système') LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'Admin',
            Email = 'testadmin@example.com',
            Username = 'testadmin' + System.currentTimeMillis() + '@example.com',
            Alias = 'tadmin',
            TimeZoneSidKey = 'Europe/Paris',
            LocaleSidKey = 'fr_FR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'fr',
            ProfileId = adminProfile.Id,
            IsActive = true
        );
        insert testUser;  // Insérer l'utilisateur avant le runAs()

        // Attendre la fin des opérations asynchrones (évite les problèmes de transaction)
        Test.startTest();
        System.runAs(testUser) {
            Boolean isAdmin = UserProfile.CheckIfAdmin();
            System.assertEquals(true, isAdmin, 'L\'utilisateur devrait être administrateur.');
        }
    }

    @isTest
    public static void testCheckIfNotAdmin() {
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name IN ('Standard User','Commercial') LIMIT 1];

        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'Europe/Paris',
            LocaleSidKey = 'fr_FR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'fr',
            ProfileId = standardProfile.Id,
            IsActive = true
        );
        insert testUser;

        Test.startTest();
        System.runAs(testUser) {
            Boolean isAdmin = UserProfile.CheckIfAdmin();
            System.assertEquals(false, isAdmin, 'L\'utilisateur ne devrait pas être administrateur.');
        }
    }
}