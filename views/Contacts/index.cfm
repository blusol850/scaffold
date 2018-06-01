<cfoutput>
<div class="row hidden-sm">
    <div class="col-md-6">
        <h2 class="h3">
          #html.href( href="cbadmin.module.|moduleName|.Contacts", text="<i class='fa fa-home'></i> Contacts")#
        </h2>
    </div>
    <div class="col-md-6">
        <!--- Create Button --->
<!--
#html.href( href="cbadmin.module.|moduleName|.Contacts.new", text="Create Contact", class="btn btn-primary pull-right")#
-->
#html.href( href="cbadmin.module.|moduleName|.Contacts.new", text="<i class='fa fa-plus'></i>", class="btn btn-danger pull-right")#

    </div>
</div>


<!--- MessageBox --->
<cfif flash.exists( "notice" )>
<div class="row">
    <div class="col-md-12">
	    <div class="alert alert-#flash.get( "notice" ).type#">
	        #flash.get( "notice" ).message#
	    </div>
    </div>
</div>
</cfif>



<div class="row">
    <div class="col-md-12">
        <div class="panel panel-default">
            <div class="panel-body">
<!--- Listing --->

<table class="sortable table table-striped table-hover table-condensed" name="crudlist" id="crudlist" >
	<thead>
		<tr>
		
			<th>address1</th>
			<th>address2</th>
			<th>city</th>
			<th>created_at</th>
			<th>email</th>
			<th>first</th>
			
			<th>last</th>
			<th>state</th>
			<th>updated_at</th>
			<th>zip</th>
			<th width="150">Actions</th>
		</tr>
	</thead>
	<tbody>
		<cfloop query="#prc.qContacts#" >
		<tr>
			
					<td>#address1#</td>
					<td>#address2#</td>
					<td>#city#</td>
					<td>#created_at#</td>
					<td>#email#</td>
					<td>#first#</td>
					<td>#last#</td>
					<td>#state#</td>
					<td>#updated_at#</td>
					<td>#zip#</td>
			
			<td>
			<div class="btn-group pull-right">
			#html.startForm(action="cbadmin.module.api.Contacts.delete", id="modalFormDelete")#
				#html.button(value="<i class='fa fa-edit'></i> Delete", onclick="return confirm('Really Delete Record?')", class="btn btn-danger btn-sm", type="submit")# 		

				#html.href(href="cbadmin.module.api.Contacts.edit", queryString="id=#id#", text="<i class='fa fa-edit'></i> Edit", class="btn btn-primary btn-sm")#

				
				#html.hiddenField(name="id", value=#id#)#
			#html.endForm()#
			</div>
			</td>
		</tr>
		</cfloop>
	</tbody>
</table>




            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
$(document).ready(function(){

   var table = $('.sortable').DataTable({
       fixedHeader: true,
        stateSave: true,
        responsive: true
      });
        
});


</script>

</cfoutput>