import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "./"

Rectangle {
    id: leftSection
    width: 400;
    height: 450;
    radius: 10;

    layer.enabled : true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Qt.rgba(0,0,0,0.3);
        shadowBlur: 1.0
        shadowVerticalOffset: 2
    }


    Rectangle { // 본 데이터를 감싸는 Rect
        anchors.centerIn: parent
        width: parent.width - 50;
        height: parent.height - 50;

        color: "transparent"

        ColumnLayout {
            height: parent.height
            width: parent.width
            Layout.fillWidth: true

            spacing: 40;

            InputLabel {
                id: money
                titles: "Request Amount"
                input: TextFieldCustom {

                    placeholderText: "ex) 10000"
                }
            }

            InputLabel {
                id: inputChip
                titles: "Number of Chips Requested"
                input: TextFieldCustom {

                    placeholderText: "ex) 20"
                }
            }

            InputLabel {
                id: output
                titles: "Number of Chips Responsed"
                input: TextFieldCustom {

                    placeholderText: "ex) 20"
                }
            }

            InputLabel {
                id: status
                titles: "Status"
                input: TextFieldCustom {

                    placeholderText: "ex) 200"
                }
            }

            Item {
                Layout.fillHeight: true;
            }

            ButtonCustom {
                labelText: "Send"
                Layout.fillWidth: true;
                Layout.bottomMargin: 10
                height: 40;

                MouseArea {
                    anchors.fill: parent;

                    onClicked: {
                        var date = new Date();
                        var sqlDateTime = date.toLocaleString(Qt.locale(), "yyyy-MM-dd hh:mm:ss");

                        // 메인 파일에서 접근할 때
                        Log.itemInsert(parseInt(inputChip.text),
                            parseInt(output.text),
                            sqlDateTime,
                            parseInt(status.text),
                            parseInt(money.text));

                        console.log(inputChip.input.toString())

                    }
                }
            }
        }
    }
}