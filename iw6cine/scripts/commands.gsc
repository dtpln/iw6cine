/*
 *      IW6Cine
 *      Commands handler
 */

#include scripts\utils;

registerCommands()
{
    level endon( "disconnect" );

    // Misc
    self thread createCommand( "testWeapon",    " ",                                    " Set to 1",                            scripts\misc::testWeapon,                       0 );
    self thread createCommand( "clone",         "Create a clone of yourself",           " Set to 1",                            scripts\misc::clone,                            0 );
    self thread createCommand( "drop",          "Drop your current weapon",             " Set to 1",                            scripts\misc::drop,                             0 );
    self thread createCommand( "about",         "About the mod",                        " Set to 1",                            scripts\misc::about,                            0 );
    self thread createCommand( "clearbodies",   "Remove all player/bot corpses",        " Set to 1",                            scripts\misc::clear_bodies,                     0 );
    self thread createCommand( "viewhands",     "Change your viewmodel",                " <model_name>",                        scripts\misc::viewhands,                        0 );
    self thread createCommand( "eb_explosive",  "Explosion radius on bullet impact",    " <radius>",                            scripts\misc::expl_bullets,                     0 );
    self thread createCommand( "eb_magic",      "Kill bots within defined FOV value",   " <degrees>",                           scripts\misc::magc_bullets,                     0 );

    self thread createCommand( "spawn_model",   "Spawn model at your position",         " <model_name>",                            scripts\misc::spawn_model,                  1 );
    self thread createCommand( "spawn_fx",      "Spawn FX at your xhair",               " <fx_name>",                               scripts\misc::spawn_fx,                     1 );
    self thread createCommand( "vision",        "Change vision, reset on death",        " <vision>",                                scripts\misc::change_vision,                1 );
    self thread createCommand( "fog",           "Change ambient fog",                   " <start> <half> <r> <g> <b> <a> <time>",   scripts\misc::change_fog,                   1 );

    // Bots
    self thread createCommand( "bot_spawn",     "Add a bot",                            " <weapon_mp> <axis/allies> <camo_name>",   scripts\bots::add,                          1 );
    self thread createCommand( "bot_move",      "Move bot to xhair",                    " <bot_name>",                              scripts\bots::move,                         1 );
    self thread createCommand( "bot_aim",       "Make bot look at closest enemy",       " <bot_name>",                              scripts\bots::aim,                          1 );
    self thread createCommand( "bot_stare",     "Make bot stare at closest enemy",      " <bot_name>",                              scripts\bots::stare,                        1 );
    self thread createCommand( "bot_model",     "Swap bot model",                       " <bot_name> <MODEL> <axis/allies>",        scripts\bots::model,                        1 );
    self thread createCommand( "bot_kill",      "Kill bot",                             " <bot_name> <body/head/cash>",             scripts\bots::killBot,                      1 );
    self thread createCommand( "bot_holdgun",   "Toggle bots holding guns when dying",  " Set to 1",                                scripts\misc::toggle_holding,               1 );
    self thread createCommand( "bot_freeze",    "(Un)freeze bots",                      " Set to 1",                                scripts\misc::toggle_freeze,                1 );

    self thread createCommand( "bot_weapon",    "Give a bot a weapon",                  " <bot_name> <weapon_name> <camo_number>",  scripts\bots::weapon, 1);
                                                                            // Example:      bot1         kriss         44
    
    // Actors
    self thread createCommand( "actorback",     "Reset all actors to previous state",   " Set to 1",                                                scripts\actors::back,       0 );
    self thread createCommand( "actor_anim",    "Set actor's main animation",           " <actor_name> <anim_name>",                                scripts\actors::playanim,   1 );
    self thread createCommand( "actor_copy",    "Spawn a copy of an existing actor",    " <actor_name>",                                            scripts\actors::copy,       1 );
    self thread createCommand( "actor_death",   "Set actor's death animation",          " <actor_name> <anim_name>",                                scripts\actors::deathanim,  1 );
    self thread createCommand( "actor_spawn",   "Add an actor",                         " <body_model> <head_model>",                               scripts\actors::add,        1 );
    self thread createCommand( "actor_move",    "Move actor to xhair",                  " <actor_name>",                                            scripts\actors::move,       1 );
    self thread createCommand( "actor_health",  "Set actor's health",                   " <actor_name>",                                            scripts\actors::hp,         1 );
    self thread createCommand( "actor_model",   "Change actor's head and body",         " <actor_name> <body_model> <head_model>",                  scripts\actors::model,      1 );
    self thread createCommand( "actor_weapon",  "Attach weapon or model to tag",        " <actor_name> <tag_name> <weapon_mp/model/delete> <camo>", scripts\actors::equip,      1 );
    self thread createCommand( "actor_gopro",   "Fixed camera on actor tag",            " <actor_name> <tag_name> <x> <y> <z> <yaw> <pitch> <roll>",scripts\actors::gopro,      1 );
    self thread createCommand( "actor_fx",      "Play FX on tag or action",             " <actor_name> <tag_name> <fx_name> <when>",                scripts\actors::efx,        1 );

    // Camera
    self thread createCommand( "cam_mode",      "Change cam mode",                      " <linear/bezier>",                                         scripts\cam::camsetmode,    1 );
    self thread createCommand( "cam_rot",       "Camera rotation",                      " <rotation in degrees>",                                   scripts\cam::camsetrot,     1 );
    self thread createCommand( "cam_save",      "Save camera node",                     " <node # starting from 1>",                                scripts\cam::camsavenode,   1 );
    self thread createCommand( "cam_start",     "Camera start",                         " <speed if bezier, time if linear>",                       scripts\cam::camstartpath,  1 );
}

createCommand( command, desc, usage, callback, use_prefix )
{
    self endon( "disconnect" );

    prefix = "";
    if( ( use_prefix ) == 1 )
    {
        prefix = level.COMMAND_PREFIX + "_";
            setDvar( prefix + command, desc );
    }
    else    setDvar( command, desc );

    for (;;)
    {
        if( ( use_prefix ) == 1 )
        {
            while( getDvar( prefix + command ) == desc )
                wait 0.5;

                args = StrTok( getDvar( prefix + command ), " " );
                if ( args.size >= 1 )   self [[callback]]( args );
                else                    self [[callback]]();
        }
        else
        {
            while( getdvar( command ) == desc )
                wait .05;

                args = StrTok( getDvar( command ), " " );
                if ( args.size >= 1 )   self [[callback]]( args );
                else                    self [[callback]]();           
        }

        if((use_prefix) == 1)
        {
            prefix = level.COMMAND_PREFIX + "_";
            setDvar( prefix + command, desc );
        }
        else
            setDvar( command, desc );
        wait 0.05;
    }
}