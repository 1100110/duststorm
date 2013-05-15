import vibe.d;

// Create Immutable Data
immutable VersionNumber = "0.0.1";
immutable VersionName   = "duststorm";

/// Startup Code
shared static this()
{ 
    // General Setup
    setPlainLogging( false );
    setLogLevel( LogLevel.Debug );
    setLogFile( "duststorm.log" );
    
    // Init Required Classes
    auto settings = new HttpServerSettings;
    auto router   = new UrlRouter;

    // Init Required Settings
    debug settings.port = 8080;
    settings.errorPageHandler = toDelegate( &errorPage );
   
    // Setup Default Routing.
    router.get( "*",    serveStaticFiles( "./public/" ));
    router.get( "/",    staticTemplate!"index.dt" );

    // Start the Event Loop
    listenHttp( settings, router );
}


/// Handles Error page generation.
void errorPage( HttpServerRequest   req, 
                HttpServerResponse  res, 
                HttpServerErrorInfo err) {
    
    res.renderCompat!("error.dt", HttpServerRequest,   "req",
                                  HttpServerErrorInfo, "err")(req, err);
}
