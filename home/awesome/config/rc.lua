-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local dpi   = require("beautiful.xresources").apply_dpi
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local weather_widget = require("awesome-wm-widgets.weather-widget.weather")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
require("env")

theme = {}
theme.font_name  = "FiraCode Nerd Font"
theme.font_size  = dpi(15)
theme.font       = theme.font_name .. " " .. theme.font_size

-- awful.screen.set_auto_dpi_enabled( true )

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err) })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.max,
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.se,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.top,
}
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      -- c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        {raise = true}
      )
    end
  end),
  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end))


awful.screen.connect_for_each_screen(function(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    style = {
      font = theme.font,
    },
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    style = {
      font = theme.font,
    },
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(20) })

  s.myspacer = wibox.widget {
    spacing        = dpi(15),
    spacing_widget = wibox.widget.separator,
    layout         = wibox.layout.fixed.horizontal
  }

  s.mylogo = wibox.widget {
    font = theme.font_name .. " " .. dpi(20),
    markup = "  ",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  }

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mylogo,
      s.mytaglist,
      s.mypromptbox,
      s.mylayoutbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      battery_widget({
        path_to_icons = arc_icon_theme .. "/Arc/status/symbolic/",
        show_current_level = true,
      }),
      wibox.widget.systray(),
      mytextclock,
      weather_widget({
        coordinates = {46.204400, 6.143200},
        api_key = "476b81fdcd2cc9ab8d99967ea1c39fee",
      }),
    },
  }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({ }, 3, function () end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
  awful.key({ modkey,           }, "h",      hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
  awful.key({ modkey,           }, "Up",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "Down",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

  awful.key({ modkey,           }, "Right",
    function ()
      awful.client.focus.byidx( 1)
    end,
    {description = "focus next by index", group = "client"}
  ),
  awful.key({ modkey,           }, "Left",
    function ()
      awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
  ),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx(  1)    end,
    {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.byidx( -1)    end,
    {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey, "Control" }, "Right", function () awful.screen.focus_relative( 1) end,
    {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "Left", function () awful.screen.focus_relative(-1) end,
    {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "go back", group = "client"}),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey,           }, "q", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Control"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),

  awful.key({ modkey,           }, "s",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "s",     function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "s",     function () awful.tag.incncol(-1, nil, true)    end,
    {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),

  awful.key({ modkey, "Control" }, "n",
    function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", {raise = true}
        )
      end
    end,
    {description = "restore minimized", group = "client"}),

  -- Prompt
  awful.key({ modkey }, ";",
    function ()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    {description = "lua execute prompt", group = "awesome"}),
  -- Menubar
  awful.key({ modkey }, "l", function () awful.util.spawn_with_shell("lock-screen") end,
    {description = "Lock screen", group = "awesome"}),
  awful.key({ modkey, "Shift" }, ";", function () awful.util.spawn_with_shell("launch-default-programs") end,
    {description = "Launch default programs", group = "launcher"}),
  awful.key({ modkey }, ".", function () awful.util.spawn_with_shell("emoji-menu") end,
    {description = "Emoji menu", group = "launcher"}),
  awful.key({ modkey }, "c", function () awful.util.spawn_with_shell("CM_LAUNCHER=rofi clipmenu") end,
    {description = "Clip menu", group = "launcher"}),
  awful.key({ modkey }, "p", function () awful.util.spawn_with_shell("rofi -show-icons -modi windowcd -show windowcd") end,
    {description = "Select window", group = "launcher"}),
  awful.key({ modkey, "Shift" }, "p", function () awful.util.spawn_with_shell("rofi -show-icons -modi window -show window") end,
    {description = "Select window global", group = "launcher"}),
  awful.key({ modkey }, "e", function () awful.util.spawn_with_shell("rofi -show-icons -show combi -combi-modi 'drun,run' -modi combi") end,
    {description = "Launch program", group = "launcher"}),
  awful.key({ modkey, "Shift" }, "q", function () awful.util.spawn_with_shell("rofi -show power-menu -modi power-menu:power-menu") end,
    {description = "Power menu", group = "launcher"})
)

clientkeys = gears.table.join(
  awful.key({ modkey, "Shift" }, "Return",
    function (c)
      cfullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key({ modkey,           }, "w",      function (c) c:kill()                         end,
    {description = "close", group = "client"}),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
    {description = "toggle floating", group = "client"}),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
  awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    {description = "move to screen", group = "client"}),
  awful.key({ modkey,           }, "g",      function (c) c.ontop = not c.ontop            end,
    {description = "toggle keep on top", group = "client"}),
  awful.key({ modkey,           }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    {description = "(un)maximize", group = "client"}),
  awful.key({ modkey, "Control" }, "m",
    function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end ,
    {description = "(un)maximize vertically", group = "client"}),
  awful.key({ modkey, "Shift"   }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end ,
    {description = "(un)maximize horizontally", group = "client"}),
  awful.key({ }, "XF86AudioPlay", function () awful.util.spawn_with_shell("playerctl play-pause") end),
  awful.key({ }, "XF86AudioNext", function () awful.util.spawn_with_shell("playerctl next") end),
  awful.key({ }, "XF86AudioPrev", function () awful.util.spawn_with_shell("playerctl previous") end),
  awful.key({ }, "XF86AudioStop", function () awful.util.spawn_with_shell("playerctl stop") end),
  awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ -5% && volnoti-show $(pamixer --get-volume)") end),
  awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ +5% && volnoti-show $(pamixer --get-volume)") end),
  awful.key({ }, "XF86AudioMute", function () awful.util.spawn_with_shell("pactl set-sink-mute @DEFAULT_SINK@ && volnoti-show $(pamixer --get-volume)") end),
  awful.key({ }, "XF86MonBrightnessUp", function () awful.util.spawn_with_shell("brightnessctl set +5%") end),
  awful.key({ }, "XF86MonBrightnessDown", function () awful.util.spawn_with_shell("brightnessctl set 5%-") end),
  awful.key({ }, "Print", function () awful.util.spawn_with_shell("flameshot gui") end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      {description = "view tag #"..i, group = "tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = "move focused client to tag #"..i, group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end

clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
  end),
  awful.button({ modkey }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = { border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },

  -- Floating clients.
  { rule_any = {
    instance = {
      "DTA",  -- Firefox addon DownThemAll.
      "copyq",  -- Includes session name in class.
      "pinentry",
    },
    class = {
      "Arandr",
      "Blueman-manager",
      "Gpick",
      "Kruler",
      "MessageWin",  -- kalarm.
      "Sxiv",
      "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
      "Wpa_gui",
      "veromix",
      "xtightvncviewer"},

    -- Note that the name property shown in xprop might be set slightly after creation of the client
    -- and the name shown there might not match defined rules here.
    name = {
      "Event Tester",  -- xev.
    },
    role = {
      "AlarmWindow",  -- Thunderbird's calendar.
      "ConfigManager",  -- Thunderbird's about:config.
      "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
    }
  }, properties = { floating = true }},

  -- Add titlebars to normal clients and dialogs
  { rule_any = {type = { "normal", "dialog" }
  }, properties = { titlebars_enabled = false }
  },

  { rule = { class = "Slack" },
    properties = { screen = 1, tag = "2" } },

  { rule = { class = "Spotify" },
    properties = { screen = 1, tag = "3" } },

  { rule = { class = "Firefox" },
    properties = { screen = 1, tag = "4" } },

  { rule = { class = "Brave" },
    properties = { screen = 1, tag = "4" } },

  { rule = { class = "Alacritty" },
    properties = { screen = 1, tag = "5" } },

  { rule = { class = "obsidian" },
    properties = { screen = 1, tag = "6" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end

  -- handle apps like spotify which take some time to ge a class assigned
  if c.class == nil then
    c.minimized = true
    c:connect_signal("property::class", function ()
      c.minimized = false
      awful.rules.apply(c)
    end)
  end
end)



-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c) : setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton (c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.ontopbutton    (c),
      awful.titlebar.widget.closebutton    (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Auto jump to urgent windows
client.connect_signal("property::urgent", function(c)
  c.minimized = false
  c:jump_to()
end)

-- Gaps
beautiful.useless_gap = dpi(6)
beautiful.systray_icon_spacing = dpi(3)
beautiful.gap_single_client = false

-- set wallpaper
function set_wallpaper()
  awful.spawn.with_shell("update-wallpaper")
end
gears.timer {timeout = 60 * 60, call_now = true, autostart = true, callback = set_wallpaper}
screen.connect_signal("request::wallpaper", set_wallpaper)
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
-- remove borders on max
screen.connect_signal("arrange", function (s)
  local max = s.selected_tag.layout.name == "max"
  local only_one = #s.tiled_clients == 1 -- use tiled_clients so that other floating windows don't affect the count
  -- but iterate over clients instead of tiled_clients as tiled_clients doesn't include maximized windows
  for _, c in pairs(s.clients) do
    if (max or only_one) and not c.floating or c.maximized then
      c.border_width = 0
    else
      c.border_width = beautiful.border_width
    end
  end
end)
-- Startup Commands
awful.spawn.with_shell(xrandr_command)
-- Enable dpms
awful.spawn.with_shell("xset s on && xset s 1200")
