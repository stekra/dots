pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// The notification daemon (takes over from mako), plus the list of popups
// currently on screen.
Singleton {
    id: root

    readonly property int maxPopups: 3
    readonly property int defaultTimeout: 5000   // ms, when the app doesn't say

    // ids of notifications shown as popups, newest first. An id stays here until
    // its card has finished animating out (the card calls remove()).
    readonly property ListModel popups: ListModel {}
    property var byId: ({})

    function get(id) {
        return byId[id] ?? null
    }

    function remove(id) {
        for (let i = 0; i < popups.count; i++) {
            if (popups.get(i).nid === id) {
                popups.remove(i)
                break
            }
        }
        delete byId[id]
    }

    NotificationServer {
        keepOnReload: true
        actionsSupported: true
        imageSupported: true

        onNotification: notification => {
            notification.tracked = true
            const isNew = root.byId[notification.id] === undefined
            root.byId[notification.id] = notification
            // an app updating an existing notification keeps its card
            if (isNew) root.popups.insert(0, { nid: notification.id })
        }
    }
}
