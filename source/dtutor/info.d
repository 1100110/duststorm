module dtutor.info;
import std.array, std.conv, std.file;
import vibe.core.core, vibe.core.log, vibe.core.concurrency;
import core.time;

/// Start A New Thread/Fiber, loop until shutdown.
shared static this()  {
    /// Init Log Files
    //setPlainLogging( false );
    //setLogLevel( LogLevel.None );

    /// Let the program get started, can cause a race condition if missing.
    sleep( 16.dur!"seconds" );
    
    // Careful you don't block anything, and write a log file while you're at it.
    runTask({
        while(true) { // Same old staying out of the way
            //no seriously, stay out of the way.        
            logDebug( "Program Status: %s", Info.status  );
            yield();
            sleep( 1.dur!"seconds" );

            logDebug( "Memory Info: %s",    Info.memInfo );
            yield();
            sleep( 1.dur!"seconds" );

            logDebug( "Load Average: %s",   Info.loadAvg );
            yield();
            sleep( 1.dur!"seconds" );
            
            sleep( 16.dur!"seconds" );
        }
    });
}

// PRIVATE, TODO: create public functions that only 
package struct Info {
    // just some locations
    immutable procLoadAvg = "/proc/loadavg";
    immutable procMemInfo = "/proc/meminfo";
    immutable procSelf    = "/proc/self/status";
    // We are updating every 30 seconds, Let's not need to use the GC that often.
    static string[] lastStatus;
    static string[] lastMemInfo;
    static real[3]  lastLoadAvg;

    
    static string[] status() {
        return lastStatus = readText!string( procSelf ).split();
    }

    static real[3] loadAvg() {
        immutable txt = readText!string( procLoadAvg )[0..15];

        lastLoadAvg[0] = txt[ 0..4 ].to!real();
        lastLoadAvg[1] = txt[ 5..9 ].to!real();
        lastLoadAvg[2] = txt[10..14].to!real();

        return lastLoadAvg;
    }

    static string[] memInfo() {
        return lastMemInfo = readText!string( procMemInfo ).split();
    }
}
