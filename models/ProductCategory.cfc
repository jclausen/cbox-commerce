/**
* cboxCommerce default Product Category Object
*/
component   table="cbc_productCategories"
			extends="BaseCBCommerceEntity" 
			accessors="true"
			quick
{
    // Column Properties
	property name="name" type="string" default="";
	property name="description" type="string" default="";
	
	// Relationships
	function parent(){
		return belongsTo( "ProductCategory@cbc", "FK_parent");
	}

	function children(){
		return hasMany( "ProductCategory@cbc", "FK_parent" );
	}

	function products(){
		return belongsToMany( "Product@cbc", "cbc_lookups_products_categories", "FK_category",  "FK_product" );
	}

}