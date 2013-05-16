module dtutor.api;
import vibe.core.core;
import vibe.http.rest;
import vibe.http.router;
import vibe.http.server;

shared static this()
{
    auto settings   = new HttpServerSettings;
    auto routes     = new UrlRouter;
	
    registerRestInterface( routes, new Apiv1, "/api/v1/" );

    settings.port   = 8080;

    listenHttp( settings, routes );
}


interface Api
{
    string getName(); 
}


final class Apiv1 : Api
{
    string getName()
    {
        return "hell.";
    }
}
