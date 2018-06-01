<cfoutput><cfloop array="#metadata.properties#" index="thisProp"><cfif compareNoCase(thisProp.fieldType,"column") EQ 0><cfswitch expression="#thisProp.ormtype#"><cfcase value="timestamp"><cfset t="datetime"></cfcase><cfdefaultcase><cfset t="name"></cfdefaultcase></cfswitch>            '#thisProp.name#' = "#t#",
</cfif></cfloop></cfoutput>
