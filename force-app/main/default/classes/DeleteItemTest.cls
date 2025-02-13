@IsTest
private class DeleteItemTest {
    
    @IsTest
    static void testDeleteProductById() {
        // 1. Création des données de test
        Product2 testProduct = TestDatasFactory.createTestProduct();              // Crée un produit
        Id pricebookId = TestDatasFactory.createTestPricebook();                 // Récupère le Pricebook standard
        PricebookEntry pricebookEntryTest = TestDatasFactory.createTestPriceBookEntry(testProduct, pricebookId); // Crée une entrée de Pricebook
        
        Opportunity oppTest = TestDatasFactory.createTestOpportunity(pricebookId); // Crée une opportunité liée au Pricebook
        
        // 2. Création d'un OpportunityLineItem
        OpportunityLineItem oliTest = TestDatasFactory.createTestOpportunityLineItem(oppTest, pricebookEntryTest); 

        // 3. Récupération de l’OpportunityLineItem inséré
        OpportunityLineItem oli = [SELECT Id FROM OpportunityLineItem LIMIT 1];

        // 4. Appel de la méthode à tester
        DeleteItem.deleteProductById(oli.Id);

        // 5. Vérification que l'OpportunityLineItem a bien été supprimé
        System.assertEquals(0, [SELECT COUNT() FROM OpportunityLineItem WHERE Id = :oli.Id]);
    }
}