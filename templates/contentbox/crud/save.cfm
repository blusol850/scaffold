<cfoutput>
<cfloop array="#metadata.properties#" index="thisProp"><cfif compareNoCase(thisProp.name,"id") EQ 0><cfelseif compareNoCase(thisProp.name,"updated_at") EQ 0><cfelseif compareNoCase(thisProp.name,"created_at") EQ 0>
			<cfelseif compareNoCase(thisProp.fieldType,"column") EQ 0>
			%cfif structKeyExists(arguments.rc, "#thisProp.name#")>
				|tableName|.#thisProp.name# 	= 	%cfqueryparam value="##arguments.rc.#thisProp.name###"  cfsqltype="cf_sql_char">,
			%/cfif><cfelse></cfif></cfloop>			
</cfoutput>