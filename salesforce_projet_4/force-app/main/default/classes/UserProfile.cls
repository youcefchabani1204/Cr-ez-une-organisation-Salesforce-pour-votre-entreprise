public with sharing class UserProfile {
    @AuraEnabled(cacheable=true)

    public static Boolean CheckIfAdmin() {
        String userProfileName = [Select Name from Profile where Id =: UserInfo.getProfileId()].Name ;
                if (userProfileName=='System Administrator') 
                return true;
                else 
                return false;
           
   
        
            }
    }
