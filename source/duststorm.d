module duststorm;

import vibe.d;
import dtutor.api, dtutor.info;

// Create Immutable Data
immutable VersionNumber = "0.0.1";
immutable VersionName   = "duststorm";

shared static this() {

    setPlainLogging( false );
    setLogFile( ".log/warn.log",  LogLevel.Warn );
    setLogFile( ".log/trace.log", LogLevel.Trace);
    enableWorkerThreads();
    
    // Init Required Classes...
    auto settings   = new HttpServerSettings;
    auto router     = new UrlRouter;

    // Init Required Settings...
    settings.port   = 8080;
    settings.errorPageHandler = toDelegate( &errorPage );
   
    // Setup Default Routing...
    router.get( "*",    serveStaticFiles( "./public/" ));
    router.get( "/",    staticTemplate!"index.dt" );


    // Start the Event Loop
    listenHttp( settings, router );
}


shared static ~this()
{
    if( existsFile( ".log/trace.log" ) || existsFile( ".log/warn.log" )) {
        moveFile( ".log/trace.log", ".log/old.trace.log" );
        moveFile( ".log/warn.log",  ".log/old.warn.log"  );
    }
}

/// Handles Error Page Generation
static void errorPage(  HttpServerRequest req, 
                        HttpServerResponse res, 
                        HttpServerErrorInfo err) {
    
    res.renderCompat!("error.dt", HttpServerRequest,   "req",
                                  HttpServerErrorInfo, "err")(req, err);
}


void login( HttpServerRequest   req,
            HttpServerResponse  res)
{

}
