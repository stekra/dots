import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs
import qs.services

// Notification popups, on the monitor you're using, with the cards stacked
// beside the island around the clock's height (the screen's vertical center).
// The window starts at the island's center line, so cards can grow out of the
// clock's center without being cut off; the cards themselves sit just right of
// the island. Only the cards take clicks, and no space is reserved.
PanelWindow {
    id: popups
    screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
    visible: Notifications.popups.count > 0

    anchors { left: true; top: true; bottom: true }
    margins.left: Theme.gap + Theme.islandWidth / 2
    implicitWidth: stack.x + Theme.notificationWidth
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    mask: Region { item: stack }

    Column {
        id: stack
        // from the island's center line to just right of the island
        x: Theme.islandWidth / 2 + Theme.notificationGap
        y: (popups.height - height) / 2
        // each card carries its own gap below it (so it can grow in smoothly);
        // this removes the extra gap after the last one
        bottomPadding: -6

        Repeater {
            model: Notifications.popups
            NotificationCard {}
        }
    }
}
