# Set the GTK_MODULES env variable to load appmenu-gtk-module

if [ -z "$GTK_MODULES" ]; then
    GTK_MODULES="appmenu-gtk-module"
else
    GTK_MODULES="$GTK_MODULES:appmenu-gtk-module"
fi
export GTK_MODULES
export UBUNTU_MENUPROXY=1
