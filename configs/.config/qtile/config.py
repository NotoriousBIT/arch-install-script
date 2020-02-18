##### IMPORTS #####
import logging
import os
#import re
import subprocess
import socket
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

from typing import List  # noqa: F401

mod = "mod4" # Windows
#mod = "mod1" # Alt

##### KEYBINDINGS #####

def init_keys():
    keys = [
        # Switch between windows in current stack pane
        Key([mod], "k", lazy.layout.down()),
        Key([mod], "j", lazy.layout.up()),

        # Move windows up or down in current stack
        Key([mod, "control"], "k", lazy.layout.shuffle_down()),
        Key([mod, "control"], "j", lazy.layout.shuffle_up()),

        # Switch window focus to other pane(s) of stack
        Key([mod], "space", lazy.layout.next()),

        # Swap panes of split stack
        Key([mod, "shift"], "space", lazy.layout.rotate()),

        # Toggle between split and unsplit sides of stack.
        # Split = all windows displayed
        # Unsplit = 1 window displayed, like Max layout, but still with
        # multiple stack panes
        Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
        Key([mod], "Return", lazy.spawn("termite")),

        # Toggle between different layouts as defined below
        Key([mod], "Tab", lazy.next_layout()),
        Key([mod], "w", lazy.window.kill()),

        Key([mod, "control"], "r", lazy.restart()),
        Key([mod], "l", lazy.spawn("/usr/bin/light-locker-command -l")),
        Key([mod], "r", lazy.spawncmd()),
    ]
    return keys
keys = init_keys()

##### BAR COLORS #####

def init_colors():
    return [["#282a36", "#282a36"], # panel background
            ["#434758", "#434758"], # background for current screen tab
            ["#ffffff", "#ffffff"], # font color for group names
            ["#ff5555", "#ff5555"], # background color for layout widget
            ["#000000", "#000000"], # background for other screen tabs
            ["#12B0FF", "#12b0ff"], # dark green gradiant for other screen tabs
            ["#50fa7b", "#50fa7b"], # background color for network widget
            ["#ffa300", "#ffa300"], # background color for pacman widget
            ["#9AEDFE", "#9AEDFE"], # background color for cmus widget
            ["#000000", "#000000"], # background color for clock widget
            ["#434758", "#434758"], # background color for systray widget
            ["#ff3535", "#ff3535"]] # background system

colors = init_colors()

##### LAYOUTS #####

def init_floating_layout():
    return layout.Floating(border_focus="#3B4022")

def init_layout_theme():
    return {"border_width": 3,
            "margin": 4,
            "border_focus": "#ff0000",
            "border_normal": "#1D2330"
           }

def init_border_args():
    return {"border_width": 2}

def init_layouts():
    return [#layout.MonadWide(**layout_theme),
            #layout.Bsp(**layout_theme),
            #layout.Stack(stacks=2, **layout_theme),
            #layout.Columns(**layout_theme),
            #layout.RatioTile(**layout_theme),
            #layout.VerticalTile(**layout_theme),
            #layout.Tile(shift_windows=True, **layout_theme),
            #layout.Matrix(**layout_theme),
            #layout.Zoomy(**layout_theme),
            layout.MonadTall(**layout_theme),
            layout.Max(**layout_theme),
            layout.TreeTab(
                font = "Ubuntu",
                fontsize = 10,
                sections = ["FIRST", "SECOND"],
                section_fontsize = 11,
                bg_color = "#141414",
                active_bg = "#90C435",
                active_fg = "#000000",
                inactive_bg = "#384323",
                inactive_fg = "#a0a0a0",
                padding_y = 5,
                section_top = 10,
                panel_width = 320,
                **layout_theme
                ),
            layout.Floating(**layout_theme)]

floating_layout = init_floating_layout()
layout_theme = init_layout_theme()
border_args = init_border_args()
layouts = init_layouts()


##### GROUPS #####

def init_group_names():
    return [("TERM", {'layout': 'monadtall'}),
            ("DEV", {'layout': 'monadtall'}),
            ("WWW", {'layout': 'floating'}),
            ("VBOX", {'layout': 'monadtall'}),
            ("FLOAT", {'layout': 'floating'})]

def init_groups():
    return [Group(name, **kwargs) for name, kwargs in group_names]

group_names = init_group_names()
groups = init_groups()

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))

##### WIDGETS #####

def init_widgets_defaults():
    return dict(font="Ubuntu Mono",
                fontsize = 12,
                padding = 2,
                background=colors[2])

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
               widget.Sep(
                        linewidth = 0,
                        padding = 6,
                        foreground = colors[2],
                        background = colors[0]
                        ),
               widget.GroupBox(font="Ubuntu Bold",
                        fontsize = 9,
                        margin_y = 0,
                        margin_x = 0,
                        padding_y = 5,
                        padding_x = 5,
                        borderwidth = 1,
                        active = colors[2],
                        inactive = colors[2],
                        rounded = False,
                        highlight_method = "block",
                        this_current_screen_border = colors[5],
                        this_screen_border = colors [1],
                        other_current_screen_border = colors[0],
                        other_screen_border = colors[0],
                        foreground = colors[2],
                        background = colors[0]
                        ),
               widget.Prompt(
                        prompt=prompt,
                        font="Ubuntu Mono",
                        padding=10,
                        foreground = colors[3],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 0,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[0]
                        ),
               widget.WindowName(font="Ubuntu",
                        fontsize = 11,
                        foreground = colors[5],
                        background = colors[0],
                        padding = 5
                        ),
               widget.TextBox(
                        text='',
                        background = colors[0],
                        foreground = colors[5],
                        padding=0,
                        fontsize=37
                        ),
               widget.TextBox(
                        text=" [icon]",
                        foreground=colors[2],
                        background=colors[5],
                        padding = 0,
                        fontsize=14
                        ),
               widget.Net(
                        interface = "enp0s3",
                        foreground = colors[2],
                        background = colors[5],
                        padding = 5
                        ),
               widget.TextBox(
                        text='',
                        background = colors[5],
                        foreground = colors[7],
                        padding=0,
                        fontsize=37
                        ),
               widget.TextBox(
                        font="Ubuntu Bold",
                        text=" ☵",
                        padding = 5,
                        foreground=colors[2],
                        background=colors[7],
                        fontsize=14
                        ),
               widget.CurrentLayout(
                        foreground = colors[2],
                        background = colors[7],
                        padding = 5
                        ),
               widget.TextBox(
                        text='',
                        background = colors[7],
                        foreground = colors[5],
                        padding=0,
                        fontsize=37
                        ),
               widget.TextBox(
                        font="Ubuntu Bold",
                        text=" ⟳",
                        padding = 5,
                        foreground=colors[2],
                        background=colors[5],
                        fontsize=14
                        ),
               widget.CheckUpdates(
                        execute = "none",
                        update_interval = 1800,
                        foreground = colors[2],
                        background = colors[5]
                        ),
               widget.TextBox(
                        text="Updates",
                        padding = 5,
                        foreground=colors[2],
                        background=colors[5]
                        ),
               widget.TextBox(
                        text='',
                        background = colors[5],
                        foreground = colors[7],
                        padding=0,
                        fontsize=37
                        ),
               widget.Battery(
                        font="Ubuntu Bold",
                        foreground=colors[2],
                        background=colors[7],
                        fontsize=14
                        ),
              # widget.Cmus(
              #          max_chars = 40,
              #          update_interval = 0.5,
              #          background=colors[7],
              #          play_color = colors[2],
              #          noplay_color = colors[2]
              #          ),
               widget.TextBox(
                        text='',
                        background = colors[7],
                        foreground = colors[5],
                        padding=0,
                        fontsize=37
                        ),
               widget.TextBox(
                        font="Ubuntu Bold",
                        text=" [ICON]",
                        foreground=colors[2],
                        background=colors[5],
                        padding = 5,
                        fontsize=14
                        ),
               widget.Clock(
                        foreground = colors[2],
                        background = colors[5],
                        format="%A, %d %B - %H:%M"
                        ),
               widget.Sep(
                        linewidth = 0,
                        padding = 5,
                        foreground = colors[0],
                        background = colors[5]
                        ),
               widget.Systray(
                        background=colors[0],
                        padding = 5
                        ),
               widget.TextBox(
                        text='',
                        background = colors[5],
                        foreground = colors[11],
                        padding=0,
                        fontsize=37
                        ),
               widget.LaunchBar(
                        progs = [
                            (' ', '/usr/bin/light-locker-command -l', 'lock'),
                            (' 勒', 'reboot', 'restart'),
                            ('  ', 'poweroff', 'shutdown'),
                            ],
                        background = colors[11],
                        ),
              ]
    return widgets_list


widget_defaults = init_widgets_defaults()
widgets_list = init_widgets_list()

# ???
extension_defaults = widget_defaults.copy()

##### SCREENS ##### (TRIPLE MONITOR SETUP)

def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1                       # Slicing removes unwanted widgets on Monitors 1,3

#def init_widgets_screen2():
#    widgets_screen2 = init_widgets_list()
#    return widgets_screen2                       # Monitor 2 will display all widgets in widgets_list

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=0.95, size=20))#,
#            Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=0.95, size=20)),
#            Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=0.95, size=20))
           ]

screens = init_screens()
widgets_screen1 = init_widgets_screen1()
#widgets_screen2 = init_widgets_screen2()


#screens = [
#    Screen(
#        top=bar.Bar(
#            [
#                widget.GroupBox(),
#                widget.Prompt(),
#                widget.WindowName(),
#                widget.TextBox("default config", name="default"),
#                widget.Systray(),
#                widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
#            ],
#            24,
#        ),
#    ),
#]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

##### DEFINING A FEW THINGS #####



##### STARTUP APPLICATIONS #####

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh') # path to my script, under my user directory
    subprocess.call([home])

##### NEEDED FOR SOME JAVA APPS #####

#wmname = "LG3D"
wmname = "qtile"
