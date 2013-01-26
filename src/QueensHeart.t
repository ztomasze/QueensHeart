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
        """You stand alone in the dark, sorrow in your heart and earthworms in 
        your hand.
        \b
        You stand listening.
        \b
        You can hear a faint scratching... a sort of scurrying... No, it is a 
        <i>burrowing</i>... Yes, it is definitely a burrowing sound... though a
        rather small one.  Too small for a badger, too steady for a rabbit, 
        which leaves only one thing: a mole.  There's a mole burrowing through 
        the soft earth to your right.
        \b
        You look down at the earthworms in your hand.  "A bit of mole-fishing,
        then?" you ask yourself.  "A fresh mole for the Queen, my love, to 
        grant her the strength she needs?" You feel the warmth of a blush
        on your face, a rush of blood.  You only call the queen "your love" in
        the most secret and lonely of places, like down here in the tunnels.
        \b
        You glance around carefully, first down the tunnel one way and then
        the other.  No one to see you, and no one to hear.  No one else in a 
        long long time.
        \b
        You see dimly but well enough in the dark, though you could walk and 
        hunt through these tunnels blindfolded if you wanted to.  
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
   location = the_western_tunnels
   deluded = true
;

+ sorrow: Thing 'sorrow' 'sorrow'
    "Sometimes your sorrow is a dark void in your chest, sometimes it
    is a gray weight between your shoulders, and sometimes it is an
    languid emptiness everywhere. At the moment, it is 
    <<if self.weight < 0>> not so heavy.
    <<else if self.weight == 0>> a heavy burden.
    <<else if self.weight == 1>> very heavy.
    <<else>> a crushing weight.<<end>>"
    
    //TODO: customize better based on weight
    //TODO: feel, not look
    weight = 0
    
    dobjFor(Drop) {
        check() {failCheck('If only it were that easy to be free of your sorrow.');}
    }
;

+ worms: Food 'earth worms/earthworms' 'earthworms'
    "Cool and glistening, the earthworms slowly writhe in their consternation.  
     It tickles a little when they do that."
    isPlural = true
    dobjFor(Attack) {
        verify() {return true;}
        action() {
            "You smoosh and smear the worms into a paste between your palms.
            Then you lick the paste off.
            \b
            \"Ick. I always seem to forget that worms taste better whole.\"
            \b
            You sigh quietly to yourself.";
            self.moveInto(nil);
        }
    }
    dobjFor(Drop) {
        action() {
            inherited();
            if (me.location == the_western_tunnels && mole.inHole) {
                mole.moved = true;
                mole.inHole = false;
                extraReport('\bThe worms wriggle there for a while.
                    \b
                    After a moment, the mole pushes his nose a little
                    farther out of his hole.  He twitches it in your direction,
                    but goblins are not easily detected when they don\'t want 
                    to be.\b
                    The mole pushes its plump body out of the hole and 
                    hurries over to the earthworms.');
            }
        }
    }
    dobjFor(Eat) {
        action() { 
            inherited;
            "You slurp them down one a time.  They are better that way,
            like cold fat snotty noodles.  Sometimes they can be bitter or gritty if
            you chew them first.";          
        }
    }
;

+ sword : Thing 'sword/blade' 'sword'
    "It is <<me.deluded ? 
      "one of the rare ever-shiny bronze blades of the Goblin Royal Guard." :
      "a dinged and tarnished old sword, green with patina.">>"
    iobjFor(AttackWith) {
        verify() { return true;}
    }
    dobjFor(Drop) {
        check() { 
            if (me.deluded) 
                failCheck('"A goblin knight should be ever-ready and ever-armed", you
                repeat to yourself. You cannot bear to part with your sword
                so casually.');
        }
    }
;


/* 
 * The maze of tunnels that forms the bulk of the warren.
 */
the_western_tunnels: Room 'The Western Tunnels'
    "Twisting tunnels stretch off in all directions through the raw earth.  
    Here and there, stone arches and wooden support beams shore up the weight
    of the soil above.  The soil is a little drier here than to the east."
    
//    north = the_great_seal
    east = the_eastern_tunnels
    west = the_queens_chambers
    
    leavingRoom(traveler) {
        if (mole.alive) {
            mole.moveInto(nil);
            mole.inHole = false;
            "The mole scurries far back into his hole and disappears.";
        }
    }

;

+ Decoration 'stone arch*arches' 'stone arches';
+ Decoration 'wooden support beam*beams' 'support beams';
//FIX: not plural in "get" message, etc.

+ mole : Food 'mole' '<<!self.alive ? 'dead ' : ''>>mole'
    "<<self.alive ? "It is a young mole with soft brown fur and muddy paws.
        It is wrinkling its nose at you as it sniffs the air in that puzzled
        near-sighted way that moles do." :
        "The mole is crumpled, wrinkled, and smeared with blood.  Its little
        nose isn't wrinkling or moving now.">>"
    alive = true
    inHole = true
    taken = false
    initSpecialDesc = "A mole is poking the tip of his nose out of a small hole."
    initDesc = "All you can see of the mole at the moment is the pink tip of his
        twitching nose."
    
    dobjFor(Take) {
        check() {
            if (self.inHole) {
                failCheck('Not while he is still in that hole.');
            }else if (self.alive) {
                failCheck('Moles are faster than they look.  If you just try to 
                    pick him up, he\'ll be back into his hole before you can grab him.');
            }
        }
        action() {
            inherited;
            if (!mole.taken) {
                mole.taken = true;
                "When the sticky limp body of the mole sags in your hand, your 
                sorrow feels a little heavier.";
                sorrow.weight++;
            }
        }
    }
    dobjFor(AttackWith) {
        check() { if (iobj == sword) return true;}
        action() {
            mole.alive = false;
            "You draw your sword slowly, then bring it down quickly on the mole.
            You hear the little snap--like that of a spring twig--as its neck
            breaks.  There is a little blood, but not much.  Still, you can smell
            the iron in it.  This mole has been near Man recently.";
        }
    }
    dobjFor(Attack) {
        action() {
            mole.alive = false;
            "You fall suddenly onto the mole, wrapping your long fingers around it.
            It squirms free with a squeak, but you snatch at it again, squeezing it
            tight.  You can feel tiny bones snapping.  You bury your sharp teeth
            into the mole's throat.  The iron in its blood tingles and burns in 
            your mouth.  You drop the mole in surpise, but the tingling quickly
            subsides.
            \b
            \"Filthy little mole, tainted by the cold iron of Man, aren't you?
            Nevermind. Good for the Ward, you'll be.\"
            \b
            The mole does not answer.";            
        }
    }
;


the_eastern_tunnels: Room 'The Eastern Tunnels'
    "Twisting tunnels stretch off in all directions through the raw earth.  
    Here and there, stone arches and wooden support beams shore up the weight
    of the soil above.  The soil is a little moister here than to the west."
    
//    north = the_great_seal
    east = the_well
    west = the_western_tunnels
;
+ Decoration 'stone arch*arches' 'stone arches';
+ Decoration 'wooden support beam*beams' 'support beams';


/*
 * A unopenable barrier to the outside world.
 */
the_great_seal: Room 'The Great Seal'
    "A great stone..."
    
    south = the_western_tunnels
;

/*
 * The well, though the goblin thinks of it as the pool.
 */
the_well: Room 'The Pool'
    "Water here..."
    
    west = the_eastern_tunnels
;

/*
 * The Queen's resting place.
 */
the_queens_chambers: Room 'The Queen\'s Chambers'
    "Queen..."
    
    east = the_western_tunnels
;

/*
 * New verbs
 */
DefineIAction(Help)
    execAction() { 
        mainReport('This game is an example of interactive fiction.
      Read the descriptions of what is happening and then type in commands
      specifying what you want your character (the goblin) to do next.
      \b
      Some sample commands include: LISTEN, WAIT, INVENTORY, EXAMINE SORROW, 
      GO EAST, and GET MOLE.'); 
    }
;

VerbRule(Help)
     'help' : HelpAction
;




