const tedious = require('tedious');
const Request = tedious.Request;
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;

class MedServices {

    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
    }


    addMed(medData) {

        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (medData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: medData[paramName]
                });
            }
        }

        addParam('Name', TYPES.VarChar);
        addParam('Direction', TYPES.VarChar);
        addParam('NeededFor', TYPES.VarChar);
        addParam('BoughtFrom', TYPES.VarChar);
        addParam('Stock', TYPES.Real);
        addParam('UnitPerStock', TYPES.VarChar);

        return this.databaseConnection.callProcedure('AddMed', paramData);
    
    }

    updateMed(medData) {
        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (medData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: medData[paramName]
                });
            }
        }

        addParam('ID', TYPES.Int);
        addParam('Name', TYPES.VarChar);
        addParam('Directions', TYPES.VarChar);
        addParam('NeededFor', TYPES.VarChar);
        addParam('BoughtFrom', TYPES.VarChar);
        addParam('Stock', TYPES.Real);
        addParam('UnitPerStock', TYPES.VarChar);

        return this.databaseConnection.callProcedure('UpdateMed', paramData);
    }

    deleteMed(medData) {
        const paramData = [
            {name : 'MedID', type : TYPES.Int, value : medData['MedID']}
        ];
        
        return this.databaseConnection.callProcedure('DeleteMed', paramData);

    }
    
    searchMedByName(nameSearch) {
    
        const paramData = [{
            name: 'NameSearch',
            type: TYPES.VarChar,
            value: nameSearch
        }];

        return this.databaseConnection.callProcedure('SearchMedByName', paramData);
        
    }

    searchMedByID(id_value) {
    
        const paramData = id_value ? [{name : 'ID', type : TYPES.Int, value : id_value}] : [];
        return this.databaseConnection.callProcedure('SearchMedByID', paramData);

    }

    insertECodeToMessage(statusCode) {
        switch(statusCode) {
            case 1:
                return 'Name cannot be null';
            case 2:
                return 'Stock cannot be negative';
            default:
                return 'There was an error inserting the medication'
        }
    }

    updateECodeToMessage(statusCode) {
        switch(statusCode) {
            case 1:
                return 'Invalid Med ID';
            case 2:
                return 'Invalid medication name';
            default:
                return 'There was an error updating the medication';
        }
    }

}

module.exports.MedServices = new MedServices(databaseConnection);

