<cfoutput>
<table class="sortable table table-striped table-hover table-condensed" name="crudlist" id="crudlist" >
	<thead>
		<tr>
		<cfloop array="#metadata.properties#" index="thisProp">
			<cfif compareNoCase(thisProp.fieldType,"column") EQ 0><th>#thisProp.name#</th></cfif></cfloop>
			<th width="150">Actions</th>
		</tr>
	</thead>
	<tbody>
		%cfloop query="##prc.q#arguments.pluralName###" >
		<tr>
			<cfloop array="#metadata.properties#" index="thisProp"><cfif compareNoCase(thisProp.fieldType,"column") EQ 0>
					<td>###thisProp.name###</td></cfif></cfloop>
			<!--- Actions --->
			<td>
			<div class="btn-group pull-right">
			##html.startForm(action="cbadmin.module.#arguments.modulename#.#arguments.pluralname#.delete", id="modalFormDelete")##
				##html.button(value="<i class='fa fa-edit'></i> Delete", onclick="return confirm('Really Delete Record?')", class="btn btn-danger btn-sm", type="submit")## 		

				##html.href(href="cbadmin.module.#arguments.modulename#.#arguments.pluralName#.edit", queryString="id=##id##", text="<i class='fa fa-edit'></i> Edit", class="btn btn-primary btn-sm")##

				
				##html.hiddenField(name="id", value=##id##)##
			##html.endForm()##
			</div>
			</td>
		</tr>
		%/cfloop>
	</tbody>
</table>

</cfoutput>

