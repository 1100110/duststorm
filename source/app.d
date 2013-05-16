import std.conv, std.stdio, std.file, vibe.d, scrypt.password;
import dtutor.api, dtutor.info;

// Create Immutable Data
immutable VersionNumber = "0.0.1";
immutable VersionName   = "duststorm";

shared static this() 
{
    initialize();
    // Init Required Classes...
    auto settings   = new HttpServerSettings;
    auto router     = new UrlRouter;

    // Init Required Settings...
    settings.port   = 8080;
    settings.errorPageHandler = toDelegate( &errorPage );
   
    // Setup Default Routing...
    router.get( "*",    serveStaticFiles( "./public/" ) );
    router.get( "/",    staticTemplate!"index.dt"       );


    listenHttp( settings, router );
}

private shared static void initialize() 
{   // Move these if they exist.
    if( existsFile( ".log/trace.log" ))
        moveFile( ".log/trace.log", ".log/trace.old.log" );
    // Really simple 'backups'
    if( existsFile( ".log/warn.log" ))
        moveFile( ".log/warn.log", ".log/warn.old.log" );
    
    setPlainLogging( false );
    setLogFile( ".log/warn.log",  LogLevel.Warn );
    setLogFile( ".log/trace.log", LogLevel.Trace);
    
    enableWorkerThreads();
}

// Handles Error Page Generation
static void errorPage(  HttpServerRequest req, 
                        HttpServerResponse res, 
                        HttpServerErrorInfo err) {
    res.renderCompat!("error.dt", HttpServerRequest,   "req",
                                  HttpServerErrorInfo, "err")(req, err);
}
