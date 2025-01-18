public with sharing class OpportunityProductController {
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityProducts(Id opportunityId) {
    return OpportunityProductSelector.getOpportunityProductsById(opportunityId);
    }
}