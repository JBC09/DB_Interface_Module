import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    width: parent.width;
    Layout.preferredHeight: 40

    color: "transparent"
    
    // 커스텀 라벨의 텍스트로 지정
    property string titles
    
    // 별칭을 사용하여 loader의 item을 설정할 수 있음
    property alias input: inputLoader.sourceComponent
    property string text: inputLoader.item.text ? inputLoader.item.text : ""
    
    Column {
        width: parent.width;
        spacing: 5;
        
        
        //라벨 텍스트 스타일 지정
        Text {
            text: qsTr(titles);
            font.bold: true;
            font.family: "Pretendard"
            font.pixelSize: 12;
            color: "gray"
        }
        
        // loader사용으로 원하는 위젯 연결 가능
        Loader {
            id: inputLoader

        }
    }

}
