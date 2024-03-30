/*
 * 		IW6Cine
 *		Entry point
 */
#include scripts\utils;
init()
{
    scripts\defaults::load_defaults();
    scripts\precache::common_precache();
    scripts\precache::custom_precache();
    scripts\precache::fx_precache();

    level.cam = [];
    level.cam["type"] = "bezier";
    level.disablespawncamera = 1;
    level.BOT_FREEZE = 1;

    level.actors = [];
    level thread waitForHost();
}

waitForHost()
{
    level waittill( "connecting", player );

    if( isBot( player) )
        player thread onBotSpawned();
    else 
    {
        player scripts\commands::registerCommands();
        scripts\utils::skip_prematch();
        scripts\utils::match_tweaks();
        scripts\utils::lod_tweaks();
        scripts\utils::hud_tweaks();
        scripts\utils::score_tweaks();

        player thread scripts\misc::welcome();
        player thread onPlayerSpawned();
    }
}


onPlayerSpawned()
{
    self endon("disconnect");

    self scripts\player::playerRegenAmmo();
    self thread scripts\misc::class_swap();
    self thread scripts\utils::bots_tweaks();
    for(;;)
    {
        self waittill("spawned_player");

        // Only stuff that gets reset/removed because of death goes here
        self scripts\player::movementTweaks();
        self scripts\misc::reset_models();
    }
}

onBotSpawned()
{
    self endon("disconnect");

    for(;;)
    {
        self waittill("spawned_player");
        self freezeControls( true );
        if( isBot( self ) )
            self thread scripts\bots::attach_weapons();
    }
}