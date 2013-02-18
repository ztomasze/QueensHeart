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
        which leaves only one thing: a mole.  There is a mole burrowing through 
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
        
        "<hr><center><b><<versionInfo.name>></b>\n <<versionInfo.byline>>\n(ZoloDog @
        GlobalGameJam13)\n";
 
        """
        [Type HELP for instructions on how to play.]\b</center><hr>
        """;
        
        new Daemon(knot, &tighten, 5);
    }    
;

/*
 * Our goblin protagonist.
 */
me: Actor 
    name = 'goblin'
    location = the_western_tunnels
    deluded = true
;

+ sorrow: Thing 'sorrow' 'sorrow'
    "Sometimes your sorrow is a dark void in your chest, sometimes it
    is a gray weight between your shoulders, and sometimes it is a
    languid emptiness everywhere. At the moment, it is 
    <<if self.weight < 0>> not so heavy.
    <<else if self.weight == 0>> a heavy burden.
    <<else if self.weight == 1>> very heavy.
    <<else>> a crushing weight.<<end>>"
    
    //TODO: customize better based on weight
    //TODO: feel, not look
    isQualifiedName = true
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
            inherited;
            if (me.location == the_western_tunnels && mole.inHole) {
                mole.inHole = false;
                mole.moved = true;
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

knot: Thing 'knot in my your stomach/knot' 'knot in your stomach'
    //TODO: expand desc
    "It is a tightening sense of unease. You often feel this way when you are
    away from the Queen for too long.  What if something should happen to her?
    What if... what if she wasn't there?  What if you were alone?"
    tightness = 0
    
    tighten() {
        if (me.location == the_queens_chambers && self.tightness < 2) {
            //ignore incr
            return;
        }
        self.tightness++;
        "\b...\n";
        if (self.tightness <= 0) {
            //ignore
        }else if (self.tightness == 1) {
            self.moveInto(me);
            "You begin to feel a little nervous... as if you've forgotten something
            important.";
        }else if (self.tightness == 2) {
            "Your stomach tightens.  You wonder if everything is 
            okay...\n Of course, the Queen makes everything okay.";
        }else if (self.tightness == 3) {
            "Your palms are getting sweaty now.  Why do you feel like this?
            Something must surely be wrong... wrong with the Queen, perhaps?
            The urge to look upon her once more is very strong.";
        }else {
            "<<one of>>Your armpits are slick, and your back is sweaty.
            <<or>>You feel weak and dizzy.
            <<or>>You suddenly gag and shiver.<<shuffled>> 
            The sense of doom is nearly crushing you.  The Queen!  Does she
            still live?  Does her heart still beat in the darkness?\b
            <<one of>>\"Stupid, useless goblin!\" you sob at yourself.<<or>>
            \"One job!  You only have one job!\" you scream at yourself.  Then
            your vision blurs with tears.<<shuffled>>.\b            
            You have gone so long without checking, you fear what you might 
            find... but check you must!";
        }
    }
    
    relax() {
        self.tightness = 0;
        self.moveInto(nil);
        "The tension pours out of you.  Your breathing slows, and the knot in 
         your stomach loosens and disappears once more.";
    }
    
    dobjFor(Drop) {
        check() {failCheck('This agony is part of you.');}
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
        if (mole.alive && mole.inHole) {
            mole.moveInto(nil);
            mole.inHole = false;
            "The mole scurries far back into his hole and disappears.\n";
        }
    }
;
+ Decoration 'small hole' 'small hole'
  "The hole is barely big enough for the mole, and certainly too small for you.";
+ Decoration 'stone arch*arches' 'stone arches'
  "Fine goblin craftsmanship from ages past.";
+ Decoration 'wooden support beam*beams' 'support beams'
  "These are later additions to hold the tunnels up when the stone arches started to crack.
  On one of these wooden posts, you started tracking years, adding one scratch 
  every winter.  After a dozen scratches, you moved onto another post.  After
  a dozen posts, you stopped scratching.";
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
        verify() {
            if (self.inHole) {
                inaccessible('Not while he is still in that hole.');
            }else if (self.alive) {
                illogicalNow('Moles are faster than they look.  If you just try to 
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
        check() { 
            if (self.inHole) {
                failCheck('The mole is still safe in his hole.');
            }
            if (IndirectObject == sword) {
                return true; 
            }
            inherited;
            return;
        }
        action() {
            mole.alive = false;
            "You draw your sword slowly, then bring it down quickly on the mole.
            You hear the little snap--like that of a spring twig--as its neck
            breaks.  There is a little blood, but not much.  Still, you can smell
            the iron in it.  This mole has been near Man recently.";
        }
    }
    dobjFor(Attack) {
        check() {
            if (self.inHole) failCheck('The mole is still safe in his hole.');
        }
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
    "You stand at the mouth of a narrow tunnel that opens into a wide vertical shaft.
    A few feet below you, the shaft is filled with still water.  The walls
    of the shaft are lined with old flagstones, rounded by age.  The stones
    are slick with moisture near the water, but further up the shaft, stray 
    roots have poked between the stones.\b
    <<if self.open>><<self.dark ? " Stars glint through the ragged hole at the 
        top of the shaft." : " A beam of sunlight pours through a ragged hole above,
        reflecting off the water below and burning your eyes.">><<else>>
         Above you is only darkness.<<end>>"
    
    west = the_eastern_tunnels
    up: NoTravelMessage { "There seems no point to that: there is only darkness up there." }
    dark = false
    open = false
    
    introGirl() {
        the_well.open = true;
        wellHole.moveInto(the_well);
        girl.moveInto(the_well);
        girl.moved = nil;
        the_well.up = outside;
        girl.motionDaemon = new Daemon(girl, &motion, 1);
        "\b...\n
        Suddenly, to the east, you hear a distant crack, a scream, and a splash!";
        
    }
;
+shaft: Fixture 'shaft/wall*walls' 'shaft' 
    dobjFor(Examine) remapTo(Examine, the_well)
    dobjFor(Climb) remapTo(Up)
;
+ Decoration 'water/pool' 'water' 
    "You come here for drinking water sometimes.  The water is too far away for
    you to reach from here.  When you need water, you lower down a rag and then
    squeeze the water out of the rag.  You seem to have mislaid your rag 
    somewhere... but no matter.  You are not thirsty at the moment."; 
;
+ rock : Heavy 'large rock/stone/boulder' 'large rock'
    "This large rough grey stone once blocked the entrance to the tunnel.
     It is nearly as big as you are and takes all of your strength to move.
     It sits on the edge of the ledge."
    initSpecialDesc = "A large stone partly hides the entrance to the tunnel."
    dobjFor(Push) {
        action() {
            if (girl.location == the_well) {
                "You quietly get behind the stone and wait... wait until the
                girl moves directly below you.  Then you push, hard and fast,
                with all your strength.  
                \b
                The great rock groans and topples forward before the girl can move.  
                It strikes her hard, pushing her forward and carrying her below 
                the surface of the water.
                \b
                You watch the choppy ripples slowly subside on the surface of 
                the pool. \"Ever your protector, my Queen.  Ever shall we be
                safe.\"";
                rock.moveInto(nil);
                girl.alive = false;
                girl.moveInto(nil);
                girl.motionDaemon.removeEvent();
                the_well.up = noSunlightForMe;
            }else {
                "At the moment, there seems little reason to push the stone into 
                either the tunnel entrance behind you or into the pool below.";
            }
        }
    }
;

noSunlightForMe : FakeConnector
   travelDesc = "There is no point.  There is nothing up there for you.
                There will be only painful sunlight, cold iron, and Man.\n"
; 

wellHole: Fixture 'ragged well hole' 'ragged hole'
    "In the <<the_well.dark ? "starlight" : "sunlight">> now pouring through it,
    you can see that the top of the well shaft was actually capped by an ancient
    wooden cover of thick planks.  It must have rotted over the years, and then
    the little girl walked over it and broke through.
    <<if plank.location == wellHole>>
    \b
    One of the long planks is hanging down into the well, barely attached at the
    other end.<<end>>"
    
    dobjFor(Climb) remapTo(Climb, shaft)
;

+ plank: Fixture 'long wooden plank/cover' 'plank'
    "It is a long wooden plank, still attached to the old well-cover above, 
    but only barely."
;

girl: Fixture 'human girl/child' 'human child'
    "It is a skinny wet little girl with dark hair.  The cold water of the pool
    comes up to her waist. Even from here, you can smell the iron on her: 
    the taint of the world of Man, which drives all magic underground."
    
    initSpecialDesc = "A human girl stands in the water."
    alive = true
    motionDaemon = nil  
    motion() {  //handles the girl's motion
        if (me.location == the_well) {
            "\b...\n<<one of>>
            The girl tries to climb the slick flagstones, but she cannot get a grip.<<or>>
            The girl jumps, trying to grab a thick root that is sticking out between
            some of the higher flagstones.  The sound of her splashing failure 
            echoes up the shaft of the well.<<or>>
            The girl stands still for a while, looking around the well.<<or>>
            The girl wades across to the other side of the pool.<<or>>
            The girl looks up at the <<the_well.dark ? "starlight" : "sunlight">>
            pouring through the hole above.<<or>>
            The girl scans the walls of the well for other handholds.  You stand very still as
            her eyes pass over you.  Goblins are not easily detected when they don\'t want 
            to be.<<or>>
            The girl puts her face in her hands for a while.  You can hear her sniffling.<<or>>
            The girl yells something you can't make out up at the hole.  Her voice is
            distrubingly loud and alien to you.<<or>>
            The girl wraps her arms around herself, shivering.
            <<half shuffled>>";
        }else {
            "<<one of>>
            <<or>><<or>><<or>><<or>>
            \b...\nYou hear a splash from the direction of the pool.<<or>>
            \b...\nYou hear a very quiet sobbing from the direction of the pool.<<or>>
            \b...\nYou hear a hear a long yell from the direction of the pool.
            <<shuffled>>";
        }
    }
    begone() {
        self.motionDaemon.removeEvent();
        self.moveInto(nil);
        plankEnd.moveInto(the_well);
        plankEnd.moved = nil;
        plank.moveInto(nil);        
    }
;
    
/*
 * The Queen's resting place.
 */
the_queens_chambers: Room 'The Queen\'s Chambers'
    "This round room is lined in stone.  Although it is just as dark in here
    as the rest of the Warren, it always feels brighter to you.
    \b
    In the center of the room is a bier, surrounded by a protective mandala 
    etched upon the floor."
    
    east = the_western_tunnels
    
    enteringRoom(traveler) {
        "You stop and bow low as you enter the room.";
    }
;

+ Decoration 'bier/fur*furs' 'bier'
    "The bier is a hewn stone slab covered in multiple layers of furs.";

+ Fixture 'magic magical protective circle/mandala/ward' 'mandala'
    "The mandala is a protective Ward formed of swirls, runes, and glyphs etched 
    upon the floor in a large circle around the bier.  This ancient goblin magic 
    hides the queen from the ravages of time and iron.  You have spent countless
    hours--sometimes whole days--carefully tracing and retracing the lines in 
    chalk or in blood.  Of course, material rich in iron works best, 
    for \"like repels like.\""
    
    dobjFor(Trace) {
        verify() { return false;}
        action() {
            "You trace your fingers over the lines of the mandala, murmuring
            the incantations written there from memory.  This does not make the
            Ward any stronger, but it calms you a little.";
            knot.tightness = knot.tightness - 2;
            if (knot.tightness <= 0) {
                knot.moveInto(nil);
            }
        }
    }
;

+ queen: Fixture 'upon queen' 'Queen'
    "The Queen lies pale and slender beneath a fur blanket.  Her eyes are closed, 
    so you gaze upon her for a while.  As always, her serenity fills your chest 
    with a bittersweet ache.
    \b
    The Queen sleeps.  She will sleep until Man recedes from the Earth, until
    all cold iron rusts, until Nature calls the goblins once more into the 
    Green.
    \b
    You alone protect her while she slumbers.  You, alone.
    \b
    Her breath is so faint now that you cannot see the blanket rise or fall.
    Over her chest, there is a faint depression in the blanket where you have 
    so often laid your head, listening for the beating of her heart."
    
    properName = true
    initSpecialDesc = "The Queen slumbers still upon the bier.";   
;

++ SimpleNoise 'heart' 'heartbeat'
    desc {
      if (me.deluded) {
        "You take a deep breath, hold it tightly, and lay your head ever so gently 
        upon the Queen's chest.
        \b
        <sound src='beating.ogg' layer='foreground'>
        Straining your ears, you feel her heart faintly beating.";
        if (knot.tightness > 0) {
            " She lives! ";
            knot.relax();
        }
        if (!the_well.open) {
            the_well.open = true;
            new Fuse(the_well, &introGirl, 2);
        }
        if (!girl.alive) {
            "\b\"I have protected you, my Queen.  I will always protect you.
            Until Man recedes from the Earth, until all cold iron rusts, 
            until Nature calls us once more into the Green, I will protect you.
            \b
            And I will never be alone.\"";
            finishGameMsg('The End', []);    
        }
      }else {
        "Carefully, reverently, you lay your head upon the chest of the queen, 
        as you have done so many times before.  You let out a long sigh and 
        listen... but you hear nothing.
        \b
        Quivering, you take a deep breath, hold it, and listen again.  And now
        you feel it once more, faintly, that beating you know so well, the beating
        of the Queen's heart.
        \b
        Puzzled, you exhale.  The beating stops.
        \b
        You are a goblin, alone.  Your sorrow has never been so heavy.";
            finishGameMsg('The End', []);
      }
    }
;

outside : OutdoorRoom 'Outside'
    desc  {"You stand in an empty overgrown field.  There are no living 
        trees here, but some distance away you see a very wide smooth path.  
        Standing evenly along the side of the path are a row of branchless
        poles.  A tight cable runs from pole to pole.  The path and the cable
        run in a straight line as far as you can see in either direction.
        \b
        You feel naked and cold out here.  The very wind carries iron on it, 
        burning your skin.  You can feel it crushing your heart like ice forming
        around a blossom.  This world belongs to Man now, to the child down
        in the well.  But you are a goblin, one of the last.  
        \b
        This outside world will strip the magic and the glammer from you.";
        me.deluded = false;
    }
               
    down = the_well
    cannotGoThatWayMsg = 'There is nothing for you that way.  '
    
    leavingRoom(traveler) {
        if (girl.location == the_well) {
            "As you scramble back down through the hole in the well cover, 
            you hear a splintering crack beneath you.  You throw yourself to
            one side and then grab at a root with one hand as you start to slide
            into the well.  Beneath you, a heavy plank tears free
            of the well cover and falls into the water below.
            \b
            Clinging to the side of the well, you peer down.  You can see that 
            the plank landed on its end in the center of the pool and then 
            toppled against the far wall.  This formed
            a steep ramp.  The child is already clambering up the ramp, grabbing
            at roots, and dragging herself up out of the well.
            \b
            You carefully climb down to the tunnel ledge, you heart thumping in
            your chest.  Once there, you survey the damage to your pool.  Glancing
            up, you see that the girl is still here, staring down over the lip
            of the well.  It makes your skin crawl how she seems to be staring
            right at you... as if you had no goblin glammer left.
            \b
            Then the girl turns and disappears out of sight.  \"Good riddance!\"
            you mutter to yourself.  This whole experience has left you shaken
            and scared.";
            girl.begone();
        }
    }
;

+ Decoration 'road/path' 'path'
  "The makings of Man are best avoided."
;    
+ Decoration 'cable/rope' 'iron cable'
  "The makings of Man are best avoided."
;
+ Decoration 'pole*poles' 'pole'
  "The makings of Man are best avoided."    
;

+ plankEnd : Fixture 'end long plank/end' 'plank'
    "<<if me.location == outside>>
    It is the end of the long plank that hangs down into the well.  It is barely
    hanging on, thanks to a couple rusty nails.  It would only take a little push
    to send it down into the well.<<else>>
    One end of the heavy plank is submerged in the water, 
    while the other end leans on the far wall.<<end>>"

    initSpecialDesc = "<<if me.location == outside>>
        You can see the end of a long plank that hangs 
        down into the well.<<else>>
        A heavy plank, partially submerged in the water, leans against the far wall.<<end>>"
    
    cannotTakeMsg = 'The plank is too long and heavy to carry, but you could push it.'
    dobjFor(Push) {
        verify() { return false; }
        action() {
            if (self.location == the_well) {
                "The plank is too far way to reach.";
            }else {
            "You push the end of the plank.  The iron nails groan a little and the 
            plank starts to sway back and forth.  You can hear the girl move
            in the water below you.  You push a little harder and the nails pop free.
            The plank drops into the water with a splash.
            \b
            Peering down after it, you can see that the plank landed on its end
            in the center of the pool and then toppled against the wall.  This formed
            a steep ramp.  The child is already clambering up the ramp, grabbing
            at roots, and dragging herself up out of the well.
            \b
            She stands, panting and dripping before you.  She is over twice your
            height, and she stares at you with wide eyes.  You stand very still... 
            but you know she can see you here.  Your glammer is fading in this 
            outside world.
            \b
            Suddenly, she turns and runs.  She stops when she gets to the
            wide path and turns back to look at you.  Tentatively, she waves.
            Then she turns and runs on before you can decide how to reply.
            \b
            Oddly, your sorrow feels lighter than it has in a long long time.";
            sorrow.weight -= 2;
            
            girl.begone();
            }
        }
    }
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
      Some sample commands include: LOOK, EXAMINE SORROW, GO EAST, and GET MOLE.
      The directions you can move from the current location are listed in the
      header above the game text.
      \b
      You can complete all actions supported by this game using only these
      verbs/commands: LOOK, INVENTORY, WAIT, GO (direction), EXAMINE (object), 
      GET (object), DROP (object), KILL (creature), LISTEN to (object), 
      TRACE (object), CLIMB (object)
      \b
      Stuck? EXAMINE everything that might be interesting.  The resulting object 
      descriptions will sometimes give you hint as to what you might do next.');
    }
;
VerbRule(Help)
     'help' : HelpAction
;

DefineTAction(Trace);
VerbRule(Trace)
     ('trace' | 'retrace' | 'fix' | 'repair') singleDobj : TraceAction
     verbPhrase = 'trace/tracing (what)'
;

VerbRule(Listen)
    ('check' | 'check' 'on') singleDobj : ListenToAction
;
modify Thing
     dobjFor(Trace)
     {
       verify() 
       {
         illogical('Tracing {that dobj/him} would achieve very little. ');
       }
     }
;

//...............................

class SkaldUI: object
    
    /* 
     *   When determining affordances, should TAD's NonObviousVerifyResult be
     *   treated as obviously afforded?  If false, then non-obvious actions will
     *   appear likely to fail.
     */
    NON_OBVIOUS_IS_OBVIOUS = false
    
    /* 
     *   A LookupTable matching Action objects to a corresponding ['name',
     *   'preposition'].  The 'preposition' field is optional, but it is usual
     *   for TIActions.
     */
    verbNames = new LookupTable()  
    //XXX: could extract this from Action class names, though there would be
    // weird verbs like VagueAsk, and Travel rather than Go.
    
    /*
     *   Excutes the given command string, similarly to as if it had been typed
     *   at the command prompt.
     */
    executeCmd(cmdText) {
        //see: TADS3 > Technical Manual > "The Command Execution Cycle"
        local toks = Tokenizer.tokenize(cmdText);
        executeCommand(gPlayerChar, gPlayerChar, toks, true);        
    }
    
    /* 
     * Returns a list of all object currently in scope of the current
     * playerChar.  This is the same as gPlayerChar.
     */
    getObjectsInScope() {
        return libGlobal.playerChar.scopeList();
    }

    /* As getObjectsInScope(), but returns a list of the .name of the object. */
    getObjectNamesInScope() {
        return getObjectsInScope().mapAll({obj: obj.name});
    }
    
    /*
     *   Returns whether the following action is currently logically possible.
     *   This taps into TADS's verify cycle at a low (and somewhat hacky) level.
     *
     *   Uses dobj and iobj only for TAction and TIActions, as appropriate.
     *
     *   Returns 0 if the action is clearly not afforded (TADS: "illogical",
     *   "illogicalSelf", or "inaccessible"). 
     * 
     *   Returns > 0 if the action is clearly afforded ("logical"
     *   in some manner, even if the ranking is low).  
     * 
     *   Returns < 0 if the action is only weakly afforded in
     *   some way (any of the other TADS classes: "illogicalNow", "dangerous", 
     *   etc.).
     *
     *   Note that this does not map directly to TADS's .allowAction property.
     *   For example, an illogicalNow action would not be allowed by TADS, but
     *   it makes sense to partially afford it since it might be possible later.
     *
     *   Using this scheme, it is possible to see if action is afforded in
     *   some way (!= 0), not afforded (== 0), clearly afforded (> 0) or 
     *   only partially/possibly afforded (< 0).
     *
     *   See in TADS: Action.verifyAction, VerifyResult, VerifyResultList.
     *
     *   Also, verify in "Getting Started in TADS3", "Learning TADS3"
     */         
    isAfforded(actor, action, dobj, iobj) {
        action.actor_ = actor;
        if (action.ofKind(TAction)) {
            action.dobjCur_ = dobj;
        }
        if (action.ofKind(TIAction)) {
            action.iobjCur_ = iobj;
        }
        local results = action.verifyAction();
        local mostLimiting = results.getEffectiveResult();
        local rank = mostLimiting.resultRank;
        if (mostLimiting.ofKind(InaccessibleVerifyResult) ||
            mostLimiting.ofKind(IllogicalVerifyResult)) {
            return 0;  //includes IllogicalSelf too
        }else if (mostLimiting.ofKind(LogicalVerifyResult)) {
            if (rank <= 0) rank = 1;
            return rank;   //+: allowed to degree of logical rank
        }else {
            //only partially afforded
            if (rank >= 0) rank = (rank * -1) - 1;
            return rank;   //-: weak affordance
        }
    }
    
    /* 
     *   Returns a Skald-based JSON-formatted string of the given affordance.
     *   dobj and iobj may be strings or lists of strings.  Uses verbNames to
     *   find verb name and (for TIActions with iobjs given) prepositions.
     */
    toJsonAffordance(verb, dobj, iobj) {
        local json = '{"affordance": ["' + self.verbNames[verb][1] + '"';
        if (dobj) {
            json += ', ' + self.toJsonList(dobj);
        }
        if (iobj) {
            if (verb.ofKind(TIAction)) {
               //add preposition
               json += ', "' + self.verbNames[verb][2] + '"';
            }
            json += ', ' + self.toJsonList(iobj);
        }
        json += ']}\n';
        return json;
    }
    
    /*
     *   Converts objs to a JSON list format.  If objs is a list, grabs .name for
     *   each of its elements.  If not a list, throws objs into a list of a si
     *   single elemtn and does the same thing.
     */
    toJsonList(objs) {
        if (!objs.ofKind(List)) {
            objs = [objs];
        }
        local json = objs.join('", "');
        return '["' + json + '"]"';
    }
;

skald : SkaldUI
    verbNames = [
        LookAction -> ['Look'],
        ExamineAction -> ['Examine'],
        TakeAction -> ['Take'],
        AttackWithAction -> ['Kill', 'with']
             //'Go' -> TravelAction
            ]
;


DefineIAction(Affordances)
    execAction() {

        foreach (local verb in skald.verbNames.keysToList()) {

            "<<skald.verbNames[verb][1]>>\n";
            if (!verb.ofKind(TAction)) {
                "<<skald.toJsonAffordance(verb, nil, nil)>>";
            }else if (!verb.ofKind(TIAction)) {
                local dobjs = skald.getObjectsInScope();
//                dobjs.filter
//                "<<skald.toJsonAffordance(verb, , 
//                new verb
//            }
            }
        }        
    
    }
;
VerbRule(Affordances)
     'affordances' : AffordancesAction
;

DefineIAction(Objects)
    execAction() {
        objectLister.showSimpleList(skald.getObjectsInScope());
    }
;
VerbRule(Objects)
     ('objs' | 'objects') : ObjectsAction
;

DefineIAction(Verbs)
    execAction() {
        //TODO: sort list
        "Verbs supported by this game:\n";
        skald.verbNames.forEach({name: "* <<name>>\n"});
    }
;
VerbRule(Verbs)
     'verbs' : VerbsAction
;