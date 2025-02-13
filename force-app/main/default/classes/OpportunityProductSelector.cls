public with sharing class OpportunityProductSelector {
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityProductsById(Id opportunityId) {
        
        return 
        [SELECT Id ,
        Product2Id,
        Product2.Name , 
        TotalPrice ,
        Product2.QuantityInStock__c ,
        Quantity ,
        UnitPrice
        FROM OpportunityLineItem 
        WHERE OpportunityId =: opportunityId];
        
    }
    
}