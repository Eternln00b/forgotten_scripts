# forgotten scripts

This backdoor is an old draft that I decided to share.

In order to use my malware toolkit you have first to install the textioconv suit. Once it has been done, you can run two scripts.

for backdooring purposes :
```bash
textioconvshell -a <target arch> -h <host listener> -p <listen port> [opt][-v <varname> -k <xor key>]
```
for testing purposes : 
```bash
textioconvshell-test -a <target arch> [opt][-v <varname> -k <xor key>]
```

***note : the -k option is partially broken. Although it's possible to use a custom key the backdoor could not work.***

My [youtube video](https://youtu.be/t5cUatDkx08?si=AJwvPYQQS-ZyvWEn) ( in french ) should gives you a light clue how to use my malware toolkit. 

Of course, this draft is just for testing purpose. If you to plan to use it for a custom projet, you can still use my backdoor template but you will have to run your own rat. 

09/06/2025 : 
Apparently my backdoor has been partially patched. Currently, the x64 arch doesn't work at all on my side. Sometimes, Windows Defender detects it automatically or the backdoor doesn't run. 
All looks fine with the x86 arch. 
Now, the shell code is first encrypted with the XOR algorithm, encoded with ASCII and re-encoded in octal in order to make compilation easier. 
