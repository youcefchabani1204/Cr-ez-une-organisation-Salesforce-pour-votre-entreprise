public with sharing class DeleteItem {
    @AuraEnabled
    public static void deleteProductById(Id productId){
       
            
            OpportunityLineItem oliToDelete = [SELECT Id FROM OpportunityLineItem WHERE Id = :productId LIMIT 1];
            delete oliToDelete;
       
}
}