/*
* Copyright (c) 2014 Ikey Doherty <ikey.doherty@gmail.com>
*               2018 elementary LLC. (https://elementary.io)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

namespace Mpris {

/**
 * We need to probe the dbus daemon directly, hence this interface
 */
[DBus (name="org.freedesktop.DBus")]
public interface DBusImpl : Object {
    public abstract string[] list_names () throws GLib.Error;
    public signal void name_owner_changed (string name, string old_owner, string new_owner);
    public signal void name_acquired (string name);
    public signal void name_lost (string name);
}

/**
 * Vala dbus property notifications are not working. Manually probe property changes.
 */
[DBus (name="org.freedesktop.DBus.Properties")]
public interface DbusPropIface : Object {
    public abstract Variant get (string iface, string property) throws Error;
    public signal void properties_changed (string iface, HashTable<string,Variant> changed, string[] invalid);
}

/**
 * Represents the base org.mpris.MediaPlayer2 spec
 */
[DBus (name="org.mpris.MediaPlayer2")]
public interface Iface : Object {
    public abstract void raise () throws GLib.Error;
    public abstract bool can_raise { get; }
    public abstract string? identity { owned get; }
    public abstract string desktop_entry { owned get; }
}

/**
 * Interface for the org.mpris.MediaPlayer2.Player spec
 *
 * @note We cheat and inherit from MprisIface to save faffing around with two
 * iface initialisations over one
 */
[DBus (name="org.mpris.MediaPlayer2.Player")]
public interface PlayerIface : Iface {
    public abstract void next () throws GLib.Error;
    public abstract void previous () throws GLib.Error;
    public abstract void pause () throws GLib.Error;
    public abstract void play_pause () throws GLib.Error;
    public abstract void stop () throws GLib.Error;
    public abstract void play () throws GLib.Error;
    public abstract string playback_status { owned get; }
    public abstract HashTable<string,Variant> metadata { owned get; }
    public abstract bool can_go_next { get; }
    public abstract bool can_go_previous { get; }
    public abstract bool can_play { get; }
    public abstract bool can_pause { get; }
    public abstract int64 position { get; }
    public signal void seeked (int64 position);
}
}
