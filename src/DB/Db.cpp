//
// Created by CLX on 24. 11. 22.
//

#include "DB\Db.h"
#include <QDebug>



// MYSQL 아래는 MYSQL CLASS의 로직구간입니다
MYSQL::MYSQL(){
    try {
        m_host = "localhost";
        m_port = 33060;
        m_userId = "root";
        m_password = "1234";


        cout << "Connecting to database..."  << endl;
        m_session = make_unique<mysqlx::Session>(m_host, m_port, m_userId, m_password);
        m_schema = make_unique<mysqlx::Schema>(m_session->getSchema("clonixSideCarLog"));

        m_log_table = make_unique<mysqlx::Table>(m_schema->getTable("transactionLog"));

        qDebug() << "host: " << m_host << " port: " << m_port << "connect!" ;
    }
    catch (...) {
        cout << "Connection to database failed." << endl;
    }

};
// host, user, password, port 값 초기화


MYSQL::~MYSQL() { // mysql 연결해제 및 메모리 할당 해제
    m_session->close();

    m_session.reset();
    m_schema.reset();
    m_log_table.reset();
}


void MYSQL::f_insert(string code, int money,int input, int ouput, int status) {
    // 거래 로그 추가
    try {
        m_log_table->insert("transactionPk", "transactionCode", "transactionInput", "transactionOutput", "transactionStatus", "transactionMoney")
    .values(NULL, code, input, ouput, status, money).execute();

    }
    catch (mysqlx::Error err) {
          cout <<  "DB.cpp -> insert error  " << err;
    }
}

void MYSQL::f_delete(string code) {
    // 거래 로그 삭제
    try {
        m_log_table->remove().where("transactionCode = :code").bind("code", code).execute();
    }
    catch (...) {
        cout << "DB.cpp -> delete error" << endl;
    }
}

QVariantList MYSQL::f_read() {
    try {
        mysqlx::RowResult result = m_log_table->select("*")
                .orderBy("transactionPk DESC")
                .limit(20)
                .offset(m_count)
                .execute();

        mysqlx::RowResult transactionCode = m_log_table->select("CAST(transactionCode AS CHAR(100))")
                .orderBy("transactionPk DESC")
                .limit(20)
                .offset(m_count)
                .execute();

        QVariantList newList = QVariantList();

        for(mysqlx::Row row : result) {
            QVariantMap logItem;

            mysqlx::Row transactionCodeRow = transactionCode.fetchOne();
            row[1] =  transactionCodeRow[0];

            logItem["transactionPk"] = row[0].get<int>();
            logItem["transactionCode"] = QString::fromStdString(row[1].get<std::string>());
            logItem["transactionInput"] = row[2].get<int>();
            logItem["transactionOutput"] = row[3].get<int>();
            logItem["transactionStatus"] = row[4].get<int>();
            logItem["transactionMoney"] = row[5].get<int>();

            newList.append(logItem);
        }
        cout << "DB.cpp -> read ok" << newList.count() << endl;

        m_count  += newList.count();
        return newList;;
    }
    catch(...) {
        cout << "DB.cpp -> read error" << endl;
    }
}

int MYSQL::setCount(int value) {
     m_count += value;
    return m_count;
}



////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

// 아래는 JSON 클래슥의 로직부분입니다

JSON::JSON(){
    cout << "JSON -> mount" << endl;

    ifstream m_jsonFile("./ClonixDatabase/assets/transactionLog.json");
    m_JsonData = nlohmann::json::parse(m_jsonFile);

    if (m_JsonData.empty()) {
        m_JsonData = json::array();  // 빈 배열로 초기화
    }

};


JSON::~JSON() {

    cout << "JSON -> unmount" << endl;
}


void JSON::f_insert(string code, int money,int input, int ouput, int status) {
    // 거래 로그 추가

    try {
        json j;

        j["transactionCode"] = code;
        j["transactionMoney"] = money;
        j["transactionInput"] = input;
        j["transactionOutput"] = ouput;
        j["transactionStatus"] = status;

        m_JsonData.insert(m_JsonData.begin(),j);
        ofstream o("./ClonixDatabase/assets/transactionLog.json");

        o << setw(4) << m_JsonData << endl;

        o.flush();
        o.close();

    }
    catch (exception &err) {
        cout << err.what() << endl;
    }
}

void JSON::f_delete(string code) {
    // 거래 로그 삭제
    try {
        for (int i = 0; i < m_JsonData.size(); i++) {
            if (m_JsonData[i]["transactionCode"] == code) {
                m_JsonData.erase(m_JsonData.begin() + i);

                // 파일 저장
                ofstream o("./ClonixDatabase/assets/transactionLog.json");
                o << setw(4) << m_JsonData << endl;
                return;
            }
        }
        cout << "JSON delete ok" << endl;
    }
    catch (exception &err) {
        cout << err.what() << endl;
    }

}

QVariantList JSON::f_read() {

   try {
       QVariantList newList;

       for(int i = m_count; i < m_JsonData.size(); i++) {
           json element = m_JsonData.at(i);

           QVariantMap logItem;

           // Qstring으로 변환
           logItem["transactionCode"] = QString::fromStdString(element["transactionCode"].get<std::string>());
           logItem["transactionInput"] = element["transactionInput"].get<int>();
           logItem["transactionOutput"] = element["transactionOutput"].get<int>();
           logItem["transactionStatus"] = element["transactionStatus"].get<int>();
           logItem["transactionMoney"] = element["transactionMoney"].get<int>();

           m_count++;

           newList.append(logItem);

           if(newList.count() >= 20) {
               break;
           }
       }

       cout << "JSON READ" << endl;

       return newList;
   }
    catch (exception &err) {
        cout << err.what() << endl;
    }

}

int JSON::setCount(int value) {
     m_count += value;
    return m_count;
}