public with sharing class DeleteItem {
    @AuraEnabled
    public static void deleteProductById(Id productId){
        try {
            
            OpportunityLineItem oliToDelete = [SELECT Id FROM OpportunityLineItem WHERE Id = :productId LIMIT 1];
            delete oliToDelete;
        }
        catch(DMLException dmle){
            System.debug('La suppression du produit a échoué : ' + dmle.getMessage());
            
            throw new AuraHandledException('Erreur lors de la suppression du produit.');
        }
    }
}