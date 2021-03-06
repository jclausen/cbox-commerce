/**
* cboxCommerce default Product Category Object
*/
component   table="cbc_productSKUMedia"  
			extends="BaseCBCommerceEntity"
			accessors="true"
			quick
{
	property name="isPrimary" type="boolean" default="false";
	property name="displayOrder" type="numeric" default=0;
	
	function mediaItem(){
		return belongsTo( "Media@cbc", "FK_media" );
	}

	function sku(){
		return belongsTo( "ProductSKU@cbc", "FK_sku" );
	}

}