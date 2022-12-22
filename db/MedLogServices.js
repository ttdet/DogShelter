const tedious = require('tedious');
const Request = tedious.Request;
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;

class MedLogServices {

    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
    }

    addMedLog(data) {

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

        addParam('dName', TYPES.VarChar);
        addParam('dID', TYPES.Int);
        addParam('vfn', TYPES.VarChar);
        addParam('vln', TYPES.VarChar);
        addParam('vID', TYPES.Int);
        addParam('mName', TYPES.VarChar);
        addParam('mID', TYPES.Int);
        addParam('date', TYPES.VarChar);
        addParam('time', TYPES.VarChar);
        addParam('amount', TYPES.Real);
        addParam('Note', TYPES.VarChar);
        return this.databaseConnection.callProcedure('AddMedLog', paramData);
    }

    updateMedLog(data) {
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

        addParam('MedLogID', TYPES.Int);
        addParam('dName', TYPES.VarChar);
        addParam('dID', TYPES.Int);
        addParam('vfn', TYPES.VarChar);
        addParam('vln', TYPES.VarChar);
        addParam('vID', TYPES.Int);
        addParam('mName', TYPES.VarChar);
        addParam('mID', TYPES.Int);
        addParam('date', TYPES.VarChar);
        addParam('time', TYPES.VarChar);
        addParam('amount', TYPES.Real);
        addParam('Note', TYPES.VarChar);
        return this.databaseConnection.callProcedure('UpdateMedLog', paramData);
    }

    deleteMedLog(data) {
        const paramData = [
            {name : 'MedLogID', type : TYPES.Int, value : data.MedLogID}
        ];

        return this.databaseConnection.callProcedure('DeleteMedLog', paramData);
    }

    searchMedLogByID(log_id) {
        const paramData = log_id ? [{name : 'ID', type : TYPES.Int, value : log_id}] : [];
        return this.databaseConnection.callProcedure('SearchMedLogByID', paramData);
    }
    
    searchMedLogByDogID(dog_id) {
        const paramData = dog_id ? [{name : 'DogID', type : TYPES.Int, value : dog_id}] : [];
        return this.databaseConnection.callProcedure('SearchMedLogByDogID', paramData);
    }

    applyMedLogFilter(data) {
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

        return this.databaseConnection.callProcedure('ApplyMedLogFilter', paramData);
    }

    InsertionECodeToMsg(statusCode) {
        switch(statusCode) {
            case 5:
                return 'Dog name does not exist';
            case 6:
                return 'More than one dog with the given name';
            case 7:
                return "Dog ID does not exist";
            case 8:
                return "Med name does not exist";
            case 9:
                return "More than one med with the given name";
            case 10:
                return "Med ID does not exist";
            case 15:
                return "Please provide an amount";
            case 20:
                return "Volunteer does not exist";
            case 21:
                return "More than one volunteer with given first name";
            case 22:
                return "Volunteer does not exist";
            case 23:
                return "More than one volunteer with given last name";
            case 24:
                return "Volunteer does not exist";
            case 25:
                return "More than one volunteer with given full name";
            case 26:
                return "Please select a volunteer";
            case 27:
                return "The record already exists";
            case 67:
                return "Medicine out of stock";
            case 85:
                return "Invalid date";
            case 86:
                return "Invalid time";
            case 87:
                return 'Cannot add medication log from the future';
            default:
                return 'There was an error inserting the medication log';
        }
    }

    updateECodeToMsg(statusCode) {
        switch(statusCode) {
            case 5:
                return 'Dog name does not exist';
            case 6:
                return 'More than one dog with the given name';
            case 7:
                return "Dog ID does not exist";
            case 8:
                return "Food name does not exist";
            case 9:
                return "More than one food with the given name";
            case 10:
                return "Med ID does not exist";
            case 26:
                return "Volunteer does not exist";
            case 67:
                return "Not enough medicication in stock";
            case 85:
                return "Invalid date";
            case 86:
                return "Invalid time";
            case 87:
                return 'Cannot put medication log from the future';
            default:
                return 'There was an error updating the medication log';
        }
    }

}

module.exports.MedLogServices = new MedLogServices(databaseConnection);

