<cfoutput>
<p>Click to select URL</i>.
<textarea class="form-control" cols='40' rows='6' onclick="selectAll(this)">#rc.timedLink#</textarea>
<script type="text/javascript">
function selectAll(text){
	text.focus();
	text.select();
}
</script>
</cfoutput>