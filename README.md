# EECS3311_Project
2018-2019 Winter




## Trouble Shooting
### gtk/gtk.h file not found
When this happen, nothing would work but gives a full of error.<br>
Keep calm. Just save all your work and make a copy of it first.<br>
For me, this happened when I changed bash_profile a bit. (I think)<br>
Easiest solution might be update EVERYTHING to get the original setups.<br>
For my case, I just followed professor's instruction once again.

Assume **Xcode, X11 and MacPort** is already installed.
Then,
```
sudo port selfupdate
```

```
sudo port upgrade outdated
```

```
sudo port install eiffelstudio
```

Then, open bash_profile
```
cd
nano .bash_profile
```

And Paste (or double check) following codes
```
export ISE_EIFFEL=/Applications/MacPorts/Eiffel_18.11
export ISE_PLATFORM=macosx-x86-64
export PATH=$PATH:$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/bin
```

Also make sure if MATHMODEL is properly set.
If everything is good,
```
source .bash_profile
```

Then, open estudio
```
estudio &
```

Since the error mentioned about gtk, let's have it once again.
```
sudo port install gtk2
```

And this is optional but nah, lets just have it.
```
sudo port install gtk-chtheme
```

Try gtk-chtheme. It's theming.
```
gtk-chtheme
```
