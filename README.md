# forgotten scripts

This backdoor is an old draft that I decided to share.

In order to use my malware toolkit you have first to install the ASCIIexzor suit. Once it has been done, you can run two scripts.

for backdooring purposes :
```bash
ASCIIexzorShell -a <target arch> -h <host listener> -p <listen port> [opt][-v <varname> -k <xor key>]
```
for testing purposes : 
```bash
ASCIIexzorShell-Test -a <target arch> [opt][-v <varname> -k <xor key>]
```

***note : the -k option is partially broken. although it's possible to use a custom key the backdoor could not work.***

My youtube video ( in french ) should give a clue how to use my malware toolkit. 

Of course, this draft is just for testing purpose. If you to plan to use it for a custom projet, you can still use my backdoor template but you will have to run your own rat. 
