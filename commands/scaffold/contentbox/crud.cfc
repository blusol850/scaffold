/**
* Generate some CRUD goodness out of an ORM entity.
* .
* Make sure you are running this command in the root of your app for it to find the correct folder.
* .
* {code:bash}
* coldbox create crud models.Contact
* {code}
*
 **/
component {

	/**
	* @entity The name and dot location path of the entity to create the CRUD for, starting from the root of your application. For example: models.Contact, models.security.User
	* @pluralName The plural name of the entity. Used for display purposes. Defaults to 'entityName' + s
	* @handlersDirectory The location of the handlers. Defaults to 'handlers'
	* @viewsDirectory The location of the views. Defaults to 'views'
	* @tests Generate the BDD tests for this CRUD operation
	* @testsDirectory Your integration tests directory. Only used if tests is true
	**/
	function run( 
		required entity,
		required table,
		pluralName="",
		handlersDirectory="handlers",
		viewsDirectory="views",
		modelsDirectory="models",
		boolean tests=true,
		testsDirectory='tests/specs/integration',
		moduleName=""
	) {
		// This will make each directory canonical and absolute
		arguments.handlersDirectory	= fileSystemUtil.resolvePath( arguments.handlersDirectory );
		arguments.viewsDirectory 	= fileSystemUtil.resolvePath( arguments.viewsDirectory );
		arguments.modelsDirectory 	= fileSystemUtil.resolvePath( arguments.modelsDirectory );
		arguments.testsDirectory 	= fileSystemUtil.resolvePath( arguments.testsDirectory );

		// entity defaults
		var entityName = listLast( arguments.entity, "." );
		var entityCFC 	= fileSystemUtil.resolvePath( replace( arguments.entity, ".", "/", "all" ) );
		var entityPath 	= entityCFC & ".cfc";
		// verify it
		if( !fileExists( entityPath ) ){
			return error( "The entity #entityPath# does not exist, cannot continue, ciao!" );
		}
		// Get content

		var entityContent = fileRead( entityPath );
		// property Map
		var metadata 	= { properties = [], pk="" };
		print.greenline(entityPath);
		var md 			= getComponentMetadata( entityCFC );
		
		// argument defaults
		if( !len( arguments.pluralname ) ){ arguments.pluralName = entityName & "s"; }

		// build property maps
		if( arrayLen( md.properties ) ){
			// iterate and build metadata map
			for( var thisProperty in md.properties ){
				// convert string to property representation
				entityDefaults( thisProperty );
				// store the pk for convenience
				if( compareNoCase( thisProperty.fieldType, "id" ) EQ 0 ){ metadata.pk = thisProperty.name; }
				
				// Store only persistable columns
				if( thisProperty.isPersistable ){
					arrayAppend( metadata.properties, thisProperty );
				}
			}
			
			//********************** generate handler ************************************//

			// Read Handler Content
			var hContent = fileRead( '/scaffold/templates/contentbox/crud/HandlerContent.txt' );
			// Token replacement
			hContent = replacenocase( hContent, "|entity|", entityName, "all" );
			hContent = replacenocase( hContent, "|entityPlural|", arguments.pluralName, "all" );
			hContent = replacenocase( hContent, "|moduleName|", arguments.moduleName, "all" );
			hContent = replacenocase( hContent, "|pk|", metadata.pk, "all" );
			
			// Write Out Handler
			var hpath = '#arguments.handlersDirectory#/#arguments.pluralName#.cfc';
			// Create dir if it doesn't exist
			directorycreate( getDirectoryFromPath( hpath ), true, true );
			file action='write' file='#hpath#' mode ='777' output='#hContent#';
			print.greenLine( 'Generated Handler: #hPath#' );

			//********************** generate views ************************************//

			// Create Views Path
			directorycreate( arguments.viewsDirectory & "/#arguments.pluralName#", true, true );
			var views = [ "edit", "new" ];
			for( var thisView in views ){
				var vContent = fileRead( '/scaffold/templates/contentbox/crud/#thisView#.txt' );
				vContent = replacenocase( vContent, "|entity|", entityName, "all" );
				vContent = replacenocase( vContent, "|entityPlural|", arguments.pluralName, "all" );
				vContent = replacenocase( vContent, "|moduleName|", arguments.moduleName, "all" );
				fileWrite( arguments.viewsDirectory & "/#arguments.pluralName#/#thisView#.cfm", vContent);
				print.greenLine( 'Generated View: ' & arguments.viewsDirectory & "/#arguments.pluralName#/#thisView#.cfm" );
			}

			//********************** generate editor output ************************************//
			
			// Build editor output for editor
			savecontent variable="local.editorData"{
				include '/scaffold/templates/contentbox/crud/editor.cfm';	
			}
			editorData = replaceNoCase( editorData, "%cf", "#chr(60)#cf", "all" );
			editorData = replaceNoCase( editorData, "%/cf", "#chr(60)#/cf", "all" );
			// editor data
			var vContent = fileRead( '/scaffold/templates/contentbox/crud/editor.txt' );
			vContent = replacenocase( vContent, "|entity|", entityName, "all" );
			vContent = replacenocase( vContent, "|entityPlural|", arguments.pluralName, "all" );
			vContent = replacenocase( vContent, "|editorListing|", editorData, "all" );
			vContent = replacenocase( vContent, "|moduleName|", arguments.moduleName, "all" );
			fileWrite( arguments.viewsDirectory & "/#arguments.pluralName#/editor.cfm", vContent);
			print.greenLine( 'Generated View: ' & arguments.viewsDirectory & "/#arguments.pluralName#/editor.cfm" );



			//********************** generate table output ************************************//
			
			// Build table output for index
			savecontent variable="local.tableData"{
				include '/scaffold/templates/contentbox/crud/table.cfm';	
			}
			tableData = replaceNoCase( tableData, "%cf", "#chr(60)#cf", "all" );
			tableData = replaceNoCase( tableData, "%/cf", "#chr(60)#/cf", "all" );
			// index data
			var vContent = fileRead( '/scaffold/templates/contentbox/crud/index.txt' );
			vContent = replacenocase( vContent, "|entity|", entityName, "all" );
			vContent = replacenocase( vContent, "|entityPlural|", arguments.pluralName, "all" );
			vContent = replacenocase( vContent, "|tableListing|", tableData, "all" );
			vContent = replacenocase( vContent, "|moduleName|", arguments.moduleName, "all" );
			fileWrite( arguments.viewsDirectory & "/#arguments.pluralName#/index.cfm", vContent);
			print.greenLine( 'Generated View: ' & arguments.viewsDirectory & "/#arguments.pluralName#/index.cfm" );

			//********************** generate model ************************************//
			// Build table output for index
			savecontent variable="local.saveData"{
				include '/scaffold/templates/contentbox/crud/save.cfm';	
			}
			saveData = replaceNoCase( saveData, "%cf", "#chr(60)#cf", "all" );
			saveData = replaceNoCase( saveData, "%/cf", "#chr(60)#/cf", "all" );
			// index data
			var vContent = fileRead( '/scaffold/templates/contentbox/crud/ModelContent.txt' );
			vContent = replacenocase( vContent, "|entity|", entityName, "all" );
			vContent = replacenocase( vContent, "|entityPlural|", arguments.pluralName, "all" );
			vContent = replacenocase( vContent, "|saveListing|", saveData, "all" );
			vContent = replacenocase( vContent, "|tableName|", arguments.table, "all" );
			fileWrite( arguments.modelsDirectory & "/#entityName#Service.cfc", vContent);
			print.greenLine( 'Generated Model: ' & arguments.modelsDirectory & "/#entityName#Service.cfc" );


		} else {
			return error( "The entity: #entityName# has no properties, so I have no clue what to CRUD on dude!" );
		}




		
	}

	/**
	* Get entity property metadata
	* @target The target metadata struc
	*/
	private function entityDefaults( required target ){
		// add defaults to it
		if( NOT structKeyExists( arguments.target, "fieldType" ) ){ arguments.target.fieldType = "column"; }
		if( NOT structKeyExists( arguments.target, "persistent" ) ){ arguments.target.persistent = true; }
		if( NOT structKeyExists( arguments.target, "formula" ) ){ arguments.target.formula = ""; }
		if( NOT structKeyExists( arguments.target, "readonly" ) ){ arguments.target.readonly = false; }

		// Add column isValid depending if it is persistable
		arguments.target.isPersistable = true;
		if( NOT arguments.target.persistent OR len( arguments.target.formula ) OR arguments.target.readonly ){
			arguments.target.isPersistable = false;
		}

		return arguments.target;
	}

}
