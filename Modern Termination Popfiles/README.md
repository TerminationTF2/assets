I'm writing this so you guys have an idea of how to add in your extra stuff now that I've rewritten and reorganised the popfiles.

For the WaveSchedule, I have reorganised things like Precaches, PointTemplates, Extra Spawn Points and Extra Tank Paths into separate categories that I would like to be followed. They have a commented out label to say which category is what.

For the PointTemplates, I have attempted to place the PointTemplates and the respective materials inside them in chronological order. I would like this to be maintained for future additions, with commented explanations besides them like you will see in these popfiles.
I have also renamed a good few of them to have names that are self-explanatory, for things like logic_relays.

The things that are continuously present throughout the wave have been placed in a "WaveXAssets" PointTemplate, with activating entries like OnSpawnOutputs and Logic_Autos being placed into a "WaveXSetup" PointTemplate. These will only need to be spawned for their respective wave, using a ForceSpawn output.
Things that are continuously present throughout several waves are to be put in a "CoreAssets" PointTemplate, which is only seen in the Robotfactory popfile thus far. These are added using a SpawnTemplate output in the WaveSchedule.

For the waves themselves, I have hopefully made it much more efficient to skim through with separating the subwaves into respective blocks, divided by a commented label describing what subwave they are. The Wavespawns in these subwaves also have a commented label saying what's in them.
This means we do not have to open up the entire block and read what bots are being spawned there in editing.

Wavespawns have had their keyvalues organised in a specific order that I believe to be the most legible. I have organised them as follows:

- Name
- WaitForAllSpawned/Dead (If Applicable)
- Where
- TotalCount
- MaxActive
- WaitBeforeStarting
- WaitBetweenSpawns
- TotalCurrency

- FirstSpawnWarningSound (If Applicable)

In the blocks where the templates or bots are designated, I have organised them so that these blocks come first, and then any extra blocks like FirstSpawnOutput comes after. Some larger bot blocks have also been moved into the Templates area, like the Patrol Chiefs and the Chief Technician.
Some parts of the WaveSpawns (Like Where keyvalues that use ExtraSpawnPoints) have a [$SIGSEGV] block next to them, to suppress any errors that come from VSCode VDF regarding things like invalid spawns for example. This will make it much easier to note any errors that come up while editing.

I believe that is all. Thank you for reading, and I hope we can maintain this level of organisation considering how large the scope has gotten.

- Kai