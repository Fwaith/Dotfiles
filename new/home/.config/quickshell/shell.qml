import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
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
            Text {
                id: clock
                anchors.centerIn: parent
                text: Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm AP")
                color: Colours.md3.on_primary_container

                font {
                    pixelSize: 14
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm AP")
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

                    text: ""
                    // "", "", ""
                    color: audioArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 16
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
                width: 30

                anchors {
                    right: memory.left
                    top: parent.top
                    bottom: parent.bottom
                }

                color: cpuArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                Text {
                    anchors.centerIn: parent

                    text: ""
                    color: cpuArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 16
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
                width: 30

                anchors {
                    right: network.left
                    top: parent.top
                    bottom: parent.bottom
                }

                color: memoryArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                Text {
                    anchors.centerIn: parent

                    text: " "
                    color: memoryArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 16
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
                width:30

                anchors {
                    right: battery.left
                    top: parent.top
                    bottom: parent.bottom
                }

                color: networkArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                Text {
                    anchors.centerIn: parent

                    text: " "
                    // "󰤮 "
                    color: networkArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 16
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
                width: 30

                anchors {
                    right: notifications.left
                    top: parent.top
                    bottom: parent.bottom
                }

                color: batteryArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                Text {
                    anchors.centerIn: parent

                    color: batteryArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container
                    text: ""
                    // "", "", "", "", "", ""

                    font {
                        pixelSize: 16
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
                width: 30

                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

                color: notificationArea.containsMouse ? Colours.md3.primary : Colours.md3.primary_container

                Text {
                    anchors.centerIn: parent

                    text: "󰂚"
                    // text: "󱅫"
                    color: notificationArea.containsMouse ? Colours.md3.on_primary : Colours.md3.on_primary_container

                    font {
                        pixelSize: 16
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
