// //
// // Created by CLX on 24. 11. 22.
// //
//
// #ifndef RESTAPI_H
// #define RESTAPI_H
//
// #include <httplib.h>
// #include <iostream>
// using namespace std;
//
//
// class RestApi {
//
// public:
//     RestApi();
//
//     virtual void Post(string path) = 0;
//
//     virtual httplib::Response Get(string path) = 0;
//
// private:
// };
//
//
// class Server : virtual public RestApi {
// public:
//     Server() : RestApi() {
//
//     }
//
//     void Post(string path) override;
//     httplib::Response Get(string path) override;
// };
//
//
// class Client : virtual public RestApi {
// public:
//     Client() :  RestApi() {
//
//     }
//     void Post(string path) override;
//     httplib::Response Get(string path) override;
// };
//
//
//
// #endif //RESTAPI_H
