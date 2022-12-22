const tedious = require('tedious')
const Connection = tedious.Connection;
const Request = tedious.Request;
const dbconfig = require('./dbconfig').config;
const TYPES = tedious.TYPES;

class DatabaseConnection {

    constructor(server, username, password, database) {
        var config = {  
            server: server,
            authentication: {
                type: 'default',
                options: {
                    userName: username,
                    password: password
                }
            },
            options: {
                // If you are on Microsoft Azure, you need encryption:
                encrypt: true,
                trustServerCertificate: true,
                database: database
            }
        };

        this.connection = new Connection(config);

        this.connectPromise = new Promise((resolve, reject) => {

            this.connection.on('connect', err => {
                if(err) {
                    console.log(`Encountered error while connecting to '${database}'\n${err.message}`);
                    return;
                }
                // If no error, then good to proceed.  
                console.log(`Successfully connected to database '${database}'`);
                resolve();
            });

        });
    
        this.connection.connect();
    }

    waitForSuccessfulConnection() {
        return this.connectPromise;
    }

    // returns result = { rowset: [...] }
    execQuery(query, paramData) {

        const promise = new Promise((resolve, reject) => {

            var result = {rowset: []};

            var request = new Request(query, (err, rowCount) => {
                if (err) {
                    console.log(err);
                }

                resolve(result);
            });

            if(paramData) {
                for(const param of paramData) {
                    request.addParameter(param.name, param.type, param.value);
                }
            }

            request.on('row', columns => {
                const data = {};
                for (const column of columns) {
                    data[column.metadata.colName] = column.value;
                }
                result.rowset.push(data);
            });

            this.connection.execSql(request);

        });

        return promise;
    }

    // paramData = [{ name: ..., type: ..., value: ...} ...]
    // returns result = { rowset: [...], statusCode: int }
    async callProcedure(procedureName, paramData, outputParamData) {
        const promise = new Promise ((resolve, reject) => {
            var result = { rowset: [], statusCode: undefined };

            var request = new Request(`[dbo].[${procedureName}]`, function(err) {
                if (err) {
                    console.log(err);
                }

                resolve(result);
            });

            if(paramData) {
                for(const param of paramData) {
                    request.addParameter(param.name, param.type, param.value);
                }
            }

            if(outputParamData) {
                for(const outputParam of outputParamData) {
                    request.addOutputParameter(outputParam.name, outputParam.type);
                }
            }

            request.on('doneProc', function (rowCount, more, returnStatus, rows) {
                result.statusCode = returnStatus;
            });

            request.on('row', columns => {
                const data = {};
                for (const column of columns) {
                    data[column.metadata.colName] = column.value;
                }
                result.rowset.push(data);
            });

            this.connection.callProcedure(request);

        });

        return promise;
    }
}
module.exports.databaseConnection = new DatabaseConnection(dbconfig.server, dbconfig.username, dbconfig.password, dbconfig.database);