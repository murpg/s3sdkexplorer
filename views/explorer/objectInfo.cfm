<cfoutput>
<table class="table table-bordered table-hover" width="95%">
<thead>
	<tr>
		<th>Property</th>
		<th>Value</th>
	</tr>
</thead>
<tbody>
	<cfloop collection="#rc.info#" item="key">
		<tr>
			<td>#key#</td>
			<td>#rc.info[key]#</td>
		</tr>
	</cfloop>
</tbody>
</table>
</cfoutput>