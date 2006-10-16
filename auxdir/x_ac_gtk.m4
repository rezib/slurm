##*****************************************************************************
## $Id: x_ac_gtk.m4 5401 2005-09-22 01:56:49Z morrone $
##*****************************************************************************
#  AUTHOR:
#    Danny Auble  <da@llnl.gov>
#
#  SYNOPSIS:
#    X_AC_GTK
#
#  DESCRIPTION:
#    Test for GTK. If found define 
##*****************************************************************************


AC_DEFUN([X_AC_GTK],
[
### Set to "no" if any test fails
    ac_have_gtk="yes"

### Check for pkg-config program
    AC_PATH_PROG(HAVEPKGCONFIG, pkg-config, $PATH)
    if test -z "$HAVEPKGCONFIG"; then
        AC_MSG_WARN([*** pkg-config not found. Cannot probe for libglade-2.0 or gtk+-2.0.])
        ac_have_gtk="no"
    fi

### Check for libglade package
    if test "$ac_have_gtk" == "yes"; then   
        $HAVEPKGCONFIG --exists libglade-2.0
        if ! test $? -eq 0 ; then
            AC_MSG_WARN([*** libbglade-2.0 is not available.])
            ac_have_gtk="no"
        fi
    fi


### Check for gtk2 package
    if test "$ac_have_gtk" == "yes" ; then
        $HAVEPKGCONFIG --exists gtk+-2.0
        if ! test $? -eq 0 ; then
            AC_MSG_WARN([*** gtk+-2.0 is not available.])
            ac_have_gtk="no"
        fi
    fi

### Check for gtk2.6+ package
    if test "$ac_have_gtk" == "yes" ; then
	AM_PATH_GTK_2_0(2.6.0,ac_have_gtk=yes,ac_have_gtk=no)
	if test "$ac_have_gtk" == "no" ; then
		AC_MSG_WARN([*** gtk+-2.6.0+ is not available.])
	fi
    fi

### Run a test program
    if test "$ac_have_gtk" == "yes" ; then
        GTK2_CFLAGS=`$HAVEPKGCONFIG --cflags libglade-2.0 gtk+-2.0 gthread-2.0`
        GTK2_LIBS=`$HAVEPKGCONFIG --libs libglade-2.0 gtk+-2.0 gthread-2.0`
        if test ! -z "GLADE_STATIC"  ; then
            GTK2_LIBS=`echo $GTK2_LIBS | sed "s/-lglade-2.0/$GLADE_STATIC -lglade-2.0 $BDYNAMIC/g"`
        fi
        save_CFLAGS="$CFLAGS"
        save_LIBS="$LIBS"
        CFLAGS="$GTK2_CFLAGS $save_CFLAGS"
        LIBS="$GTK2_LIBS $save_LIBS"
        AC_TRY_LINK([
          #include <gtk/gtk.h>
        ],[
          int main()
          {
            (void) gtk_action_group_new ("MenuActions");
            (void) gtk_ui_manager_new ();
	    (void) gtk_cell_renderer_combo_new();	
          }
        ], , [ac_have_gtk="no"])
	CFLAGS="$save_CFLAGS"
        LIBS="$save_LIBS"
        if test "$ac_have_gtk" == "yes"; then
            AC_MSG_RESULT([GTK test program built properly.])
            AC_SUBST(GTK2_CFLAGS)
            AC_SUBST(GTK2_LIBS)
        else
            AC_MSG_WARN([*** GTK test program execution failed.])
        fi
    fi
])
