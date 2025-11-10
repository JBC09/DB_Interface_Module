import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "./"

Rectangle {
    id: rightSection
    width: 480
    height: 450
    radius: 10

    property int logCount: Log.list.length;
    property double globalContentY: 0

    // 재사용할 TEXT 컴포넌트 thead row
    component CustomText: Text {
        color: "white"
        font.family: "Arial"
        font.bold: true
        Layout.preferredWidth: 55
    }

    // 재사용할 TEXT 컴포넌트 tbody row
    component CustomBlackText : CustomText {
        color: "#121212"
        font.bold: false;
    }


    // 그림자
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Qt.rgba(0, 0, 0, 0.3);
        shadowBlur: 1.0
        shadowVerticalOffset: 2
    }

    Rectangle { // 본 데이터를 감싸는 Rect
        anchors.centerIn: parent
        width: parent.width - 50
        height: parent.height - 50
        color: "transparent"


        // 오른쪽 섹션 컬럼
        ColumnLayout {
            spacing: 30;

            InputLabel {
                titles: "Select DB"

                input: ComboBox { // DB 종류 선택 콤보박스
                    textRole: "text"
                    valueRole: "value"
                    width: 430

                    topPadding: 6
                    bottomPadding: 6
                    leftPadding: 6
                    rightPadding: 6

                    background: Rectangle {
                        radius: 5;
                        color: "#f8fafc"
                    }

                    model: ListModel {
                        ListElement { // mysql에 관한 박스
                            text: "MySQL"
                            value: "mysql"
                        }

                        ListElement { // json에 관한 박스
                            text: "Local Json"
                            value: "json"
                        }
                    }

                    currentIndex: 0; // 기본값을 0번째 index로 선택

                    onCurrentIndexChanged: {
                        Log.changeDb(currentIndex);
                    }
                }
            }


            // 로그 INPUT
            InputLabel {
                titles: qsTr("Log _ " + logCount);

                width: parent.width
                height: 340;

                input: Column {
                    spacing: 3;

                    Rectangle {
                        width: parent.width - 20
                        height: 40
                        color: "#495057"
                        radius: 5

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 5
                            anchors.leftMargin: 15;


                            CustomText {
                                text: "Input"
                            }
                            CustomText {
                                text: "Output"
                            }
                            CustomText {
                                text: "Status"
                            }
                            CustomText {
                                Layout.fillWidth: true
                                text: "Date"
                            }
                        }
                    }


                    // 로그 데이터를 스크롤 뷰로 보여줌
                    Rectangle {
                        id: scrollView
                        width: 430
                        height: 250
                        clip: true

                        // log list c++에서 model을 받아옴
                        ListView {
                            id: listView
                            width: 430
                            height: 250
                            anchors.leftMargin: 15;
                            model: Log.list
                            spacing: 5


                            property double lastContentY: 0

                            onContentYChanged: {
                                lastContentY = globalContentY
                                globalContentY = contentY
                            }

                            onModelChanged: {
                                contentY = lastContentY
                            }


                            delegate: Rectangle {
                                id: rects
                                width: 410;
                                height: 50
                                radius: 5
                                color: index % 2 ? "#f8f9fa" : "white"
                                border.color: "#dee2e6"
                                border.width: 1

                                opacity: 0
                                scale: 0


                                Component.onCompleted: {
                                    ani.start()
                                }

                                ParallelAnimation {
                                    id: ani;
                                    NumberAnimation {
                                        target: rects
                                        property: "opacity"
                                        from: 0;
                                        to: 1.0
                                        duration: 200
                                    }
                                    NumberAnimation {
                                        target: rects
                                        property: "scale"
                                        from: 0;
                                        to: 1.0
                                        duration: 200
                                        easing.type: Easing.OutBack
                                    }
                                }


                                RowLayout {
                                    width: parent.width
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    anchors.leftMargin: 20;

                                    spacing: 5


                                    CustomBlackText {
                                        text: modelData.transactionInput
                                    }
                                    CustomBlackText {
                                        text: modelData.transactionOutput
                                    }
                                    CustomBlackText {
                                        text: modelData.transactionStatus
                                        color: modelData.transactionStatus == "200" ? "#2DB400" : "coral";
                                        font.bold: true;
                                    }
                                    CustomBlackText {
                                        Layout.fillWidth: true
                                        color: "black"
                                        text: modelData.transactionCode
                                    }

                                    ButtonCustom {
                                        labelText: "delete"
                                        Layout.preferredWidth: 70;
                                        height: 30;
                                        radius: 3;
                                        color: "lightcoral"

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                Log.itemRemove(modelData.transactionCode, index);
                                                listView.model.splice(index, 1);
                                                logCount = logCount - 1;
                                            }
                                        }
                                    }
                                }

                                // 호버 효과
                                MouseArea {
                                    propagateComposedEvents: true
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: parent.color = "#e9ecef"
                                    onExited: parent.color = index % 2 ? "#f8f9fa" : "white"
                                }
                            }

                            footer: Rectangle {
                                width: 410
                                height: 50
                                radius: 5
                                color: "#f8f9fa"
                                border.color: "#dee2e6"
                                border.width: 1

                                ButtonCustom {
                                    anchors.centerIn: parent
                                    labelText: "Add New"
                                    width: 100
                                    height: 30
                                    radius: 3

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            // 추가 버튼 클릭 시 동작
                                            Log.loadList();
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
}




