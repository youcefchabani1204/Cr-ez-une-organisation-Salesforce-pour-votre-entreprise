@IsTest
private class DeleteItemTest {
    
    @IsTest
    static void testDeleteProductById() {
        // 1. Création des données de test
        TestDatasFactory.createTestProduct();      // Crée un produit
        TestDatasFactory.createTestPricebook();    // Crée une entrée dans le pricebook
        TestDatasFactory.createTestOpportunity();  // Crée une opportunité
        
        // 2. On crée un OpportunityLineItem
        TestDatasFactory.createTestOpportunityLineItem();
        
        // 3. Récupération de l’OpportunityLineItem inséré
        OpportunityLineItem oli = [SELECT Id FROM OpportunityLineItem LIMIT 1];

        // 4. Appel de la méthode à tester
        
        DeleteItem.deleteProductById(oli.Id);
        

        // 5. Vérification que l'OLI a bien été supprimé
        System.assertEquals(0, [SELECT COUNT() FROM OpportunityLineItem WHERE Id = :oli.Id]);
    }
}