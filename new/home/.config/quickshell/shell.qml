import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.UPower
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "Colours.qml"

ShellRoot {
    id:root

    // Create a bar instance for each screen
    Variants {
        model: Quickshell.screens

        // The bar object itself
        PanelWindow {
            property var modelData
            property var shellScreen: modelData
            screen: shellScreen

            implicitHeight: 30
            visible: true
            anchors {
                top: true
                left: true
                right: true
            }
            color: Colours.md3.primary_container

            // Arch Logo
            Rectangle {
                id: logo
                height: parent.height
                width: 30

                color: logoArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }

                Text {
                    text: "󰣇"
                    anchors.centerIn: parent
                    color: logoArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 18
                    }
                }

                MouseArea {
                    id: logoArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            // Create horizontal workspace bar
            RowLayout {
                id: workspaces

                anchors {
                    left: logo.right
                    leftMargin: 3
                    top: parent.top
                    bottom: parent.bottom
                }
                spacing: 0

                Repeater {
                    model: 6

                    Rectangle {
                        anchors {
                            top: workspaces.top
                            topMargin: 3
                            bottom: workspaces.bottom
                            bottomMargin: 3
                        }

                        Layout.preferredWidth: 30

                        property var ws: Hyprland.workspaces
                        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                        color: isActive ? Colours.md3.surface_variant : Colours.md3.primary

                        Text {
                            text: assignWorkspaceName(index)
                            anchors.centerIn: parent

                            color: isActive ? Colours.md3.on_surface_variant : Colours.md3.on_primary

                            font {
                                pixelSize: 16
                                //bold: isActive ? true : false
                            }
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                Hyprland.dispatch(`workspace ${index + 1}`)
                            }
                        }
                    }
                }
            }

            function assignWorkspaceName(index) {
                const names = ["一", "二", "三", "四", "五", "六"]
                return names[index]
            }

            // Clock Date and Time
            Rectangle {
                id:clock
                height: parent.height
                implicitWidth: clockText.implicitWidth + 14

                anchors.centerIn: parent

                color: clockArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container
                property string currentTime: Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm AP")

                Text {
                    id: clockText

                    anchors.centerIn: parent

                    text: clock.currentTime
                    color: clockArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container
                    
                    font {
                        pixelSize: 14
                    }
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.currentTime = Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm AP")
                }

                MouseArea {
                    id: clockArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Rectangle {
                id: audio
                height: parent.height
                width: 30

                anchors {
                    right: cpu.left
                    top: parent.top
                    bottom: parent.bottom
                }

                color: audioArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                Text {
                    anchors.centerIn: parent

                    text: " "
                    // "", "", ""
                    color: audioArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 14
                    }
                }

                MouseArea {
                    id: audioArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Rectangle {
                id: cpu
                height: parent.height
                implicitWidth: cpuText.implicitWidth + 14

                anchors {
                    right: memory.left
                    top: parent.top
                    bottom: parent.bottom
                }

                color: cpuArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                Text {
                    id: cpuText

                    anchors.centerIn: parent

                    text: ""
                    color: cpuArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 14
                    }
                }

                MouseArea {
                    id: cpuArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Rectangle {
                id: memory
                height: parent.height
                implicitWidth: memoryText.implicitWidth + 14

                anchors {
                    right: network.left
                    top: parent.top
                    bottom: parent.bottom
                }

                color: memoryArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container
                property int memUsage: 0

                Process {
                    id: memProc
                    command: ["sh", "-c", "free | grep Mem"]
                    stdout: SplitParser {
                        splitMarker: "\n"
                        onRead: data => {
                            if (!data) return
                            var parts = data.trim().split(/\s+/)
                            var total = parseInt(parts[1]) || 1
                            var used = parseInt(parts[2]) || 0
                            memory.memUsage = Math.round(100 * used / total)
                        }
                    }
                    Component.onCompleted: running = true
                }

                Timer {
                    interval: 2000
                    running: true
                    repeat: true
                    onTriggered: {
                        memProc.running = true
                    }
                }

                Text {
                    id: memoryText

                    anchors.centerIn: parent

                    text: "   " + memory.memUsage + "%"
                    color: memoryArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 14
                    }
                }

                MouseArea {
                    id: memoryArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Rectangle {
                id: network
                height: parent.height
                implicitWidth: networkText.implicitWidth + 14

                anchors {
                    right: battery.left
                    top: parent.top
                    bottom: parent.bottom
                }

                color: networkArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                Text {
                    id: networkText

                    anchors.centerIn: parent

                    text: "  "
                    // "󰤮 "
                    color: networkArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 14
                    }
                }

                MouseArea {
                    id: networkArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Rectangle {
                id: battery
                height: parent.height
                implicitWidth: batteryText.implicitWidth + 14

                anchors {
                    right: notifications.left
                    top: parent.top
                    bottom: parent.bottom
                }

                color: batteryArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container
                readonly property int batteryLevel: UPower.displayDevice.percentage * 100
                readonly property string batteryState: UPower.displayDevice.state

                function batterySymbol(state, level) {
                    let symbol;
                    if (state == 1) {
                        symbol = " ";
                    } else {
                        if (level <= 10) symbol = " ";
                        else if (level <= 40) symbol = " ";
                        else if (level <= 70) symbol = " ";
                        else if (level < 90) symbol = " ";
                        else symbol = " ";
                    }
                    return symbol;
                }

                Text {
                    id: batteryText

                    anchors.centerIn: parent

                    color: batteryArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container
                    text: battery.batterySymbol(battery.batteryState, battery.batteryLevel) + "  " + battery.batteryLevel + "%"
                    
                    font {
                        pixelSize: 14
                    }
                }

                MouseArea {
                    id: batteryArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Rectangle {
                id: notifications
                height: parent.height
                implicitWidth: notificationsText.implicitWidth + 14

                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

                color: notificationArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                Text {
                    id: notificationsText

                    anchors.centerIn: parent

                    text: "󰂚 "
                    // text: "󱅫"
                    color: notificationArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 14
                    }
                }

                MouseArea {
                    id: notificationArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
        }

        //LazyLoader {}
    }
}
