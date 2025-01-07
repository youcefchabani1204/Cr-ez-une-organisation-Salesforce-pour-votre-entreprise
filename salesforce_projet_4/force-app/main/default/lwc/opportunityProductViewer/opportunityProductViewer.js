import { LightningElement, api, wire, track } from 'lwc';
import  getOpportunityProducts from '@salesforce/apex/OpportunityProductController.getOpportunityProducts';
import CheckIfAdmin from '@salesforce/apex/UserProfile.CheckIfAdmin';
export default class OpportunityProductViewer extends LightningElement {
    @api recordId;
    @track products;
    @track ifProducts = false; 
    @track error = {};
   

    basecolumns = [
        { label: 'Nom du Produit', fieldName: 'productName', type: 'text' },
        { label: 'Quantité', fieldName: 'Quantity', type: 'Number' },
        { label: 'Prix Unitaire', fieldName: 'UnitPrice', type: 'Currency' },
        { label: 'Prix Total', fieldName: 'TotalPrice', type: 'Currency' },
        { label: 'Quantité en Stock', fieldName: 'quantityInStock', type: 'Number' },
        { label: 'Supprimer', type: 'button-icon', 
            typeAttributes: {
                iconName: 'utility:delete',
                name: 'delete_product',
                title: 'Supprimer',
                variant: 'border-filled'
            } }
    ];

    columnsAdmin = [
        { label: 'Voir Produit',type: 'button'  ,typeAttributes: {
            label: 'Voir Produit',
            name: 'view_product',
            iconName: 'utility:preview',
            title: 'Voir Produit',
            variant: 'brand'
            } }
    ];

    columns = [...this.basecolumns, ...this.columnsAdmin];

   async connectedCallback() {
    try{
      const isAdmin = await CheckIfAdmin();
        console.log('est ce que ca marche ' +isAdmin);

        if (isAdmin) {
            this.columns = [...this.basecolumns, ...this.columnsAdmin];
        } else {
            this.columns = [...this.basecolumns];
        }
    }
    catch(error){
    console.error('Erreur lors de la vérification du profil administrateur :', error,'est ce que ca marche ',isAdmin);
    

    }
    }
     
       
    
    @wire(getOpportunityProducts, { opportunityId: '$recordId' }) 
    wiredOpportunities({ error, data }) {
       

        if (data) {
            console.log('les données ',data);
            this.products = data.map(item => ({
                ...item,
                productName: item.Product2.Name, // Ajouter un champ à plat
                quantityInStock: item.Product2.QuantityInStock__c // Ajouter un champ à plat
                }));
            this.ifProducts =data.length>0;
            this.error=null;
        } else if (error) {
            this.error = error;
            this.products = undefined;
        }
    }
 
}