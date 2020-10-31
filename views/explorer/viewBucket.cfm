<cfoutput>
<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">
    	<a href="#event.buildLink( 's3sdkexplorer' )#" title="My Amazon S3 Buckets">
    		My Amazon S3 Buckets
    	</a> > 
		<a href="#event.buildLink( 's3sdkexplorer/bucket/' & '#urlEncodedFormat( rc.bucketname )#' )#" title="#encodeForHTMLAttribute( rc.bucketName )# Bucket">#encodeForHTML( rc.bucketName )#</a>
		<cfif listlen( rc.foldername ) gt 0>
			<cfset folderPath = "">
			<cfloop list="#rc.foldername#" delimiters="/" index="i">
				<cfset folderPath = listAppend( folderPath, i, "|" )> >
				<a href="#event.buildLink( "s3sdkexplorer.bucket." & "#urlEncodedFormat( rc.bucketname )#/#urlencodedFormat( folderPath )#" )#" title="#i# Folder">#i#</a>
			</cfloop>
		</cfif>
    </h1>
	#getInstance( "messagebox@cbMessagebox" ).renderit()#
	<div class="card shadow mb-4">
	    <div class="card-header py-3">
	    	<div class="row">
		    	<div class="col-sm-12 col-md-7">
			      	<a href="#event.buildLink( 's3sdkexplorer' )#" class="btn btn-primary btn-sm">
			      		<i class="fa fa-arrow-left"></i> Go Back
			      	</a>
			      	<a href="javascript:window.location.reload()" class="btn btn-primary btn-sm">
			      		<i class="fa fa-sync"></i> Reload
			      	</a>
			      	<a href="javascript:uploadObject()" class="btn btn-primary btn-sm">
			      		<i class="fa fa-cloud-upload-alt"></i> Upload File
			      	</a>
			      	<a href="javascript:uploadFolder()" class="btn btn-primary btn-sm">
			      		<i class="fa fa-plus-circle"></i> Create Folder
			      	</a>
			      </div>
		      	<div class="col-sm-12 col-md-5 form-inline">
		      		<div class="form-group">
			      		<label for="changeBucket" class="padR5"> Jump To: </label> 
			      		<select class="form-control" name="changeBucket" id="changeBucket" onChange="window.location.href='#event.buildLink( to='s3sdkexplorer.bucket')#/'+this.value">
							<cfloop array="#prc.allBuckets#" index="bucket">
								<option value="#urlEncodedFormat( bucket.name )#"
									    <cfif comparenocase( bucket.name, rc.bucketname ) eq 0>selected="selected"</cfif>
								>#encodeForHTML( bucket.name )#</option>
							</cfloop>
						</select>
					</div>
		      	</div>
		    </div>  	
	    </div>
	    <div class="card-body">
	      <div class="table-responsive">
	        	 <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
	                  <thead>
	                    <tr>
							<th>Object Name</th>
							<th>Last Modified</th>
							<th>Size</th>
							<th>eTag</th>
							<th class="center {sorter:false}">Actions</th>
	                    </tr>
	                  </thead>
	                  <tbody>
	                   		<cfloop array="#prc.allObjects#" index="object">
	                   			<cfset encodedObjectKey = replacelist( object.Key, '/,_$folder$', '|,' )>
							<tr>
								<td>
									<cfif object.isDirectory>
										<a href="#event.buildLink( to='s3sdkexplorer.explorer.viewBucket', queryString='bucketName=#urlEncodedFormat( rc.bucketname )#')#/folderName/#encodedObjectKey#" title="Public Link">
											<i class="fa fa-folder padR5"></i>#replacenocase( object.Key, '_$folder$', '' )#
										</a>
									<cfelse>
										<a target="_blank" href="http://#rc.bucketName#.s3.amazonaws.com/#object.key#" title="Public Link">
											<i class="fa fa-file padR5" alt="file"></i>#object.Key#
										</a>
									</cfif>
								</td>
								<td>
									#dateFormat( parseISO8601( object.LastModified ), "mm/dd/yyyy" )#
									#timeFormat( parseISO8601( object.LastModified ), "hh:mm tt" )#
								</td>	
								<td>
									<cfif len( object.Size ) and isNumeric( object.size )>
										#NumberFormat( object.Size / 1024 )# KB
									</cfif>
								</td>
								<td>#replace( object.etag, '"', '', "all" )#</td>
								<td class="center"> 
									<cfif !object.isDirectory >
										<a href="javascript:secureLink('#urlEncodedFormat( object.key )#')" title="Time Expired Link" class="btn btn-primary btn-circle btn-sm">
											<i class="fas fa-link" alt="secure link"></i>
										</a> 
										&nbsp;
									</cfif>
									
									<cfif object.isDirectory>
										<!--- <a href="javascript:showACL( '#urlEncodedFormat( rc.bucketname )#/#urlEncodedFormat( replacenocase( object.Key, '_$folder$', '' ) )#/', true )"
											   title="Show bucket ACL"  class="btn btn-primary btn-circle btn-sm">
												<i class="fas fa-lock" alt="info"></i>
										</a>
										&nbsp; --->
										<a href="javascript:getObjectInfo( '#URLEncodedFormat( replacenocase( object.Key, '_$folder$', '' ))#', true )" title="Get Object Metadata" class="btn btn-primary btn-circle btn-sm">
											<i class="fas fa-info-circle" alt="info"></i>
										</a>
									<cfelse>
										<!--- <a href="javascript:showACL( '#urlEncodedFormat( rc.bucketname )#/#urlEncodedFormat( replacenocase( object.Key, '_$folder$', '' ) )#', false )"
										   title="Show bucket ACL"  class="btn btn-primary btn-circle btn-sm">
											<i class="fas fa-lock" alt="info"></i>
										</a>
										&nbsp; --->
										<a href="javascript:getObjectInfo( '#URLEncodedFormat( object.Key )#', false )" title="Get Object Metadata" class="btn btn-primary btn-circle btn-sm">
											<i class="fas fa-info-circle" alt="info"></i>
										</a>
										
									</cfif>
									&nbsp;
									<cfif !object.isDirectory >
										<a href="javascript:void(0);" rel="#object.key#" title="Remove Object" class="removeObject btn btn-danger btn-circle btn-sm">
											<i class="fas fa-trash" alt="delete"></i>
										</a>
									</cfif>
							</tr>
							</cfloop>
	                  </tbody>
	            </table>
	      </div>
	    </div>
	</div>
</div>	

<div class="modal fade" id="uploadDialog" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Upload Object</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="#event.buildLink( 's3sdkexplorer.explorer.upload' )#" method="post" enctype="multipart/form-data">
		<input type="hidden" name="bucketName" id="bucketName" value="#rc.bucketName#" />
		<input type="hidden" name="folderName" id="folderName" value="#rc.folderName#" />
      <div class="modal-body">
			<div class="form-group">
			    <label for="fileobject">File:</label>
			    <input required type="file" size="30" class="form-control" id="fileobject" name="fileobject" placeholder="Select File">
			</div>
			<div class="form-group">
			    <label for="acl">ACL Policy:</label>
			    <select name="acl" class="form-control">
					<option value="private">Private</option>
					<option value="public-read">Public-Read</option>
					<option value="public-read-write">Public-Read-Write</option>
					<option value="authenticated-read">Authenticated-Read</option>
				</select>
			</div>
			<div class="form-group">
			    <label for="extraMetadata">Extra Metadata (As a JSON struct):</label>
			    <input type="text" size="40" class="form-control" id="extraMetadata" name="extraMetadata" placeholder="Enter Extra Metadata" value="{}">
			</div>
			<div class="form-group">
			    <label for="cc">Cache Control String:</label>
			    <input type="text" size="40" class="form-control" id="cc" name="cc" placeholder="Enter Cache Control String">
			</div>
			<div class="form-group">
			    <label for="expires">Days to Expire:</label>
			    <input type="number" max="365" min="0" size="10" step="1" class="form-control" id="expires" name="expires" placeholder="Enter Days to Expire">
			</div>		
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Upload File</button>
      </div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade" id="uploadFolderDialog" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Folder Path</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="#event.buildLink( 's3sdkexplorer.explorer.createFolder' )#" method="post" enctype="multipart/form-data">
      	<input type="hidden" name="bucketName" value="#rc.bucketName#" />
      <div class="modal-body">
			<div class="form-group">
			    <label for="folderName">Folder Name:</label>
			    <input required type="text" size="50" maxlength="50" class="form-control" name="folderName" placeholder="Enter Folder Name" value="#rc.folderName#">
			</div>
			<div class="form-group">
			    <label for="acl">ACL Policy:</label>
			    <select name="acl" class="form-control">
					<option value="private">Private</option>
					<option value="public-read">Public-Read</option>
					<option value="public-read-write">Public-Read-Write</option>
					<option value="authenticated-read">Authenticated-Read</option>
				</select>
			</div>	
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Create Folder</button>
      </div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade" id="deleteDialog" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Delete</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="#event.buildLink( 's3sdkexplorer.explorer.removeObject' )#" method="post">
      	<input type="hidden" name="bucketName" id="bucketName" value="#rc.bucketName#" />
		<input type="hidden" name="uri" id="uri" value="" />
      <div class="modal-body">
			<h4>This object will be permanently deleted and cannot be recovered. Are you sure?</h4>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Delete</button>
      </div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade" id="dialog" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="dialogTitle">Folder Path</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
				
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
$(document).ready(function() {
	//removeObject listener
	$(".removeObject").click(function(){
		var uri = $(this).attr("rel");
		$("##deleteDialog ##uri").val(uri);
		$("##deleteDialog").modal('show');
		return false;
	});
});


function uploadObject(){
	$("##uploadDialog").modal( 'show' );
}
function uploadFolder(){
	$("##uploadFolderDialog").modal( 'show' );
}
function getObjectInfo(obj, isDirectory){

	var data = {bucketName:"#rc.bucketName#", objectKey:obj, isDirectory: isDirectory };

	$("##dialog").find('.modal-body').load('#event.buildLink("s3sdkexplorer.explorer.getObjectInfo")#',
						data,
						function(){
							$("##dialogTitle").text('Info > #rc.bucketName#/'+obj);
							$("##dialog").find('.modal-dialog').addClass('modal-lg');
							$("##dialog").modal('show');
						});
}
function secureLink(obj){
	var data = {bucketName:"#rc.bucketName#", key:encodeURI(obj)};

	$("##dialog").find('.modal-body').load('#event.buildLink("s3sdkexplorer.explorer.genAuthenticatedURL")#',
						data,
						function(res){
							$("##dialogTitle").text('Timed Expired Secure Link');
							$("##dialog").modal('show');		
						});
}

function showACL(bucket, isDirectory){
	var data = {objectName:bucket, isDirectory: isDirectory};
	$("##dialog").find('.modal-body').load('#event.buildLink("s3sdkexplorer.explorer.objectACL")#',
						data,
						function(){
							$("##dialogTitle").text('Timed Expired Secure Link');
							$("##dialog").modal('show');		
						});
}

</script>
</cfoutput>