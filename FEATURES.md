# <p style="text-align: center;">**IW6CINE FEATURES AND ROADMAP**</p>

    Key: [x] = done
         [ ] = not done
         [^] = works, but needs to be fixed

**MISC FUNCTIONS**

    - [x]   clone             -- <set to 1>
    - [x]   drop              -- <set to 1>
    - [x]   about             -- <set to 1>
    - [x]   clearbodies       -- <set to 1>
    - [x]   viewhands         -- <model_name>
    - [x]   eb_explosive      -- <radius>
    - [x]   eb_magic          -- <degrees>
    - [x]   spawn_model       -- <model_name>
    - [x]   spawn_fx          -- <fx_name>
    - [x]   vision            -- <vision>
    - [x]   fog               -- <start end red green blue intensity opacity transition>

**BOT FUNCTIONS**

    - [x]   spawn             -- <axis/allies>
    - [x]   weapon            -- <bot_name> <weapon_name> <camo_name> // Please note, although every camo is included, some do not work.
    - [x]   move              -- <bot_name>
    - [x]   aim               -- <bot_name>
    - [x]   stare             -- <bot_name>
    - [x]   model             -- <full_model_name> // Ex: mp_fullbody_juggernaut_heavy_black
    - [x]   kill              -- <bot_name> <body/head>
    - [ ]   holdgun           -- <set to 1> // Currently doesn't work.
    - [x]   freeze            -- <set to 1>

**ACTOR FUNCTIONS**

    - [x]   actorback         -- <set to 1>
    - [x]   actor_anim        -- <actor_name> <anim_name>
    - [ ]   actor_copy   
    - [ ]   actor_death 
    - [x]   actor_spawn       -- <body_model> <head_model> <anim_name> <death_anim>
    - [x]   actor_move        -- <actor_name>
    - [ ]   actor_health  
    - [ ]   actor_model   
    - [ ]   actor_weapon 
    - [ ]   actor_gopro 
    - [ ]   actor_fx

**CAMERA FUNCTIONS**

    - [x]   mode              -- <linear/bezier>
    - [x]   rot               -- <degrees>
    - [x]   save              -- <node # starting from 1>
    - [x]   start             -- <speed if bezier, time if linear>
    
</br><br/>
**PLANNED FEATURES**
    
    - [ ]   actors - full support.
    - [ ]   bots   - better way to spawn, etc, all the normal stuff.