<cfoutput>
<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">My Amazon S3 Buckets</h1>
	#getInstance( "messagebox@cbMessagebox" ).renderit()#
	<div class="card shadow mb-4">
	    <div class="card-header py-3">
		      	<button onclick="javascript:createBucket();" class="btn btn-primary btn-sm">
		      		<i class="fa fa-plus-circle"></i> Create Bucket
		      	</button>
		      	<a href="#event.buildLink(to='s3sdkexplorer')#" class="btn btn-primary btn-sm">
		      		<i class="fa fa-sync"></i> Reload
		      	</a>
	    </div>
	    <div class="card-body">
	      <div class="table-responsive">
	        	 <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
	                  <thead>
	                    <tr>
	                      <th>Bucket</th>
	                      <th>Creation</th>
	                      <th>Actions</th>
	                    </tr>
	                  </thead>
	                  <tbody>
	                    <cfloop array="#prc.allBuckets#" index="bucket">
							<tr>
								<td>
									<a href="#event.buildLink( 's3sdkexplorer.bucket.' & '#URLEncodedFormat( bucket.Name )#' )#"
									   title="Go into bucket">
									   <i class="fa fa-folder padR5"></i>#bucket.Name#
									</a>
								</td>
								<td>
									#dateFormat( parseISO8601( bucket.CreationDate ), "mm/dd/yy" )#
									#timeFormat( parseISO8601( bucket.CreationDate ), "hh:mm tt" )#
								</td>
								<td class="center">
									
									<!--- <a href="javascript:showACL('#bucket.name#')" title="Show bucket ACL" class="btn btn-primary btn-circle btn-sm">
										<i class="fas fa-lock" alt="security"></i>
									</a> --->
									
									<a href="#event.buildLink( 's3sdkexplorer.explorer.removeBucket.bucketName.' & URLEncodedFormat( bucket.Name ) )#" 
									   onClick="return confirm('Really Delete?')"
									   title="Remove object" class="btn btn-danger btn-circle btn-sm">
									   	<i class="fas fa-trash" alt="delete"></i>
									</a>
								</td>
							</tr>
							</cfloop>  
	                  </tbody>
	                </table>
	      </div>
	    </div>
	</div>
</div>	
<div class="modal fade" id="createDialog" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Create Bucket</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form action="#event.buildLink( 's3sdkexplorer.explorer.createbucket' )#" method="post">
      <div class="modal-body">
			<div class="form-group">
			    <label for="bucketName">Bucket Name:</label>
			    <input required type="text" size="30" maxlength="30" class="form-control" id="bucketName" name="bucketName" placeholder="Enter Bucket Name">
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
			    <label for="storage">Storage Location:</label>
			    <select name="storage" class="form-control">
					<option value="US">United States</option>
					<option value="EU">Europa</option>
				</select>
			</div>		
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
        <button type="submit" class="btn btn-primary">Create Bucket</button>
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
var closeHTML = "<p><button class='simplemodal-close' onClick='$.modal.close()'>Close-Cancel</button> <span>(or press ESC to cancel)</span></p>";
function createBucket(){
	$( "##createDialog" ).modal( 'show' );
}
function showACL( bucket ){
	var data = { objectName : bucket, isDirectory: true };
	$("##dialog").find('.modal-body').load( '#event.buildLink("s3sdkexplorer.explorer.objectACL")#',
		data,
		function(){
			$("##dialog").modal('show');
		});
}
</script>
</cfoutput>