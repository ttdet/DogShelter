const tedious = require('tedious');
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;
const cryptoJS = require('crypto-js');
const crypto = require('crypto');


class UserServices {

    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
    }

    createCredential(credential) {
        const salt = crypto.randomBytes(8);
        let key = salt.toString('hex');
        let encPW = cryptoJS.SHA256(credential.pw + key).toString();
        var param = [
            {name : 'username', type : TYPES.VarChar, value : credential.username},
            {name : 'encPW', type : TYPES.VarChar, value : encPW},
            {name : 'key', type : TYPES.VarChar, value : key}
        ];
        return this.databaseConnection.callProcedure("CreateCredential", param);
    }

    handleLogin(credential) {
        var param = [
            {name : 'username', type : TYPES.VarChar, value : credential.username}
        ]
        return this.databaseConnection.callProcedure("GetLoginCredential", param);
    }

    authLogin(credential, inputPW) {
        let key = credential[0].Key;
        let encPW = credential[0].EncPW;
        let hashedInputPW = cryptoJS.SHA256(inputPW + key).toString();

        if (encPW == hashedInputPW) {
            return 0;
        } else {
            return 1;
        }
    }

    
}

module.exports.UserServices = new UserServices(databaseConnection);

