import Quickshell
import qs.island
import qs.notifications

ShellRoot {
    // one island per monitor
    Variants {
        model: Quickshell.screens
        Island {}
    }

    // and a matching reserved space on the right, so windows are centered
    Variants {
        model: Quickshell.screens
        Strut {}
    }

    // notification popups, next to the island on the monitor you're using
    Popups {}
}
