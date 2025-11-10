//
// Created by CLX on 24. 11. 22.
//

#ifndef LOG_H
#define LOG_H

#include <QObject>
#include <Db/Db.h>




class Log: public QObject {
    Q_OBJECT

    Q_PROPERTY(QVariantList list READ listView WRITE setList NOTIFY listChanged)

public:
    explicit Log(QObject *parent = nullptr);

    QVariantList listView() const;

    void setList(const QVariantList &value);

    Q_INVOKABLE void loadList() ;

    Q_INVOKABLE void changeDb(int index);

    Q_INVOKABLE void itemInsert(int inputChip, int outputChip, QString timeStamp, short status, int money);

    Q_INVOKABLE void itemRemove(QString logCode, int index);

    signals:
    void listChanged();


private:
    DB* m_DB;

    QVariantList m_list;

    ifstream m_jsonFile;
};



#endif //LOG_H
