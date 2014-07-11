import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.0
import Qt.labs.folderlistmodel 2.1
import QtQuick.Controls.Styles 1.1
import Deepin.Widgets 1.0
import com.deepin.bootmaker 1.0

DWindowFrame {
    id: windowFrame
    anchors.fill: parent

    Rectangle {
        BootMaker {
            id: usbCreator
            objectName: "usbCreatorDeepin"
            property string isoImagePath: ""
            property string usbDriver: ""
            property int lableMaxWidth: 380

            function refreshUsbDriver() {
                var oldCurText = usbDriver.text
                var usblist = usbCreator.listUsbDrives()
                usbDriver.labels = usblist
                if (usblist.length > 0) {
                    usbIcon.source = "qrc:/image/usb-active.png"
                }
            }
        }

        Timer {
            id: processTimer
            interval: 2000
            running: false
            repeat: true
            onTriggered: {
                processRate.text = "%1%".arg(usbCreator.processRate())
                console << processRate.text
                if (usbCreator.isFinish()) {
                    processRate.text = "100%"
                    processTimer.stop()
                    processNext.clicked()
                }
            }
        }

        Timer {
            id: usbRefreshTimer
            interval: 3000
            running: true
            repeat: true
            onTriggered: {
                usbCreator.refreshUsbDriver()
            }
        }
    }
    Row {
        Rectangle {
            color: "transparent"
            width: 230
            height: 420
            Column {
                anchors.centerIn: parent
                width: 64
                height: 68 * 3
                Image {
                    id: isoIcon
                    source: "qrc:/image/iso-inactive.png"
                }
                NumberAnimation {
                    id: isoAnimation
                    running: false
                    loops: Animation.Infinite
                    target: isoIcon
                    from: 0
                    to: 360
                    property: "rotation"
                    duration: 2000
                }
                AnimatedImage {
                    id: process
                    source: "qrc:/image/process-inactive.png"
                }
                Rectangle {
                    width: 64
                    height: 64
                    color: "transparent"
                    Image {
                        id: usbIcon
                        source: "qrc:/image/usb-inactive.png"
                    }
                    Rectangle {
                        width: 50
                        height: 64
                        color: "transparent"
                        DLabel {
                            id: processRate
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: ""
                            font.pixelSize: 10
                        }
                    }
                }
            }
        }
        Rectangle {
            color: "transparent"
            width: 430
            height: 420
            Column {
                Rectangle {
                    color: "transparent"
                    width: 430
                    height: 100
                    Row {
                        Rectangle {
                            color: "transparent"
                            width: 230
                            height: 100
                            Image {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                id: logo
                                source: "qrc:/image/logo.png"
                            }
                            DLabel {
                                x: parent.x + 178
                                y: parent.y + 67
                                font.pixelSize: 10
                                text: "0.98"
                       }
                        }
                        Rectangle {
                            color: "transparent"
                            width: 195
                            height: 100
                            DImageButton {
                                id: btClose
                                anchors.right: parent.right
                                normal_image: "qrc:/image/window_close_normal.png"
                                hover_image: "qrc:/image/window_close_hover.png"
                                press_image: "qrc:/image/window_close_press.png"

                                onClicked: {
                                    usbCreatorUI.close()
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    color: "transparent"
                    width: 430
                    height: 70
                    Column {
                        DLabel {
                            id: descriptionsBye
                            font.pixelSize: 14
                            width: usbCreator.lableMaxWidth
                            wrapMode: Text.Wrap
                            text: qsTr("<font color='#ffffff'>Easy to use without redundancy</font></br>")
                        }
                        DLabel {
                            id: descriptions
                            font.pixelSize: 11
                            width: usbCreator.lableMaxWidth
                            wrapMode: Text.Wrap
                            text: qsTr("<br><font color='#a7a7a7'>Welcome to use Deepin Boot Maker software and you can quickly create Deepin OS Startup Disk through a simple setting, which supports dual BIOS and <font color='#ebab4c'>UEFI</font> start.</font></br>")
                        }
                    }
                }
                Rectangle {
                    id: steps
                    color: "transparent"
                    width: 430
                    height: 250
                    Column {
                        id: firstStep
                        Rectangle {
                            id: rcIso
                            color: "transparent"
                            width: 430
                            height: 75
                            Column {
                                DLabel {
                                    id: selectIsoHits
                                    font.pixelSize: 12
                                    width: usbCreator.lableMaxWidth
                                    wrapMode: Text.Wrap
                                    text: qsTr("<br><font color='#ffffff'>Select the ISO File:</font></br>")
                                }
                                Rectangle {
                                    color: "transparent"
                                    width: 430
                                    height: 6
                                }
                                DFileChooseInput {
                                    id: isoPath
                                    width: 210
                                    FileDialog {
                                        id: isoFileChoose
                                        visible: false
                                        selectMultiple: false
                                        // folder: usbCreator.homeDir()
                                        //nameFilters: ["ISO (*.iso);;"]
                                        onAccepted: {
                                            usbCreator.isoImagePath = usbCreator.url2LocalFile(
                                                        isoFileChoose.fileUrl)
                                            if (usbCreator.isISOImage(
                                                        usbCreator.isoImagePath)) {
                                                usbCreator.isoImagePath = usbCreator.isoImagePath
                                                isoPath.textInput.text = usbCreator.isoImagePath
                                                isoIcon.source = "qrc:/image/iso-active.png"
                                            } else {
                                                usbCreator.isoImagePath = ""
                                                isoPath.textInput.text = ""
                                            }
                                            usbCreator.refreshUsbDriver()
                                        }
                                    }

                                    onFileChooseClicked: {
                                        isoFileChoose.open()
                                    }
                                }
                            }
                        }
                        Rectangle {
                            id: rcUsb
                            color: "transparent"
                            width: 430
                            height: 75
                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                DLabel {
                                    id: selectUsbHits
                                    font.pixelSize: 12
                                    width: usbCreator.lableMaxWidth
                                    wrapMode: Text.Wrap
                                    text: qsTr("<br><font color='#ffffff'>Select the USB Flash Drive:</font></br>")
                                }
                                Rectangle {
                                    color: "transparent"
                                    width: 430
                                    height: 5
                                }
                                DComboBox {
                                    width: 210
                                    id: usbDriver
                                    parentWindow: usbCreatorUI
                                    menu.parentWindow: usbCreatorUI
                                    labels: usbCreator.listUsbDrives()
                                    onMenuSelect: console.log(usbDriver.text)
                                }

                                Rectangle {
                                    color: "transparent"
                                    width: 430
                                    height: 5
                                }
                                DCheckBox {
                                    id: formatDisk
                                    text: qsTr("<font color='#ffffff'>Format USB disk.</font>")

                                    MessageDialog{
                                        id: messageDialog
                                        icon: StandardIcon.Warning
                                        standardButtons: StandardButton.Yes | StandardButton.No
                                        title: qsTr("Format USB Disk");
                                        text: qsTr("Would you want to FORMAT the USB disk? All partitions on usb disk will be deleted, please backup you data first!")
                                        onAccepted: {
                                            formatDisk.checked = true
                                        }
                                        onRejected:{
                                            formatDisk.checked = false
                                        }
                                    }

                                    onClicked:{
                                        if (true === formatDisk.checked) {
                                            messageDialog.visible = true
                                        }
                                    }
                                }

                                Rectangle {
                                    color: "transparent"
                                    width: 430
                                    height: 5
                                }

                                DCheckBox {
                                    id: bisoMode
                                    text: qsTr("<font color='#ffffff'>Support BIOS. Unselect here. </font>")
                                }
                            }
                        }
                        Rectangle {
                            id: rcStart
                            color: "transparent"
                            width: 230
                            height: 100
                            DTransparentButton {
                                id: startBt
                                text: qsTr("Start")
                                width: 100
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                onClicked: {
                                    //Debug Code
                                    //secondStep.visible = true
                                    //  firstStep.visible = false
                                    //processNext.visible = true
                                    var result = usbCreator.start(
                                                isoPath.text,
                                                usbDriver.text,
                                                bisoMode.checked,
                                                formatDisk.checked)
                                    if (0 === result) {
                                        //make the iso/usb selector invisible
                                        firstStep.visible = false
                                        secondStep.visible = true
                                        process.source = "qrc:/image/process-active.gif"
                                        isoAnimation.running = true
                                        process.playing = true
                                        processTimer.start()
                                        btClose.visible = false
                                    }
                                    console.log(isoPath.text + usbDriver.text)
                                }
                            }
                        }
                    }
                    Column {
                        id: secondStep
                        visible: false
                        Rectangle {
                            id: warningHits
                            width: 460
                            height: 130
                            color: "transparent"
                            DLabel {
                                id: warningLabel
                                anchors.verticalCenter: parent.verticalCenter
                                width: usbCreator.lableMaxWidth
                                wrapMode: Text.Wrap
                                text: qsTr("<font color='#ffffff'><br>Please <font color='#ebab4c'>DO NOT</font> remove the USB flash drive or shutdown while file is writing.</br></font>" )
                                font.pixelSize: 12
                            }
                        }
                        Rectangle {
                            width: 230
                            height: 100
                            color: "transparent"
                            DTransparentButton {
                                id: processNext
                                text: "Next"
                                width: 100
                                visible: false
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                onClicked: {
                                    //make the iso/usb selector invisible
                                    secondStep.visible = false
                                    thirdStep.visible = true
                                    btClose.visible = true
                                    isoAnimation.running = false
                                }
                            }
                        }
                    }
                    Column {
                        id: thirdStep
                        visible: false
                        Rectangle {
                            id: finishHits
                            width: 460
                            height: 130
                            color: "transparent"
                            DLabel {
                                id: finishLabel
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("<br><font color='#057aff'>Congratulations!</font></br><br><font color='#ffffff'>Deepin OS Startup Disk creates successfully.</font></br>")
                                font.pixelSize: 12
                                wrapMode: TextEdit.WordWrap
                            }
                        }
                        Rectangle {
                            width: 230
                            height: 100
                            color: "transparent"
                            Row {
                                DTransparentButton {
                                    text: qsTr("Quit")
                                    width: 100
                                    anchors.verticalCenter: parent.verticalCenter
                                    //anchors.horizontalCenter: parent.horizontalCenter
                                    onClicked: {
                                        usbCreatorUI.close()
                                    }
                                }
                                DTransparentButton {
                                    text: qsTr("Reboot")
                                    width: 100
                                    anchors.verticalCenter: parent.verticalCenter
                                    //anchors.horizontalCenter: parent.horizontalCenter
                                    onClicked: {
                                        usbCreator.exitRestart()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
