
@isTest
public class OpportunityProductSelectorTest {

    @isTest
    public static void testGetOpportunityProductsById() {
        // Créer les données de test
        Product2 testProduct = TestDatasFactory.createTestProduct();
        Id pricebookid = TestDatasFactory.createTestPricebook();
        PriceBookEntry pricebookEntry = TestDatasFactory.createTestPriceBookEntry(testProduct, pricebookid);
        Opportunity opp = TestDatasFactory.createTestOpportunity(pricebookid);
        OpportunityLineItem oli = TestDatasFactory.createTestOpportunityLineItem(opp, pricebookEntry);

        // Appeler la méthode à tester
        Test.startTest();
        List<OpportunityLineItem> oliList = OpportunityProductSelector.getOpportunityProductsById(opp.Id);
        Test.stopTest();

        // Vérification des résultats
        System.assertNotEquals(0, oliList.size(), 'La liste des lignes de produits ne doit pas être vide.');
        System.assertEquals(oli.Product2Id, oliList[0].Product2Id, 'L\'ID du produit doit correspondre.');
        System.assertEquals(oli.Quantity, oliList[0].Quantity, 'La quantité doit correspondre.');
        System.assertEquals(oli.UnitPrice, oliList[0].UnitPrice, 'Le prix unitaire doit correspondre.');
    }
}

