import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "Components"

Window {
    width: 1000
    height: 600
    visible: true
    minimumWidth: 1000;
    minimumHeight: 600;
    maximumWidth: 1000;
    maximumHeight: 600;

    title: qsTr("Clonix Data")

    ColumnLayout {
        anchors.fill: parent
        spacing:0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100;

            Text {
                text: qsTr("Clonix SideCar Data");
                color: "#495057"

                anchors.centerIn: parent

                font {
                    pixelSize: 30;
                    family: "Impact"
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 900;
            Layout.preferredHeight: 500;
            radius: 20;
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                spacing: 20;
                width: parent.width;
                height: parent.height


                LeftSection {
                    Layout.alignment: Qt.AlignTop
                }

                RightSection {
                    Layout.alignment: Qt.AlignTop
                }
            }
        }
    }

}
