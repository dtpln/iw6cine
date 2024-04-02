/*
 *      IW6Cine
 *      Bots functions
 */

#include common_scripts\utility;
#include scripts\utils;
#include maps\mp\_utility;
#include maps\mp\gametypes\_class;
#include scripts\defaults;

add( args )
{
    team = args[0];

    ent = level thread maps\mp\bots\_bots::spawn_bots( 1, team, undefined, undefined, "spawned_" + team, "recruit" );
    waitframe();
    ent thread persistence();
    ent thread spawnme( self );
    ent thread attach_weapons();
    create_kill_params();
}

persistence()
{
    self.pers["isBot"]      = true;     // is bot
    self.pers["isStaring"]  = false;    // is in "staring mode"
    self.pers["fakeModel"]  = false;    // has the bot's model been changed?
}

spawnme( owner )
{
    self endon( "disconnect" );
    for(;;)
    {
        self waittill( "spawned_player" );
        wait 2;
        self setOrigin( at_crosshair( owner ) );
        self save_spawn();
        self freezeControls( true );
    }
}

move( args )
{
    name = args[0];
    foreach( player in level.players )
    {
        if( issubstr( player.name, args[0] ) ) {
            
            player setOrigin( at_crosshair( self ) );
            player save_spawn();
            player freezeControls( true );
        }
    }
}

aim( args )
{
    name = args[0];
    foreach( player in level.players )
    {
        if( issubstr( player.name, args[0] ) ) {
            player thread doaim();
            wait 0.5;
            player notify( "stopaim" );
        }
    }
}

stare( args )
{
    name = args[0];
    foreach( player in level.players )
    {
        if( issubstr( player.name, args[0] ) ) {
            player.pers["isStaring"] ^= 1;
            if ( player.pers["isStaring"] ) player thread doaim();
            else player notify( "stopaim" );
        }
    }
}

model( args )
{
    name  = args[0];
    model = args[1];
    team  = args[2];
    foreach( player in level.players )
    {
        if( issubstr( player.name, args[0] ) ) {
            player.pers["fakeTeam"]  = team;
            player.pers["fakeModel"] = model;

            player detachAll();
            skipframe();
            player setModel( model );

            if( isdefined ( player.pers["viewmodel"] ) )
                player setViewmodel( player.pers["viewmodel"] );
        }
    }
}

doaim()
{
    self endon( "disconnect" );
    self endon( "stopaim" );

    for (;;)
    {
        wait .05;   // waittillframeend makes the loop too fast (?) and the game yeets itself off the mortal plane from whence it came
        target = undefined;

        foreach( player in level.players )
        {
            if ( ( player == self ) || ( level.teamBased && self.pers["team"] == player.pers["team"] ) || ( !isAlive( player) ) )
                continue;

            if ( isDefined( target ) ) {
                if ( closer ( self getTagOrigin( "j_head" ), player getTagOrigin( "j_head" ), target getTagOrigin( "j_head" ) ) )
                    target = player;
            }
            else target = player;
        }

        if ( isDefined( target ) )
            self setPlayerAngles( VectorToAngles( ( target getTagOrigin( "j_head" ) ) - ( self getTagOrigin( "j_head" ) ) ) );
    }
}

killBot( args )
{
    name = args[0];
    mode = args[1];
    foreach( player in level.players )
    {
        if (isSubStr(player.name, args[0])) {
            parameters  = strTok( level.killparams[mode], ":" );
            fx          = parameters[0];
            tag         = player getTagOrigin( parameters[1] );
            hitloc      = parameters[2];

            player thread [[level.callbackPlayerDamage]]( player, player.name , player.health, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), tag, tag, hitloc, 0 );
                                                                // ^^ - can be changed to player.name for true suicide -- (no "watching killcam" ) 
        }
    }
}

create_kill_params()
{
    level.killparams             = [];
    level.killparams["body"]     = "flesh_body:j_spine4:body";
    level.killparams["head"]     = "flesh_head:j_head:head";
    level.killparams["shotgun"]  = "flesh_body:j_knee_ri:body"; // REDO ME!!
    level.killparams["cash"]     = "money:j_spine4:body";
}

// This absolutely sucks redo me
delay( args )
{
    //time = args[0];
    setDvarIfUninitialized( "scr_killcam_time",      level.BOT_SPAWN_DELAY/2 );
    setDvarIfUninitialized( "scr_killcam_posttime",  level.BOT_SPAWN_DELAY/2 );
}

attach_weapons()
{
    for(;;)
    {
        wait 1; // take the wait from misc\reset_models() into account
        currWeap = self getCurrentWeapon();
        if ( level.BOT_WEAPHOLD && isBot( self ) )
        {
            self.replica = getWeaponModel( currWeap );
            self attach( self.replica, "j_gun", true );
        }
    }
}

weapon( args ) // Just type weapon name. Example: usr bluntforce
{
    name = args[0];
    weapon = args[1];
    camo = args[2]; // Camo name, reference function get_camo_num.
    foreach( player in level.players )
    {
        if( issubstr( player.name, args[0] ) ) 
        {
            currWeapon = self getCurrentWeapon();
            player takeWeapon( currWeapon );
            player giveWeapon( "iw6_" + weapon + "_mp_camo" + get_camo_num(camo) );
            player setSpawnWeapon( "iw6_" + weapon + "_mp_camo" + get_camo_num(camo) );
            wait 1;
            player thread attach_weapons();
        }
    }
}

get_camo_num(tracker)
{
    wait .5;
    switch (tracker)
	{
		case "snow":
			return 27;
		case "brush":
			return 20;
		case "autumn":
			return 19;
		case "ocean":
			return 25;
		case "scale":
			return 28;
		case "red":
			return 26;
		case "caustic":
			return 21;
		case "crocodile":
			return 22;
        case "green":
			return 23;
        case "net":
            return 24;
        case "trail":
            return 29;
        case "woodland":
            return 30;
        case "gold":
            return 01;
        case "leopard":
            return 36;
        case "abstract":
            return 42;
        case "hydra":
            return 43;
        case "skulls":
            return 44;
        case "tattoo":
            return 45;
        case "nebula":
            return 46;
        case "flags":
            return 41;
        case "unicorn":
            return 39;
        case "heavymetal":
            return 38;
        case "koi":
            return 35;
        case "fitness":
            return 34;
        case "extinction":
            return 11;
        case "bling":
            return 08;
        case "aw":
            return 06;
        case "soap":
            return 15;
        case "bluntforce":
            return 33;
        case "hex":
            return 09;
        case "eyeballs":
            return 32;
        case "1987":
            return 16;
        case "heartlands":
            return 17;
        case "molten":
            return 14;
        case "makarov":
            return 13;
        case "circuit":
            return 31;
        case "cats":
            return 10;
        case "price":
            return 37;
        case "ducky":
            return 40;
        case "inferno":
            return 07;
        case "bodycount":
            return 18;
        case "kissofdeath":
            return 02;
        case "warcry":
            return 03;
        case "festive":
            return 12;
        case "spectrum":
            return 04;
        case "ice":
            return 05;
		default:
			return 01;
	}
}