public class AwesomeProductController {  
    @AuraEnabled
    public static List<Product__c> getProducts() {
    	//Test Message for @ Git
    	//Test Message for @ Git 1
    	//Test Message for @ Git 3
    	//Test Message for @ Git 4k-1222_Release 3.0
        return [select id, name, photo__c, description__c, points__c from product__c];
    }

    @AuraEnabled
    public static Product__c getProductByName(String name) {
        return [select id, name, photo__c, color__c,
                points__c, description__c,
                (select name from product_sizes__r order by name)
                from product__c where name = :name];
    }
}