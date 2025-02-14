public with sharing class UserProfile {
    @AuraEnabled(cacheable=true)
    public static Boolean CheckIfAdmin() {
        // Récupérer l'utilisateur courant avec son profil
        User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        // Comparer le nom du profil avec 'System Administrator'
        return currentUser.Profile.Name == 'System Administrator' || currentUser.Profile.Name == 'Administrateur système' ;
    }
}