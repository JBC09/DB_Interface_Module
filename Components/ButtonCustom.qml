import QtQuick
import QtQuick.Controls
import QtQuick.Window
import "./"

Rectangle {
    id: buttonCustom

    // 외부에서 변경 가능한 텍스트 property
    property string labelText: "Button"

    property color primaryColor: "#495057"; // unhover Color
    property color hoverColor: "black"; // hover color

    // 제일 둥글게
    radius: height / 2;
    
    color: primaryColor;

    Text {
        id: buttonLabel
        text: qsTr(labelText)
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 14
        font.bold: true
        font.family: "Arial"
    }
    
    
    // 버튼 color 애니메이션 지정
    Behavior on color {
        ColorAnimation {
            duration: 350
        }
    }

    // 버튼 radius 애니메이션 지정
    Behavior on radius {
        NumberAnimation {
            duration: 350
        }
    }
    
    
    // 버튼 마우스 반응 이벤트 지정
    MouseArea {
        id: mouseArea;
        anchors.fill: parent
        hoverEnabled: true;

        onEntered: {
            buttonCustom.color = hoverColor
            buttonCustom.radius = 0;
        }
        onExited: {
            buttonCustom.color = primaryColor
            buttonCustom.radius = buttonCustom.height / 2
        }
    }
}