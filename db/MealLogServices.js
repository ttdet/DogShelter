const tedious = require('tedious');
const Request = tedious.Request;
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;

class MealLogServices {

    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
    }


    addMealLog(data) {

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
        addParam('dId', TYPES.Int);
        addParam('fName', TYPES.VarChar);
        addParam('fId', TYPES.Int);
        addParam('date', TYPES.VarChar);
        addParam('time', TYPES.VarChar);
        addParam('amount', TYPES.Real);
        addParam('Note', TYPES.VarChar);
        return this.databaseConnection.callProcedure('AddMealLog', paramData);
    }

    updateMealLog(data) {
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

        addParam('MealLogID', TYPES.Int);
        addParam('dId', TYPES.Int);
        addParam('dName', TYPES.VarChar);
        addParam('fName', TYPES.VarChar);
        addParam('fId', TYPES.Int);
        addParam('date', TYPES.VarChar);
        addParam('time', TYPES.VarChar);
        addParam('amount', TYPES.Real);
        addParam('Note', TYPES.VarChar);
        return this.databaseConnection.callProcedure('UpdateMealLog', paramData);
    }

    deleteMealLog(data) {
        const paramData = [
            {name : 'MealLogID', type : TYPES.Int, value : data.MealLogID}
        ];

        return this.databaseConnection.callProcedure('DeleteMealLog', paramData);
    }

    searchMealLogByID(log_id) {
        const paramData = log_id ? [{name : 'ID', type : TYPES.Int, value : log_id}] : [];
        return this.databaseConnection.callProcedure('SearchMealLogByID', paramData);
    }

    searchMealLogByDogID(dog_id) {
        const paramData = dog_id ? [{name : 'DogID', type : TYPES.Int, value : dog_id}] : [];
        return this.databaseConnection.callProcedure('SearchMealLogByDogID', paramData);
    }

    applyMealLogFilter(data) {
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

        return this.databaseConnection.callProcedure('ApplyMealLogFilter', paramData);
    }

    insertionECodeToMsg(statusCode) {
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
                return "Food ID does not exist";
            case 67:
                return "Not enough food in stock";
            case 85:
                return "Invalid date";
            case 86:
                return "Invalid time";
            case 87:
                return 'Cannot add meal log from the future';
            default:
                return 'There was an error creating the meal log.';
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
                return "Food ID does not exist";
            case 67:
                return "Not enough food in stock";
            case 85:
                return "Invalid date";
            case 86:
                return "Invalid time";
            case 87:
                return 'Cannot put meal log from the future';
            default:
                return 'There was an error updating the meal log';
        }
    }

}



module.exports.MealLogServices = new MealLogServices(databaseConnection);

