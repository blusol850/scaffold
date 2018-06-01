component {
    property name = "mockdata"          inject = "mockdata@MockDataCFC";
    property name = "wirebox"           inject = "wirebox";

    function init(){
        return true;
    }
    
    function get(){
        var oContact = mockdata.mock(
            'num'       = #randRange(5,20)#,
            'id'    = "autoincrement", 
            'address1' = "name",
            'address2' = "name",
            'city' = "name",
            'created_at' = "datetime",
            'email' = "name",
            'first' = "name",
            'last' = "name",
            'state' = "name",
            'updated_at' = "datetime",
            'zip' = "name",


            'updated_at'     = 'datetime'
        );
        return oContact;
    }

    function create(){
        var oContact = var oContact = {}
        return oContact;
    }

    function show(){
        var oContact = mockdata.mock(
            'num'       = 1,
            'id'    = "autoincrement", 
            'address1' = "name",
            'address2' = "name",
            'city' = "name",
            'created_at' = "datetime",
            'email' = "name",
            'first' = "name",
            'last' = "name",
            'state' = "name",
            'updated_at' = "datetime",
            'zip' = "name",


            'updated_at'     = 'datetime'
        );
        return oContact;
    }

    function edit(){
        var oContact = mockdata.mock(
            'num'       = 1,
            'id'    = "autoincrement", 
            'address1' = "name",
            'address2' = "name",
            'city' = "name",
            'created_at' = "datetime",
            'email' = "name",
            'first' = "name",
            'last' = "name",
            'state' = "name",
            'updated_at' = "datetime",
            'zip' = "name",


            'updated_at'     = 'datetime'
        );
        return oContact;
    }

     function new(){
        var oContact = mockdata.mock(
            'num'       = 1,
            'id'    = "autoincrement", 
            'address1' = "name",
            'address2' = "name",
            'city' = "name",
            'created_at' = "datetime",
            'email' = "name",
            'first' = "name",
            'last' = "name",
            'state' = "name",
            'updated_at' = "datetime",
            'zip' = "name",


            'updated_at'     = 'datetime'
        );
        return oContact;
    }

    function delete(){
        var oContact = {}
        return oContact;
    }


}

