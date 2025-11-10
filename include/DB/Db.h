//
// Created by CLX on 24. 11. 22.
//

#ifndef DB_H
#define DB_H

#include <QVariantMap>
#include <QVariantList>
#include <mysqlx/xdevapi.h>
#include <map>
#include <nlohmann/json.hpp>
#include <iostream>
#include <fstream>


using json = nlohmann::json;
namespace  fs = std::filesystem;
using namespace std;

// DB 추상 클래스
class DB {

public:


    virtual void f_insert(string code, int money, int input, int ouput, int status) = 0;

    virtual void f_delete(string code) = 0;

    virtual QVariantList  f_read() = 0;

    virtual  int setCount(int value) = 0;

private:
    QVariantList logList;

    int m_count = 0;
};


// MYSQL 상속
class MYSQL : public DB {

public:
    MYSQL();
    ~MYSQL();

    void f_insert(string code, int money, int input, int ouput, int status) override;

    void f_delete(string code) override;

    QVariantList f_read() override;

    int setCount(int value) override;

private:
    string m_host;
    string m_userId;
    string m_password;
    unsigned int m_port;

    int m_count = 0;

    unique_ptr<mysqlx::Session> m_session;
    unique_ptr<mysqlx::Schema> m_schema; // Database 지정

    unique_ptr<mysqlx::Table> m_log_table;  // 거래 로그 테이블

};



// LocalJson class 생성 - DB class 상속
class JSON : public DB {

public:
    JSON();
    ~JSON();

    void f_insert(string code, int money, int input, int ouput, int status) override;

    void f_delete(string code) override;

    QVariantList f_read() override;

    int setCount(int value) override;

private:

    int m_count = 0;

    QVariantList logList;

    ifstream m_jsonFile;

    nlohmann::json m_JsonData;
};


#endif //DB_H
