module dtutor.info;
import std.algorithm, std.array, std.conv, std.file;
import vibe.core.core, vibe.core.log, vibe.core.concurrency;
import core.time;

shared static this() {
    
    runTask({
        sleep( 2.dur!"seconds" ); 
        //Let the program get started, can cause a race condition if missing.
        while(true) { // Same old same old staying out of the way
            logDebug( "Program Status: %s", Info.status  );
            sleep( 1.dur!"seconds" );

            logDebug( "Memory Info: %s",    Info.memInfo );
            sleep( 1.dur!"seconds" );

            logDebug( "Load Average: %s",   Info.loadAvg );
            
            sleep( 16.dur!"seconds" );
        }
    });

    //logInfo ( "%s", Info.sizeof);// 1 byte
}


package struct Info {
    // just some locations
    enum procLoadAvg = "/proc/loadavg";
    enum procMemInfo = "/proc/meminfo";
    enum procSelf    = "/proc/self/status";
    
    // We are updating every 30 seconds or so, 
    // We will only have two statuses, the next one and the last one.
    // Just reuse the var rather than re-init'ing (is that a word?)
    static string[] lastMemInfo;
    static string[] lastStatus;
    static real[3]  lastLoadAvg;

    
    static string[] status() {
        return lastStatus = readText!string( procSelf ).split();
    }

    static real[3] loadAvg() {
        immutable txt = readText( procLoadAvg )[0..15];

        lastLoadAvg[0] = txt[ 0..4 ].to!real();
        lastLoadAvg[1] = txt[ 5..9 ].to!real();
        lastLoadAvg[2] = txt[10..14].to!real();

        return lastLoadAvg;
    }

    static string[] memInfo() {
        return lastMemInfo = readText( procMemInfo ).split();
    }
}
