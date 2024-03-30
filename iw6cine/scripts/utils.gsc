/*
 *      IW6Cine
 *      Utilities
 */

#include common_scripts\utility;

// Macros
waitsec()
{ wait 1; }

waitframe()
{ wait 0.1; }

skipframe()
{ waittillframeend; }

pront( string ) // s/o simon for engraving "iProntLn" in my mind forever; this one is for you
{ foreach ( player in level.players ) player iPrintLn( string );  }

true_or_undef( cond )
{ if ( cond || !isdefined( cond ) ) return true; return false; }

defaultcase( cond, a, b )
{ if ( cond ) return a; return b; }

inarray( value, array, err )
{ foreach ( element in array ) { if ( element == value ) return true; } pront( err ); return false; }

bool( value )
{ if ( value ) return "ON"; return "OFF"; }


// Create thread for player spawns
create_spawn_thread( callback, args )
{
    self endon( "disconnect" );
    for(;;)
    {
        self waittill( "spawned_player" );
        if ( !isdefined( args ) ) 	
             self [[callback]]();
        else self [[callback]]( args );
    }
}


// Weapons-related functions
camo_int( int )
{
    return int( tableLookup( "mp/camoTable.csv", 1, int, 0 ) );
}

get_offhand_name( item )
{
    switch ( item )
    {
        case "flash_grenade_mp":
            return "flash";
        case "smoke_grenade_mp":
            return "smoke";
        case "flare_mp":
            return "flare";
        default:
            return item;
    }
}

// Gotta test all weapons and add them if needed
fake_killfeed_icon( weapon )
{
    switch ( weapon )
    {
        case "cheytac":
            return "intervention";
        case "m4":
            return "m4a1";
        case "masada":
            return "acr";
        default:
            return weapon;
    }
}

is_akimbo( weapon )
{
    if ( isSubStr( weapon.name, "akimbo" ) )
        return true;
    return false;
}


// QOL stuff
skip_prematch()
{
    thread maps\mp\gametypes\_gamelogic::matchStartTimer( "waiting_for_teams", 0 );
    thread maps\mp\gametypes\_gamelogic::matchStartTimer( "match_starting_in", 0 );
    level.prematchPeriodEnd = -1;
}

lod_tweaks()
{
    if( !level.VISUAL_LOD ) return;

    setDvar( "r_lodBiasRigid",   "-1000" );
    setDvar( "r_lodBiasSkinned", "-1000" );
}

hud_tweaks()
{
    setDvar( "g_TeamName_Allies",    "allies" );
    setDvar( "g_TeamName_Axis",      "axis" );
    setDvar( "scr_gameEnded",        !level.VISUAL_HUD );
    setDvar( "didyouknow",           " Sass' Cinematic Mod ");
    game["strings"]["change_class"] = " ";
}

match_tweaks()
{
    if( level.MATCH_UNLIMITED_TIME )
        setDvar( "scr_" + level.gameType + "_timelimit", 0 );

    if( level.MATCH_UNLIMITED_SCORE ) {
        setDvar( "scr_" + level.gameType + "_scorelimit", 0 );
        setDvar( "scr_" + level.gameType + "_winlimit", 0 );
    }
}

// TEST ME
score_tweaks()
{
    maps\mp\gametypes\_rank::registerScoreInfo( "kill",  level.MATCH_KILL_SCORE );

    if ( level.MATCH_KILL_BONUS )
    {
        maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
        maps\mp\gametypes\_rank::registerScoreInfo( "execution", 100 );
        maps\mp\gametypes\_rank::registerScoreInfo( "avenger", 50 );
        maps\mp\gametypes\_rank::registerScoreInfo( "defender", 50 );
        maps\mp\gametypes\_rank::registerScoreInfo( "posthumous", 25 );
        maps\mp\gametypes\_rank::registerScoreInfo( "revenge", 50 );
        maps\mp\gametypes\_rank::registerScoreInfo( "double", 50 );
        maps\mp\gametypes\_rank::registerScoreInfo( "triple", 75 );
        maps\mp\gametypes\_rank::registerScoreInfo( "multi", 100 );
        maps\mp\gametypes\_rank::registerScoreInfo( "buzzkill", 100 );
        maps\mp\gametypes\_rank::registerScoreInfo( "firstblood", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "comeback", 100 );
        maps\mp\gametypes\_rank::registerScoreInfo( "longshot", 50 );
        maps\mp\gametypes\_rank::registerScoreInfo( "assistedsuicide", 100 );
        maps\mp\gametypes\_rank::registerScoreInfo( "knifethrow", 100 );
    }
    else 
    {
        maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "execution", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "avenger", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "defender", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "posthumous", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "revenge", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "double", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "triple", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "multi", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "buzzkill", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "firstblood", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "comeback", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "longshot", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "assistedsuicide", 0 );
        maps\mp\gametypes\_rank::registerScoreInfo( "knifethrow", 0 );
    }
}


// Player & Bots manipulation
is_bot()
{
    if ( self isHost() )
        return false;
    if ( true_or_undef( self.pers["isBot"] ) )
        return true;

    // not sure it ever reaches this but yea
    return false;
}

at_crosshair( ent )
{
    return BulletTrace( ent getTagOrigin( "tag_eye" ), anglestoforward( ent getPlayerAngles() ) * 100000, true, ent )["position"];
}

save_spawn()
{
    self.saved_origin = self.origin;
    self.saved_angles = self getPlayerAngles();
}

load_spawn()
{
    self setOrigin( self.saved_origin );
    self setPlayerAngles( self.saved_angles );
}

select_ents( ent, name, player )
{
    if ( isSubStr( ent.name, name ) || isSubStr( ent["name"], name )  || 
       ( name == "look" && inside_fov( player, ent["hitbox"], 10 ) )  || 
       ( name == "look" && inside_fov( player, ent, 10 ) )            || 
         name == "all" ) 
        return true;
    return false;
}

inside_fov( player, target, fov )
{
    normal = vectorNormalize( target.origin - player getEye() );
    forward = anglesToForward( player getPlayerAngles() );
    dot = vectorDot( forward, normal );
    return dot >= cos( fov );
}