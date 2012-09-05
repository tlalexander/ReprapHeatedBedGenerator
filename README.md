Reprap Heated Bed Generator
===========================

Easily Generate EAGLE .brd files for a reprap heated bed.

This is a simple processing sketch that generates an eagle BRD file for eagle version 6+ for a reprap heated bed.

After you generate the board file, open it up, and press the "switch to schematic" button up top.

Eagle will generate a schematic that is linked to the board. Now you can add a power jack, a thermistor, LED, mounting holes - anything you want. For the power jack, connect both pins to "SIGNAL1" using the "name" command in Eagle. Switch to the board again, position your power connector, move the ends of the heater traces as needed, and add a trace that goes from one pin of the power jack to one end of the heater trace. Now connect the other pin of the jack to the other end of the heater trace, and do the same for the LED if needed. Throw on some text, some mounting holes, and voila!

This was tested to work with Processing 2.0 Alpha, and I think it uses an XML class that is different in 1.5.

Change values at the top of the sketch to mess with the board. If you want to get crazy, add a "target resistance" and find a way to calculate the optimum board for that. Or just keep making up numbers until you get close to what you want!