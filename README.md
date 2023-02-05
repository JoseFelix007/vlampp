# VLampp - Lampp Switcher

Simple Lampp Switcher for Linux based on [this lampp_switcher](https://github.com/rafaelphp/lampp_switcher). <br> I just did this one, just for convenience and learning purpose.

**Installation**

* Make executable the sh script file `sudo chmod +x ./vlammp.sh`
* Put the script in some folder that is in your PATH
* Install versions of XAMPP, the defautl location is `/opt/lampp`. After installing each version, rename the folder `sudo mv /opt/lampp /opt/lampp_X` where X is 5 or 8 (I put these versions in my script, put more if you want `VERSIONS="${VERSIONS} X"`).
* Run `vlampp` or `vlampp help` to start

**Usage**
```
Lampp switcher versions.

Syntax: vlampp [option]

Options:
help                   Print this help menu.
versions               Get installed versions.
set_default [version]  Set default version.
start [services]       Start services.
restart [services]     Restart services.
stop [services]        Stop services.

Services: apache|mysql|all
```

**Notes**

Feel free to modify the script yourself, fork this repository or comment. Enjoy!