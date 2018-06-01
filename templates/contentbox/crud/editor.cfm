<cfoutput>

<cfloop array="#metadata.properties#" index="thisProp">
<cfif compareNoCase(thisProp.name,"id") EQ 0>
	##html.hiddenField(
	    name="#thisProp.name#",
	    value=##prc.q#entityName#.#thisProp.name###
	)##<cfelseif compareNoCase(thisProp.name,"updated_at") EQ 0><cfelseif compareNoCase(thisProp.name,"created_at") EQ 0>
<cfelseif compareNoCase(thisProp.fieldType,"column") EQ 0>
	##html.textField(
	    name="#thisProp.name#",
	    label="#reReplace(thisProp.name,"(^[a-z]|\s+[a-z])","\U\1","ALL")#:",
	    value=##prc.q#entityName#.#thisProp.name###,
	    class="form-control",
	    title="#reReplace(thisProp.name,"(^[a-z]|\s+[a-z])","\U\1","ALL")#",
	    placeholder="#reReplace(thisProp.name,"(^[a-z]|\s+[a-z])","\U\1","ALL")#",
	    wrapper="div class=controls",
	    labelClass="control-label",
	    id="#thisProp.name#",
	    groupWrapper="div class=form-group"
	)##
<cfelse>
	
</cfif>

</cfloop>
			
				
</cfoutput>