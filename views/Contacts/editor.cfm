
<cfoutput>
<div class="row">
    <div class="col-md-12">
        <h2 class="h3">
		#html.href( href="cbadmin.module.|moduleName|.Contacts", text="<i class='fa fa-home'></i> Contacts:")#
         #args.title#</h2>
    </div>
</div>

<!--- Submit Form --->
#html.startForm( action='cbadmin.module.|modulename|.Contacts.save' )#
<div class="panel panel-default">
	<div class="panel-body">
|editorListing|
	</div>

	<div class="panel-footer">
	<!--- Submit --->
		<div class="form-group">
		#html.submitButton(value="Save", class="btn btn-primary pull-right")#
			#html.href( href="cbadmin.module.|modulename|.Contacts.index", text="Cancel", class="btn btn-default pull-right" )#
			
		</div>
	</div>
</div>

#html.endForm()#
</cfoutput>