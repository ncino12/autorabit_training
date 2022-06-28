import { LightningElement,api,wire,track} from 'lwc';
import { getRecord,getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {loadStyle} from 'lightning/platformResourceLoader';

import productListForLoan from '@salesforce/resourceUrl/productListForLoan'
import fetchProductDetials from '@salesforce/apex/productDetailsFetch.fetchProductDetials';
import updateProductRecord from '@salesforce/apex/productDetailsFetch.updateProductRecord';



export default class ProductListForLoan extends LightningElement {
    @api recordId;
    loading=false;
    columns =[
        {
            label: 'Product',
            fieldName: 'productUrl',
            type: 'url',
            typeAttributes: {
                label: {
                    fieldName: 'Name'
                }
            }
        },
        {
            label: 'Product ID',
            fieldName: 'Product_ID__c',
            type: 'text',
            sortable: true
        },
        /*{
            label: 'Product Type',
            fieldName: 'LLC_BI__Product_Type__r.Name',
            type: 'text',
            sortable: true
        },
        {
            label: 'Product Line',
            fieldName: 'LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.Name',
            type: 'text',
            sortable: true
        },*/
        {
            label: 'Description',
            fieldName: 'Description__c',
            type: 'text',
            sortable: true,
            wrapText:true,
            cellAttributes:{
                width : '100%' ,
                wordWrap :'break-word',
                
            }
        },
        /*{
            label: 'Product ID',
            fieldName: 'Product_ID__c',
            type: 'text',
            sortable: true
        },*/
        
    ]
    @track productList;
    error;
    isCssLoaded = false;
    isProductListLoaded = false;

    renderedCallback(){
        if(this.isProductListLoaded) return;
        this.isProductListLoaded = true;
        fetchProductDetials({loanId:this.recordId}).then((data)=>{
            if(data){
                       // this.productList=data;
                       // window.console.log('data',data);
                       this.productList = data.map(
                           record => Object.assign(
                               {"LLC_BI__Product_Type__r.Name":record.LLC_BI__Product_Type__r.Name,
                            "LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.Name":record.LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.Name},
                            record
                           )
                       );
            
                       if(this.productList){
                           this.productList.forEach(item => item['productUrl']='/lightning/r/Account/' +item['Id'] +'/view')
                          
                       }
                    }
        }).catch((error)=>{
            this.error= error;
            window.console.log('error',error);
        })

        window.console.log('yes everytime');
        if(this.isCssLoaded) return;
        this.isCssLoaded = true;
        loadStyle(this, productListForLoan).then(()=>{
            window.console.log("Loaded Successfully")
        }).catch(error=>{ 
            window.console.error("Error in loading the colors")
        })
    }
    
    // @wire(fetchProductDetials,{loanId:'$recordId'})
    // wireRecords({error,data}){
    //     if(data){
    //        // this.productList=data;
    //        // window.console.log('data',data);
    //        this.productList = data.map(
    //            record => Object.assign(
    //                {"LLC_BI__Product_Type__r.Name":record.LLC_BI__Product_Type__r.Name,
    //             "LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.Name":record.LLC_BI__Product_Type__r.LLC_BI__Product_Line__r.Name},
    //             record
    //            )
    //        );

    //        if(this.productList){
    //            this.productList.forEach(item => item['productUrl']='/lightning/r/Account/' +item['Id'] +'/view')
              
    //        }
    //     }else if(error){
    //         this.error=error;
    //         window.console.log('error',error);
    //     }
    // }

    getSelectedRows(){
    var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
    if(selectedRecords.length>1){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'You have selected more than one record.Please select only one.',
                variant: 'error',
            })
        );
    }else if(selectedRecords.length==0){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: 'Please select a row.',
                variant: 'error',
            })
        );
    }else if(selectedRecords.length==1){
        this.loading=true;
        window.console.log(selectedRecords[0].Id);
        updateProductRecord({loanId:this.recordId,productId:selectedRecords[0].Id}).then((result)=>{
            this.loading=false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Product has been successfully updated',
                    variant: 'success',
                })
            );
            window.console.log(result);
        })
        .catch((error)=>{
            window.console.log(error);
        })
    }
    window.console.log(selectedRecords);
    }

    // renderedCallback(){ 
    //     window.console.log('yes everytime');
    //     if(this.isCssLoaded) return;
    //     this.isCssLoaded = true;
    //     loadStyle(this, productListForLoan).then(()=>{
    //         window.console.log("Loaded Successfully")
    //     }).catch(error=>{ 
    //         window.console.error("Error in loading the colors")
    //     })
    // }


}