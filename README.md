# WildSkript-Deobfuscator
Tool to deobfuscate Wildskript encrypted scripts with support for bruteforcing the power.

### Preview
![Preview](http://i.imgur.com/vry0Luv.gif)

### How it works:
First, this tool unpacks the packed file which is actually a `.zip` containing a file named `tmp.ws`. That file contains every character code multiplied with the power separated by a `-`, so it just divides each character code by the power and converts it back into a character.

### Download:

Windows: [deobfuscate.exe](https://raw.githubusercontent.com/sapphyrus/WildSkript-Deobfuscator/master/deobfuscate.exe)
All OS (Requires a ruby installation): [deobfuscate.rb](https://raw.githubusercontent.com/sapphyrus/WildSkript-Deobfuscator/master/deobfuscate.rb) (Right click -> Save as)

### Usage:
```sh
$ deobfuscate.exe [FILENAME] [POWER]
```
ex.
```sh
$ deobfuscate.exe NoCombatHacks.txt 70
```

To bruteforce the power use
```sh
$ deobfuscate.exe [FILE]
```