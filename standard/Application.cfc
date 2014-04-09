component extends="framework.one" {
	// ------------------------ APPLICATION SETTINGS ------------------------ //
		this.applicationroot = getDirectoryFromPath( getCurrentTemplatePath() );
		this.name = 'standard-skeleton';
		this.datasource = 'standard-skeleton';
		this.sessionmanagement = true;
		this.setClientCookies = true;
		this.scriptProtect = true;
		this.development = false;
		// prevent bots creating lots of sessions
		if ( structKeyExists( cookie, "CFTOKEN" ) ) this.sessiontimeout = createTimeSpan( 0, 0, 20, 0 );
		else this.sessiontimeout = createTimeSpan( 0, 0, 0, 1 );


	// ------------------------ APPLICATION MAPPINGS ------------------------ //
		this.mappings[ "/model" ] = this.applicationroot & "/model/";


	// ------------------------ ORM SETTINGS ------------------------ //
		this.ormenabled = false;
		this.ormsettings = {
			  dbcreate = "update"  // update  dropcreate  none
			, useDBForMapping = false  // caution when enabling this
			, flushatrequestend = true //Specifies whether ormflush should be called automatically at request end.
			, automanagesession = true //manage Hibernate session automatically
			, cfclocation = "/model" // path to persistent CFCs
			, eventhandling = true //Specifies whether ORM Event callbacks should be given.
			, eventhandler = "model.aop.globaleventhandler"
			, logsql = false
			, secondarycacheenabled = false 	
			
		};

	// ------------------------ FW/1 SETTINGS ------------------------ //
		variables.framework = {
			 defaultSection = 'main'
			,defaultItem = 'default'
			,routes = []
			,environments = {
						dev={ 
							 reloadApplicationOnEveryRequest = false
							,trace=false
							,Mode = 'DEV'
							,generateSES = true
							,SESOmitIndex = true
						}
						,prod={
							 reloadApplicationOnEveryRequest = false
							,cacheFileExists = true 
							,trace=false
							,reload = 'reload'
							,password = 'scrumworld'
							,Mode = 'PROD'
							,generateSES = true
							,SESOmitIndex = true
						}
				}
		};
	
	// ------------------------ FW/1 OVERIDES ------------------------ //
		/**
		* @output false
		* @displayname setupApplication
		* @hint Overide to provide application-specific initialization.
		* @author David Fairfield 
		* @autogeneratedOn Wednesday, January 8, 2014 4:20:47 PM PST
		*/
		   void function setupApplication() {
		        // bean factory should look in the model tree for files with bean, service and gateway in name
		        var bf = new framework.ioc( "/model" , { singletonPattern = "(service|gateway|bean)$" } );
		        setBeanFactory( bf );
		    }
	
		/**
		* @output false
		* @displayname setupRequest
		* @hint Overide to provide request-specific initialization.
		* @author David Fairfield 
		* @autogeneratedOn Wednesday, January 8, 2014 4:20:47 PM PST
		*/		
			void function setupRequest() {
				// set baseurl 
				request.context.baseURL = getBaseURL();
				
				// use setupRequest to do initialization per request
				request.context.startTime = getTickCount();
			}

		/**
		* @output false
		* @displayname setupResponse
		* @hint Overide to provide request-specific finalization.
		* @author David Fairfield 
		* @autogeneratedOn Wednesday, January 8, 2014 4:20:47 PM PST
		*/			
			void function setupResponse() {
				// Code to run after request ends
					
			}

		/**
		* @output false
		* @displayname getEnvironment
		* @hint Overide to provide environment-specific initialization.
		* @author David Fairfield 
		* @autogeneratedOn Wednesday, January 8, 2014 4:20:47 PM PST
		*/	
			string function getEnvironment(){
				var thisHostName = getHostName();
				var mode = 'dev';
		    	if ( findNoCase( 'dev-', thisHostName ) ) mode ='dev';
		    	if ( findNoCase( 'prd-', thisHostName ) ) mode = 'prod';
		 		// add additional environments    		
		    	return mode;
		    }

		public function getBaseURL(){
			var urlpath = replacenocase(cgi.script_name,'index.cfm','','all');
		
		if(cgi.https is "on"){
			return "https://#cgi.server_name##urlpath#";
		}else{
			return "http://#cgi.server_name##urlpath#";
		}

	}
}
