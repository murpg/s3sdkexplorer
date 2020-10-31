/**
 * Copyright Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This module connects your application to Amazon S3
 **/
component {

	// Module Properties
	this.title 				= "Amazon S3 SDK";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "This SDK will provide you with Amazon S3 connectivity for any ColdFusion (CFML) application.";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	this.autoMapModels 		= false;
	this.entryPoint			= "s3sdkexplorer";
	this.dependencies 		= [ "cbMessageBox" ];

	/**
	 * Configure
	 */
	function configure(){
		// Settings
		variables.settings = {
			accessKey           : "",
			secretKey           : "",
			encryption_charset  : "utf-8",
			ssl                 : true,
			awsregion           : "us-east-1",
			awsDomain 			: "amazonaws.com",
			defaultDelimiter	: "/",
			defaultBucketName	: ""
		};

		// Layout Settings
		layoutSettings = { defaultLayout = "S3Layout.cfm" };
		
		// SES Routes
		routes = [
			{ pattern="/", handler="explorer", action="index" },
			{ pattern="/bucket/:bucketname/:foldername?", handler="explorer", action="viewBucket" },
			{ pattern="/:handler/:action?" }
		];
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
		binder.map( "AmazonS3@s3sdkexplorer" )
			.to( "#moduleMapping#.models.AmazonS3" )
			.initArg( name="accessKey", 			value=variables.settings.accessKey )
			.initArg( name="secretKey", 			value=variables.settings.secretKey )
			.initArg( name="encryption_charset", 	value=variables.settings.encryption_charset )
			.initArg( name="ssl", 					value=variables.settings.ssl )
			.initArg( name="awsRegion", 			value=variables.settings.awsregion )
			.initArg( name="awsDomain", 			value=variables.settings.awsDomain )
			.initArg( name="defaultDelimiter", 		value=variables.settings.defaultDelimiter )
			.initArg( name="defaultBucketName", 	value=variables.settings.defaultBucketName );

		binder.map( "Sv4Util@s3sdkexplorer" )
			.to( "#moduleMapping#.models.AmazonS3" )
			.initArg( name="accessKeyId", 			value=variables.settings.accessKey )
			.initArg( name="secretAccessKey", 		value=variables.settings.secretKey )
			.initArg( name="defaultRegionName", 	value=variables.settings.awsregion )
			.initArg( name="defaultServiceName",	value="s3" );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

}