#charset "us-ascii"

/*
 * The Queen's Heart, by Zach Tomaszewski.  25 Jan 2013.
 * Written as part of Global Game Jam, 2013.
 * 
 * Requires TADS, and built from TADS starting files:
 * Copyright (c) 1999, 2002 by Michael J. Roberts.  Permission is granted to
 * anyone to copy and use this file for any purpose.
 *
 */
#include <adv3.h>
#include <en_us.h>

/*
 * Game credits and version information.  
 */
versionInfo: GameID
    IFID = '6f350921-e90b-419a-b82f-7df4be590a4d'
    name = 'The Queen\'s Heart'
    byline = 'by Zach Tomaszewski'
    htmlByline = 'by <a href="mailto:zach.tomaszewski@gmail.com">
                  Zach Tomaszewski</a>'
    version = '1'
    authorEmail = 'Zach Tomaszewski <zach.tomaszewski@gmail.com>'
    desc = 'Through the long years, a lone goblin knight tends to his 
        slumbering queen... until a little human girl falls down a well 
        and into his world.'
    htmlDesc = 'Through the long years, a lone goblin knight tends to his 
        slumbering queen... until a little human girl falls down a well 
        and into his world.'
;

gameMain: GameMainDef
    /* the initial player character is 'me' */
    initialPlayerChar = me
    
    showIntro() {
        """You stand in the dark, listening.
        \b
        You can hear a faint scratching... a sort of scurrying... No, it's a 
        <i>burrowing</i>... Yes, definitely a burrowing sound... though a
        rather leisurely one.  Too leisurely for a badger, which leaves only one 
        thing that it can be: a mole.  There's a mole burrowing through the soft 
        earth to your right.
        \b
        You look down at the earthworms in your hand.  "A bit of mole-fishing,
        then?" you ask yourself.  "A fresh mole for the Queen, my love, to 
        grant her the strength she needs?" You feel the warmth of a blush
        on your face, a rush of blood.  You only call the queen "your love" in
        the most secret and lonely of places, like down here in the tunnels.
        \b
        You glance around carefully, first down the tunnel one way and then
        the other.  No one to see you, no one to hear.  No one else in a long
        long time.
        \b
        You see dimly but well enough in the dark, though you could walk and 
        hunt these tunnels blindfolded if you wanted to.  
        You've guarded them for so long that you know every twist and turn, every bump
        of moist soil.  As the last of the Goblin Guard, this is your domain:
        The Warren of the Eternal Queen (may she protect us all).
        \b
        The earthworms are wriggling, and they bring you back to the task at
        hand.  "Right then.  Worms or mole for dinner?"  
        \b
        No one answers.
        \b""";
/*        
 *   <b><<versionInfo.name>></b>\n <<versionInfo.byline>> (ZoloDog @
 *   GlobalGameJam13)\n
 */
        """\b[Type HELP for instructions on how to play.]\b       
        """;
    }    
;

/*
 * Our goblin protagonist.
 */
me: Actor
   location = the_tunnels
;

/* 
 * The maze of tunnels that forms the bulk of the warren.
 */
the_tunnels: Room 'The Tunnels'
    "Twisting tunnels stretch off in all directions through the raw earth.  
    Here and there, stone arches and wooden support beams shore up the weight
    of the soil above."
    
    north = the_great_seal
    east = the_well
    west = the_queens_chambers
;

/*
 * A unopenable barrier to the outside world.
 */
the_great_seal: Room 'The Great Seal'
    "A great stone..."
    
    south = the_tunnels
;

/*
 * The well, though the goblin thinks of it as the pool.
 */
the_well: Room 'The Pool'
    "Water here..."
    
    west = the_tunnels
;

/*
 * The Queen's resting place.
 */
the_queens_chambers: Room 'The Queen\'s Chambers'
    "Queen..."
    
    east = the_tunnels
;






