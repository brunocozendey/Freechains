# Free chains Windows Installer 

[Original Repo] (https://github.com/fsantanna-no/freechains) 

## Installation 

Tried on Windows 10 Home

1- Java installation: [Link] (https://www.java.com/en/download/help/windows_manual_download.html)
2- Add Java to class path: [Link] (https://docs.oracle.com/javase/tutorial/essential/environment/paths.html)
3- Create a folder to add the freechains files *ex: C:\Freechains*
4- Download the freechains windows files: [Link] (https://github.com/brunocozendey/Freechains/tree/master/win_installer)
5- Move files to the folder created at step 3. 
6- Copy and Paste files **freechains.bat** and **freechains-host.bat** to *C:\Windows\System32*
7- Download the dll file from libsodium: [Link] (https://download.libsodium.org/libsodium/releases/)
8- Extract the dll file to *C:\Windows\System32*

## Using

- Acess the created Freechains folder using cmd 
```
cd C:\Freechains
```

- Starting Daemon  
(On Windows you need to type full path name as example bellow): 
```
freechains-host start C:\Freechains\myhost 
```
- Creating identity
```
freechains crypto shared "My very strong passphrase" 
```

- Creating a channel
(On Windows not allow use single quote (') for channel name, use double quote (") if needed) 
```
freechains chains join "$chat" 96700A...
```
