const tedious = require('tedious');
const Request = tedious.Request;
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;

class DogServices {

    
    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
    }

    addDog(dogData) {

        const paramData = [];
        const addParam = (paramName, paramType) => {
            if (dogData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: dogData[paramName]
                });
            }
        }

        addParam('name', TYPES.VarChar);
        addParam('WeightInLbs', TYPES.Int);
        addParam('HasBeenSpayed', TYPES.Bit);
        addParam('DOB', TYPES.VarChar);
        addParam('Sex', TYPES.VarChar);
        addParam('Breed', TYPES.VarChar);
        addParam('information', TYPES.VarChar);
        addParam('GeneralInstruction', TYPES.VarChar);
        addParam('FeedInstruction', TYPES.VarChar);

        return this.databaseConnection.callProcedure('AddDog', paramData);
    
    }

    applyDogFilter(filters) {
        const paramData = [];
        const addParam = (paramName, paramType) => {
            if (filters[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: filters[paramName]
                });
            }
        }

        addParam('Breed', TYPES.VarChar);
        addParam('Sex', TYPES.VarChar);
        addParam('MinAge', TYPES.Int);
        addParam('MaxAge', TYPES.Int);
        addParam('Name', TYPES.VarChar);

        return this.databaseConnection.callProcedure("ApplyDogFilter", paramData);


    }

    updateDog(dogData) {
        const paramData = [];
        const addParam = (paramName, paramType) => {
            if (dogData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: dogData[paramName]
                });
            }
        }

        addParam('ID', TYPES.Int);
        addParam('Name', TYPES.VarChar);
        addParam('WeightInlbs', TYPES.Int);
        addParam('HasBeenSpayed', TYPES.Bit);
        addParam('DOB', TYPES.VarChar);
        addParam('Sex', TYPES.VarChar);
        addParam('Breed', TYPES.VarChar);
        addParam('Information', TYPES.VarChar);
        addParam('GeneralInstruction', TYPES.VarChar);
        addParam('FeedInstruction', TYPES.VarChar);

        return this.databaseConnection.callProcedure('UpdateDog', paramData);
    }

    deleteDog(dogData) {
        const paramData = [
            {name : 'DogID', type : TYPES.Int, value : dogData['DogID']}
        ];
        
        return this.databaseConnection.callProcedure('DeleteDog', paramData);

    }
    
    searchDogByName(nameSearch) {
    
        const paramData = [
            {
                name: 'name_search',
                type: TYPES.VarChar,
                value: nameSearch
            }
        ];

        return this.databaseConnection.callProcedure('SearchDogByName', paramData);

    }

    searchDogByID(id_value) {
        const paramData = id_value ? [{name : 'ID', type : TYPES.Int, value : id_value}] : [];
        return this.databaseConnection.callProcedure('SearchDogByID', paramData);
        
    }

    updateECodeToMessage(statusCode) {
        switch(statusCode) {
            case 1:
                return 'Dog ID provided is null';
            case 3:
                return 'Dog name cannot be null';
            case 2:
                return 'Provided Dog ID does not exist';
            case 55:
                return 'Invalid date of birth';
            case 56:
                return 'Dog cannot be born in the future';
            default:
                return 'There was an error updating the dog';
        }
    }

    insertECodeToMessage(statusCode) {
        switch(statusCode) {
            case 1:
                return 'Name cannot be null';
            case 2:
                return 'Weight must be positive';
            case 3:
                return 'Sex must be male or female';
            case 55:
                return 'Invalid date of birth';
            case 56:
                return 'Dog cannot be born in the future';
            default:
                return 'There was an error adding the dog'
        }
    }



}

module.exports.DogServices = new DogServices(databaseConnection);

