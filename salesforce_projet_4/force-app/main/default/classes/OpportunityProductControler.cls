public with sharing class OpportunityProductControler {
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityProducts(Id opportunityId) {
    return OpportunityProductSelector.getOpportunityProductsById(opportunityId);
    }
}