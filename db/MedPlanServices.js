const tedious = require('tedious');
const Request = tedious.Request;
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;

class MedPlanServices {

    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
    }

    addMedPlan(medPlanData) {

        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (medPlanData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: medPlanData[paramName]
                });
            }
        }

        addParam('dID', TYPES.Int);
        addParam('mID', TYPES.Int);
        addParam('startDate', TYPES.Date);
        addParam('endDate', TYPES.Date);
        addParam('DR', TYPES.VarChar);
        addParam('SI', TYPES.VarChar);

        return this.databaseConnection.callProcedure('AddMedPlan', paramData);
    
    }

    getMedPlanByID(medPlanID) {

        const paramData = [
            {
                name : 'id',
                type : TYPES.Int,
                value : medPlanID
            }
        ];
        
        return this.databaseConnection.callProcedure('SearchMedPlanByID', paramData);

    }

    updateMedPlan(updateMedPlan) {

        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (updateMedPlan[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: updateMedPlan[paramName]
                });
            }
        }

        addParam('MedPlanID', TYPES.Int);
        addParam('dID', TYPES.Int);
        addParam('mID', TYPES.Int);
        addParam('startDate', TYPES.Date);
        addParam('endDate', TYPES.Date);
        addParam('DR', TYPES.VarChar);
        addParam('SI', TYPES.VarChar);

        return this.databaseConnection.callProcedure('UpdateMedPlan', paramData);
    
    }

    deleteMedPlan(medPlanID) {

        const paramData = [
            {
                name : 'MedPlanID',
                type : TYPES.Int,
                value : medPlanID
            }
        ];
        
        return this.databaseConnection.callProcedure('DeleteMedPlan', paramData);

    }
    
    searchMedPlanByDogID(dog_id) {

        const paramData = [
            {
                name : 'DogID',
                type : TYPES.Int,
                value : dog_id
            }
        ];
        
        return this.databaseConnection.callProcedure('GetMedPlansForDogID', paramData);

    }

    insertECodeToMessage(statusCode) {

        switch(statusCode) {
            case 40:
                return 'This medication plan does not exist.';
            case 3:
                return 'The end date cannot be before the start date.';
            case 1:
                return 'The dog ID was not provided.';
            case 2:
                return 'The medication ID was not provided.';
            case 7:
                return 'This dog does not exist.';
            case 10:
                return 'This medication does not exist.';
            default:
                return 'There was an error updating the medication plan.';
            
        }

    }

    updateECodeToMessage(statusCode) {

        switch(statusCode) {
            case 1:
                return 'Dog ID is required';
            case 2:
                return 'Medication ID is required';
            case 3:
                return 'End date cannot be before start date.';
            case 7:
                return 'This dog does not exist';
            case 10:
                return 'This medication does not exist.';
            case 50:
                return 'This medication plan already exists.';
            default:
                return 'There was an error adding the medication plan.';
        }

    }

    deleteECodeToMessage(statusCode) {

        switch(statusCode) {
            case 1:
                return 'The MedPlanID provided was null.';
            case 2:
                return 'This medication plan does not exist';
            default:
                return 'There was an error deleting the medication plan.';
        }

    }

}

module.exports.MedPlanServices = new MedPlanServices(databaseConnection);

