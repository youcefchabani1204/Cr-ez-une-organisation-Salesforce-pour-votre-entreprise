@isTest
public class TestDatasFactory {
    
    public static Product2 createTestProduct(){
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            ProductCode = 'TEST01', 
            Family = 'Test'
        );
        insert testProduct; // ⚠️ Insérer en base pour pouvoir l’utiliser
        return testProduct;
    }

    public static Id createTestPricebook(){
        Id pricebookId = Test.getStandardPricebookId(); // Récupère le PriceBook standard
        return pricebookId;
    }

    public static PricebookEntry createTestPriceBookEntry(Product2 testProduct, Id pricebookId){
        PricebookEntry pricebookEntryTest = new PricebookEntry(
            Product2Id = testProduct.Id,
            Pricebook2Id = pricebookId,
            UnitPrice = 100, // ⚠️ Nécessaire, sinon l’OpportunityLineItem ne fonctionnera pas
            IsActive = true
        );
        insert pricebookEntryTest; // ⚠️ Insérer en base
        return pricebookEntryTest;
    }

    public static Opportunity createTestOpportunity(Id pricebookId){
        Opportunity oppTest = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting', 
            CloseDate = Date.today().addDays(10), 
            Pricebook2Id = pricebookId
        );
        insert oppTest; // ⚠️ Insérer en base
        return oppTest;
    }

    public static OpportunityLineItem createTestOpportunityLineItem(Opportunity oppTest, PricebookEntry pricebookEntryTest){
        OpportunityLineItem opportunityLineItemTest = new OpportunityLineItem(
            OpportunityId = oppTest.Id, 
            Quantity = 10, 
            TotalPrice = 300,
            PricebookEntryId = pricebookEntryTest.Id // ⚠️ Utilise le PriceBookEntry correct
        );
        insert opportunityLineItemTest; // ⚠️ Insérer en base
        return opportunityLineItemTest;
    }
}