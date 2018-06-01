component extends="api.handlers.BaseHandler"{
	property name 	= "contactService" 				inject = "contactService@api";

    function  index( event, rc, prc ) secured="admin" {		
		var r = {};
		r['contacts'] = contactService.get();
		prc.response.setData( r );
	};

	function  new( event, rc, prc ) secured="admin" {		
		var r = {};
		r['contacts'] = contactService.new();
		prc.response.setData( r );
	};

	function  create( event, rc, prc ) secured="admin" {		
		var r = {};
		r['contacts'] = contactService.create();
		prc.response.setData( r );
	};

	function  show( event, rc, prc ) secured="admin" {		
		var r = {};
		r['contacts'] = contactService.show();
		prc.response.setData( r );
	};

	function  edit( event, rc, prc ) secured="admin" {		
		var r = {};
		r['contacts'] = contactService.edit();
		prc.response.setData( r );
	};

	function  update( event, rc, prc ) secured="admin" {		
		var r = {};
		r['contacts'] = contactService.update();
		prc.response.setData( r );
	};

	function  delete( event, rc, prc ) secured="admin" {		
		var r = {};
		r['contacts'] = contactService.delete();
		prc.response.setData( r );
	};



}

