
@isTest
private class OpportunityProductControllerTest {

    @isTest
    public static void testGetOpportunityProducts() {
        Product2 testProduct = TestDatasFactory.createTestProduct();
        Id pricebookid = TestDatasFactory.createTestPricebook();
        PriceBookEntry pricebookEntry = TestDatasFactory.createTestPriceBookEntry(testProduct, pricebookid);
        Opportunity opp = TestDatasFactory.createTestOpportunity(pricebookid);
        OpportunityLineItem oli = TestDatasFactory.createTestOpportunityLineItem(opp, pricebookEntry);

        oli = [SELECT Id, Product2Id, Quantity, UnitPrice FROM OpportunityLineItem WHERE Id = :oli.Id LIMIT 1];

        List<OpportunityLineItem> oliList = OpportunityProductController.getOpportunityProducts(opp.Id);

        System.assertNotEquals(0, oliList.size(), 'La liste des lignes de produits ne doit pas être vide.');
        System.assertEquals(oli.Product2Id, oliList[0].Product2Id, 'L\'ID du produit doit correspondre.');
        System.assertEquals(oli.Quantity, oliList[0].Quantity, 'La quantité doit correspondre.');
        System.assertEquals(oli.UnitPrice, oliList[0].UnitPrice, 'Le prix unitaire doit correspondre.');
    }
}
