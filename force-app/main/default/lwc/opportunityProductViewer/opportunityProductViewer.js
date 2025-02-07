import { LightningElement, api, wire, track } from 'lwc';
import  getOpportunityProducts from '@salesforce/apex/OpportunityProductController.getOpportunityProducts';
import CheckIfAdmin from '@salesforce/apex/UserProfile.CheckIfAdmin';
import deleteProductById from '@salesforce/apex/DeleteItem.deleteProductById';
import { NavigationMixin } from 'lightning/navigation';
import PRODUCT_NAME from '@salesforce/label/c.Product_Name';
import QUANTITY from '@salesforce/label/c.Quantity';
import UNIT_PRICE from '@salesforce/label/c.Unit_Price';
import TOTAL_PRICE from '@salesforce/label/c.Total_Price';
import QUANTITY_IN_STOCK from '@salesforce/label/c.Quantity_In_Stock';
import DELETE from '@salesforce/label/c.Delete';
import See_Product from '@salesforce/label/c.See_Product';
import Quantity_Problem_Message from '@salesforce/label/c.Quantity_Problem_Message';
import NO_PRODUCT_LINES from '@salesforce/label/c.No_Product_Lines';
import Opportunity_Products from '@salesforce/label/c.Opportunity_Products';
import Opportunity_Update_Problem from '@salesforce/label/c.Opportunity_Update_Problem';


export default class OpportunityProductViewer extends NavigationMixin(LightningElement) {
    labels = {
        productName: PRODUCT_NAME,
        quantity: QUANTITY,
        unitPrice: UNIT_PRICE,
        totalPrice: TOTAL_PRICE,
        quantityInStock: QUANTITY_IN_STOCK,
        delete: DELETE,
         quantityProblemMessage:Quantity_Problem_Message,
        noProductLines: NO_PRODUCT_LINES,
        seeProduct: See_Product,
        addProducts: Opportunity_Products,
        updateProblem: Opportunity_Update_Problem,
    };

    @api recordId;
    @track products;
    @track ifProducts = false;  
    @track ifNegative = false;
    @track error = {};
   

    basecolumns = [
        { label:this.labels.productName, fieldName: 'productName', type: 'text' },
        { label: this.labels.quantity, fieldName: 'Quantity', type: 'Number' , cellAttributes: {
           class: { fieldName: 'quantityColor' } // Applique une classe basée sur la donnée
        } },
        { label:this.labels.unitPrice, fieldName: 'UnitPrice', type: 'Currency' },
        { label: this.labels.totalPrice, fieldName: 'TotalPrice', type: 'Currency' },
        { label: this.labels.quantityInStock, fieldName: 'quantityInStock', type: 'Number' },
        {
            label: this.labels.delete,
            type: 'button-icon',
            typeAttributes: {
                iconName: 'utility:delete',
                name: 'delete_product',
                title: this.labels.delete,
                variant: 'border-filled',
                iconPosition: 'left',
                label: this.labels.delete,
            }
        }
    ];

    columnsAdmin = [
        { label: this.labels.seeProduct,type: 'button'  ,typeAttributes: {
            label:this.labels.seeProduct,
            name: 'view_product',
            iconName: 'utility:preview',
            title: this.labels.seeProduct,
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
            
            this.products = data.map(item => ({
                ...item,
                productName: item.Product2.Name, // Ajouter un champ à plat
                quantityInStock: item.Product2.QuantityInStock__c, // Ajouter un champ à plat
                quantityColor: item.Quantity < item.Product2.QuantityInStock__c  ? 'slds-text-color_error':'slds-text-color_success',

                }));
            this.ifNegative = this.products.some(product => product.Quantity < product.Product2.QuantityInStock__c);
            this.ifProducts =data.length>0;
            this.error=null;
        } else if (error) {
            this.error = error;
            this.products = undefined;
        }
    }
    
    }
