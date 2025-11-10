import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


TextField  {
    id: outlineTextField
    width: 350;
    font.pixelSize: 14;
    font.family: "Pretendard"


    // 패딩 간격 미적 효과를 위함
    topPadding: 9
    bottomPadding: 9
    leftPadding: 10
    rightPadding: 9



    // 배경 스타일 지정
    background: Rectangle {
        color:  "#f8fafc";
        antialiasing: true
        radius: 5
        border.width: 1;
        border.color: outlineTextField.activeFocus ? "#495057" : "#f8fafc"
    }
}