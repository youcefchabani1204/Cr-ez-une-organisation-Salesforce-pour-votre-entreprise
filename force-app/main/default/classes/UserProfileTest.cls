@isTest
public class UserProfileTest {
    
    @isTest
    public static void testCheckIfAdmin() {
        // Créer un utilisateur de test avec le profil "System Administrator"
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

        User testUser = new User(
            FirstName = 'Test',
            LastName = 'Admin',
            Email = 'testadmin@example.com',
            Username = 'testadmin@example.com' + System.currentTimeMillis(),
            Alias = 'tadmin',
            TimeZoneSidKey = 'Europe/Paris',
            LocaleSidKey = 'fr_FR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'fr',
            ProfileId = adminProfile.Id
        );
        insert testUser;

        // Simuler l'exécution de la méthode avec l'utilisateur de test
        System.runAs(testUser) {
            Boolean isAdmin = UserProfile.CheckIfAdmin();
            System.assertEquals(true, isAdmin, 'L\'utilisateur devrait être administrateur.');
        }
    }

    @isTest
    public static void testCheckIfNotAdmin() {
        // Créer un utilisateur de test avec un autre profil (ex: Standard User)
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'Europe/Paris',
            LocaleSidKey = 'fr_FR',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'fr',
            ProfileId = standardProfile.Id
        );
        insert testUser;

        // Simuler l'exécution de la méthode avec l'utilisateur de test
        System.runAs(testUser) {
            Boolean isAdmin = UserProfile.CheckIfAdmin();
            System.assertEquals(false, isAdmin, 'L\'utilisateur ne devrait pas être administrateur.');
        }
    }
}