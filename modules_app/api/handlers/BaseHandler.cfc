/**
* ********************************************************************************
* Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ********************************************************************************
* Base RESTFul handler spice up as needed.
* This handler will create a Response model and prepare it for your actions to use
* to produce RESTFul responses.
*/
component extends="coldbox.system.EventHandler"{
    property name   = "wirebox"				inject = "wirebox";
    property name 	= "jwt" 				inject = "provider:JWTService@jwt";
    property name   = "API_KEY" 			inject = "coldbox:setting:API_KEY";


	// Pseudo "constants" used in API Response/Method parsing
	property name="METHODS";
	property name="STATUS";
	// Verb aliases - in case we are dealing with legacy browsers or servers ( e.g. IIS7 default )
	METHODS = {
		'HEAD' 		: 'HEAD',
		'GET' 		: 'GET',
		'POST' 		: 'POST',
		'PATCH' 	: 'PATCH',
		'PUT' 		: 'PUT',
		'DELETE' 	: 'DELETE',
		'OPTIONS'	: 'OPTIONS'
	};

	// HTTP STATUS CODES
	STATUS = {
		'CREATED' 				: 201,
		'ACCEPTED' 				: 202,
		'SUCCESS' 				: 200,
		'NO_CONTENT' 			: 204,
		'RESET' 				: 205,
		'PARTIAL_CONTENT' 		: 206,
		'BAD_REQUEST' 			: 400,
		'NOT_AUTHORIZED' 		: 403,
		'NOT_AUTHENTICATED' 	: 401,
		'NOT_FOUND' 			: 404,
		'NOT_ALLOWED' 			: 405,
		'NOT_ACCEPTABLE' 		: 406,
		'TOO_MANY_REQUESTS' 	: 429,
		'EXPECTATION_FAILED' 	: 417,
		'INTERNAL_ERROR' 		: 500,
		'NOT_IMPLEMENTED' 		: 501
	};

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 		= '';
	this.prehandler_except 		= '';
	this.posthandler_only 		= '';
	this.posthandler_except 	= '';
	this.aroundHandler_only 	= '';
	this.aroundHandler_except 	= '';

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {
		'index'     : METHODS.GET,
		'get'       : METHODS.GET,
		'list'      : METHODS.GET,
		'update'    : METHODS.PUT & ',' & METHODS.PATCH,
		'delete'    : METHODS.DELETE,
		'login'		: METHODS.POST & ',' & METHODS.OPTIONS,
		'options'	: METHODS.OPTIONS
	};
	/**
	* A preFlight action for browsers to ensure CORS compatibility
	*/
	function preFlight( event, rc, prc ){
	}

	/**
	* Around handler for all actions it inherits
	*/
	function aroundHandler(
		event,
		rc,
		prc,
		targetAction,
		eventArguments
	){
		try{
			// start a resource timer
			var stime = getTickCount();

			prc.decodedToken = structnew();

			// prepare our response object
			prc.response = getModel( 'Response@api' );
			// prepare argument execution
			var args = {
				event = arguments.event,
				rc = arguments.rc,
				prc = arguments.prc
			};
			structAppend( args, arguments.eventArguments );
			// Secure the call
			if( isAuthorized(
				event,
				rc,
				prc,
				targetAction
			) ){
				if(trim(event.getHTTPHeader('Authorization')) NEQ ""){
					prc.decodedToken = jwt.decode(listLast( event.getHTTPHeader( 'Authorization' ), ' ' ) , API_KEY);
				}
				// Execute action
				var simpleResults = arguments.targetAction( argumentCollection=args );
			}
		} catch( Any e ){
			// Log Locally
			log.error( 'Error calling #event.getCurrentEvent()#: #e.message# #e.detail#', e );
			// Setup General Error Response
			prc.response.setError( true )
				.setErrorCode( e.errorCode eq 0 ? 500 : len( e.errorCode ) ? e.errorCode : 0 )
				.addMessage( 'General application error: #e.message#' )
				.setStatusCode( 500 )
				.setStatusText( 'General application error' );
			// Development additions
			if( getSetting( 'environment' ) eq 'development' ){
				prc.response.addMessage( 'Detail: #e.detail#' ).addMessage( 'StackTrace: #e.stacktrace#' );
			}
		}

		// Development additions
		if( getSetting( 'environment' ) eq 'development' ){
			prc.response.addHeader( 'x-current-route', event.getCurrentRoute() )
				.addHeader( 'x-current-routed-url', event.getCurrentRoutedURL() )
				.addHeader( 'x-current-routed-namespace', event.getCurrentRoutedNamespace() )
				.addHeader( 'x-current-event', event.getCurrentEvent() );
		}
		// end timer
		prc.response.setResponseTime( getTickCount() - stime );

		// Did the user set a view to be rendered? If not use renderdata, else just delegate to view.
		if( !len( event.getCurrentView() ) ){
			// Simple HTML Handler Results?
			if( !isNull( simpleResults ) ){
				prc.response.setData( simpleResults ).setFormat( 'html' );
				return simpleResults;
			} else{
				// Magical Response renderings
				event.renderData(
					type		= prc.response.getFormat(),
					data 		= prc.response.getDataPacket(),
					contentType = prc.response.getContentType(),
					statusCode 	= prc.response.getStatusCode(),
					statusText 	= prc.response.getStatusText(),
					location 	= prc.response.getLocation(),
					isBinary 	= prc.response.getBinary()
				);
			}
		}

		// Global Response Headers
		prc.response.addHeader( 'x-response-time', prc.response.getResponseTime() ).addHeader( 'x-cached-response', prc.response.getCachedResponse() )

		// Response Headers
		for( var thisHeader in prc.response.getHeaders() ){
			event.setHTTPHeader( name=thisHeader.name, value=thisHeader.value );
		}
	}

	/**
	* on localized errors
	*/
	function onError(
		event,
		rc,
		prc,
		faultAction,
		exception,
		eventArguments
	){
		// Log Locally
		log.error( 'Error in base handler (#arguments.faultAction#): #arguments.exception.message# #arguments.exception.detail#', arguments.exception );
		// Verify response exists, else create one
		if( !structKeyExists( prc, 'response' ) ){
			prc.response = getModel( 'Response@api' );
		}
		// Setup General Error Response
		prc.response.setError( true )
			.setErrorCode( 501 )
			.addMessage( 'Base Handler Application Error: #arguments.exception.message#' )
			.setStatusCode( 500 )
			.setStatusText( 'General application error' );

		// Development additions
		if( getSetting( 'environment' ) eq 'development' ){
			prc.response.addMessage( 'Detail: #arguments.exception.detail#' ).addMessage( 'StackTrace: #arguments.exception.stacktrace#' );
		}

		// Render Error Out
		event.renderData(
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket(),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}

	/**
	* on invalid http verbs
	*/
	function onInvalidHTTPMethod(
		event,
		rc,
		prc,
		faultAction,
		eventArguments
	){

		prc.response = getModel( 'Response@api' );
		if(event.getHTTPMethod() neq "OPTIONS"){
		// Log Locally
		log.warn( 'InvalidHTTPMethod Execution of (#arguments.faultAction#): #event.getHTTPMethod()#', getHTTPRequestData() );
		// Setup Response
		prc.response.setError( true )
			.setErrorCode( 405 )
			.addMessage( 'InvalidHTTPMethod Execution of (#arguments.faultAction#): #event.getHTTPMethod()#' )
			.setStatusCode( 405 )
			.setStatusText( 'Invalid HTTP Method' );
		}	
		// Render Error Out
		event.renderData(
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket(),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}

	/**
	* An unathorized request
	*/
	function onNotAuthorized( event, rc, prc ){
		prc.response.addMessage( 'Unathorized Request! You do not have the right permissions to execute this request' )
			.setError( true )
			.setErrorCode( 403 )
			.setStatusCode( 403 )
			.setStatusText( 'Invalid Permissions' );
			//log.info( arguments );
	}

	/**
	* An un-authenticated request or session timeout
	*/
	function onNotAuthenticated( event, rc, prc ){
		prc.response.addMessage( 'You are not logged in or your session has timed out, please try again.' )
			.setError( true )
			.setErrorCode( 401 )
			.setStatusCode( 401 )
			.setStatusText( 'Not Authenticated' );
	}

	/**
	* Secure an API Call
	* It looks for a 'secured' annotation, the value would be the permissions you need to execute the action.
	* By default all calls are secured unless they have an annotation of 'public'
	*/
	private boolean function isAuthorized(
		event,
		rc,
		prc,
		targetAction
	){
		// Get metadata on executed action
		var md = getMetadata( arguments.targetAction );

		var httpMethod = event.getHTTPMethod();

		if(httpMethod eq "OPTIONS"){
			prc.response.addMessage( 'options request' );
			return false;
		}	



		// Is this a public action?
		if( structKeyExists( md, 'public' ) ){
			prc.response.addMessage( 'Public Function' );
			return true;
		} else{
			prc.response.addMessage( 'Private Function' );
		}


		// Check logged in
		/* if( !sessionStorage.exists( 'user' ) ){
			 Uncomment for user bypass
			prc.response.addMessage( 'USER CHECK BYPASS' );
			prc.response.addMessage( serializeJSON( sessionStorage.getStorage() ) );
			return true;

			onNotAuthenticated( event, rc, prc );
			return false;
		} else{
			prc.response.addMessage( 'Logged In: #sessionStorage.getVar( 'user' ).username#' );
		} */

		/* Check permissions and if you have them
		if( structKeyExists( md, "secured" ) && len( md.secured ) && !prc.oCurrentUser.checkPermission( md.secured ) ){
			onNotAuthorized( event, rc, prc );
			return false;
		}
		*/

		if( structKeyExists( md, 'secured' ) ){
			prc.response.addMessage( 'JWT CHECK:' );
			/* prc.response.addMessage( 'JWT API_KEY:' & API_KEY );
			prc.response.addMessage( 'JWT Bearer:' & listLast( event.getHTTPHeader( 'Authorization' ), ' ' ) );
 			*/
			prc.verified = jwt.verify( listLast( event.getHTTPHeader( 'Authorization' ), ' ' ), API_KEY );
			prc.response.addMessage( prc.verified );
			// if( !prc.verified ){
			// 	onNotAuthenticated(
			// 		event,
			// 		rc,
			// 		prc
			// 	);
			// 	return false;
			// }
			prc.response.addMessage( 'Checking Roles..' );
			// role checking should be done here
			prc.response.addMessage( 'ROLE BYPASS' );
			return true;




			onNotAuthorized(
				event,
				rc,
				prc
			);
			return false;
		}

		return true;
	}

}
