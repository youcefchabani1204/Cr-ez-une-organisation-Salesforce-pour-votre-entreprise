import { LightningElement, api, wire, track } from 'lwc';
import  getOpportunityProducts from '@salesforce/apex/OpportunityProductController.getOpportunityProducts';
import CheckIfAdmin from '@salesforce/apex/UserProfile.CheckIfAdmin';
import deleteProductById from '@salesforce/apex/DeleteItem.deleteProductById';
import { NavigationMixin } from 'lightning/navigation';

export default class OpportunityProductViewer extends NavigationMixin(LightningElement) {
    @api recordId;
    @track products;
    @track ifProducts = false;  
    @track error = {};
   

    basecolumns = [
        { label: 'Nom du Produit', fieldName: 'productName', type: 'text' },
        { label: 'Quantité', fieldName: 'Quantity', type: 'Number' , cellAttributes: {
           class: { fieldName: 'quantityColor' } // Applique une classe basée sur la donnée
        } },
        { label: 'Prix Unitaire', fieldName: 'UnitPrice', type: 'Currency' },
        { label: 'Prix Total', fieldName: 'TotalPrice', type: 'Currency' },
        { label: 'Quantité en Stock', fieldName: 'quantityInStock', type: 'Number' },
        {
            label: 'Supprimer',
            type: 'button-icon',
            typeAttributes: {
                iconName: 'utility:delete',
                name: 'delete_product',
                title: 'Supprimer',
                variant: 'border-filled',
                iconPosition: 'left',
                label: 'Supprimer',
            }
        }
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
    

    handleRowAction(event) {

        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'delete_product') {
            this.deleteProduct(row.Id); // Appeler la méthode pour supprimer
        }
       else if(actionName=='view_product'){
            this.viewProduct(row.Id);

        }
        
    }
    async deleteProduct(productId) {
        try {
            await deleteProductById({ productId }); // Appeler Apex
            this.products = this.products.filter(product => product.Id !== productId); // Mettre à jour le tableau
        } catch (error) {
            console.error('Erreur lors de la suppression du produit : ', error);
        }
    }
     viewProduct(productId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: productId,
                objectApiName: 'OpportunityLineItem', // Nom de l'objet
                actionName: 'view',
            },
        });
    }
    
    @wire(getOpportunityProducts, { opportunityId: '$recordId' }) 
    wiredOpportunities({ error, data }) {
       

        if (data) {
            console.log('les données ',data);
            
            this.products = data.map(item => ({
                ...item,
                productName: item.Product2.Name, // Ajouter un champ à plat
                quantityInStock: item.Product2.QuantityInStock__c, // Ajouter un champ à plat
                
                quantityColor: item.Quantity < item.Product2.QuantityInStock__c  ? 'slds-text-color_error':'slds-text-color_success'

                }));
             //   console.log('quantite mois quantie en stock ',(item.Quantity-item.Product2.QuantityInStock__c));
            this.ifProducts =data.length>0;
            this.error=null;
        } else if (error) {
            this.error = error;
            this.products = undefined;
        }
    }
    
    }
