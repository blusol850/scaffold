/**
* A cool Contact entity
*/
component persistent="true" table="quickcrud"{

	// Primary Key
	property name="id" fieldtype="id" column="id" generator="native" setter="false";
	
	// Properties
	property name="first" ormtype="string";	property name="last" ormtype="string";	property name="email" ormtype="string";	property name="address1" ormtype="string";	property name="address2" ormtype="string";	property name="city" ormtype="string";	property name="state" ormtype="string";	property name="zip" ormtype="string";	property name="updated_at" ormtype="timestamp";	property name="created_at" ormtype="timestamp";	
	
	// Validation
	this.constraints = {
		// Example: age = { required=true, min="18", type="numeric" }
	};
	
	// Constructor
	function init(){
		
		return this;
	}
}

