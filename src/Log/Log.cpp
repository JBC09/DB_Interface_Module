//
// Created by CLX on 24. 11. 22.
//

#include <Log/Log.h>
#include <DB/Db.h>
#include <QDebug>


Log::Log(QObject *parent):QObject(parent) {
    qDebug() << "Log Class Make";

    // 기본 mysql 세팅
    m_DB = new MYSQL;
    loadList();
}

QVariantList Log::listView() const {
    return m_list;
}

void Log::loadList()  {

    QVariantList newList = m_DB->f_read();

    if (!newList.isEmpty()) {
        // 기존 리스트에 새 데이터만 추가
        m_list.append(newList);
        emit listChanged();
    }

}

void Log::changeDb(int index)  {
    if(index == 0) {
        m_DB = new MYSQL;
    }
    else {
        m_DB = new JSON;
    }

    m_list.clear();
    loadList();

    emit listChanged();
}


void Log::setList(const QVariantList &value) {
    cout << "Log setList !"  << endl;

    m_list = value;
    emit listChanged();
}

void Log::itemInsert(int inputChip, int outputChip, QString timeStamp, short status, int money) {
    m_DB->f_insert(timeStamp.toStdString(), money, inputChip, outputChip, status);

    QVariantMap item;

    item["transactionInput"] = inputChip;
    item["transactionOutput"] = outputChip;
    item["transactionCode"] = timeStamp;
    item["transactionStatus"] = status;
    item["money"] = money;

    m_list.push_front(item);

    m_DB->setCount(1);
    setList(m_list);
}

void Log::itemRemove(QString logCode, int index) {
    m_DB->setCount(-1);
    m_DB->f_delete(logCode.toStdString());

    m_list.erase(m_list.begin() + index);
    emit listChanged();
}
