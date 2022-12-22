const { param } = require('express/lib/request');
const tedious = require('tedious');
const { id } = require('tedious/lib/data-types/null');
const Request = tedious.Request;
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;

class BRLogServices {

    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
    }

    addBRLog(brLogData) {

        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (brLogData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: brLogData[paramName]
                });
            }
            else if(paramName == 'dName') {
                paramData.push({
                    name: 'dName',
                    type: TYPES.VarChar,
                    value: null
                });
            }
            else if(paramName == 'type') {
                paramData.push({
                    name: 'type',
                    type: TYPES.VarChar,
                    value: null
                });
            }
        }

        addParam('dName', TYPES.VarChar);
        addParam('dID', TYPES.Int);
        addParam('date', TYPES.VarChar);
        addParam('time', TYPES.VarChar);
        addParam('type', TYPES.VarChar);
        addParam('Note', TYPES.VarChar);

        return this.databaseConnection.callProcedure('AddBRLog', paramData);
    
    }

    updateBRLog(brLogData) {

        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (brLogData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: brLogData[paramName]
                });
            }
            else if(paramName == 'dName') {
                paramData.push({
                    name: 'dName',
                    type: TYPES.VarChar,
                    value: null
                });
            }
            else if(paramName == 'dID') {
                paramData.push({
                    name: 'dID',
                    type: TYPES.Int,
                    value: null
                });
            }
        }

        addParam('ID', TYPES.Int);
        addParam('dName', TYPES.VarChar);
        addParam('dID', TYPES.Int);
        addParam('date', TYPES.VarChar);
        addParam('time', TYPES.VarChar);
        addParam('type', TYPES.VarChar);
        addParam('Note', TYPES.VarChar);

        return this.databaseConnection.callProcedure('UpdateBRLog', paramData);
    
    }

    deleteBRLog(brLogData) {

        const paramData = [
            {
                name : 'ID',
                type : TYPES.Int,
                value : brLogData.ID
            }
        ];
        
        return this.databaseConnection.callProcedure('DeleteBRLog', paramData);

    }
    
    searchBRLogForDogID(dog_id) {

        const param = [
            {name : 'id', type : TYPES.Int, value : dog_id}
        ]

        return this.databaseConnection.callProcedure("SearchBRLogByDogID", param);

    }

    searchBRLogByID(log_id) {

        const param = [
            {name : 'id', type : TYPES.Int, value : log_id}
        ]
        return this.databaseConnection.callProcedure("SearchBRLogByID", param);
    }

    applyBRLogFilter(data) {
        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (data[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: data[paramName]
                });
            }
        }

        addParam('DogID', TYPES.Int);
        addParam('StartDate', TYPES.VarChar);
        addParam('EndDate', TYPES.VarChar);

        return this.databaseConnection.callProcedure('ApplyBRLogFilter', paramData);
    }

    insertECodeToMessage(statusCode) {

        switch(statusCode) {
            case 1:
                return 'Dog info needed';
            case 3:
                return 'Only one of dog ID and dog name needed';
            case 5:
                return 'Dog does not exist';
            case 6:
                return 'There is more than one dog with the given name';
            case 7:
                return 'The given dog ID does not exist';
            case 25:
                return 'Please provide a bathroom log type';
            case 27:
                return 'The record already exists';
            case 85:
                return 'The date is not valid';
            case 86:
                return 'The time is not valid';
            case 8:
                return 'Cannot add a bathroom log from the future';
            default:
                return 'There was an error inserting the bathroom log';
            
        }

    }

    updateECodeToMessage(statusCode) {

        switch(statusCode) {
            case 1:
                return 'Dog info needed';
            case 3:
                return 'Only one of dog ID and dog name needed';
            case 5:
                return 'Dog does not exist';
            case 6:
                return 'There is more than one dog with the given name'
            case 7:
                return 'The given dog ID does not exist';
            case 8:
                return 'Cannot put bathroom log from the future'
            case 25:
                return 'Please select bathroom type';
            case 85:
                return 'Invalid date';
            case 86:
                return 'Invalid time';
            case 96:
                return 'Invalid bathroom log ID';
            default:
                return 'There was an error updating the bathroom log.';
        }

    }

    deleteECodeToMessage(statusCode) {

        switch(statusCode) {
            case 1:
                return 'Invalid bathroom log ID';
            default:
                return 'There was an error deleting the bathroom log';
        }

    }

}

module.exports.brLogServices = new BRLogServices(databaseConnection);

