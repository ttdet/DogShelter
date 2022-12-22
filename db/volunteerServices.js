const tedious = require('tedious');
const Request = tedious.Request;
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;

class VolunteerServices {

    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
    }


    addVolunteer(volunteerData) {

        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (volunteerData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: volunteerData[paramName]
                });
            }
        }

        addParam('FirstName', TYPES.VarChar);
        addParam('LastName', TYPES.VarChar);
        addParam('Sex', TYPES.VarChar);
        addParam('DOB', TYPES.VarChar);
        addParam('CanGiveMed', TYPES.Bit);
        addParam('MemberSince', TYPES.VarChar);
        addParam('ServicesEndOn', TYPES.VarChar);

        return this.databaseConnection.callProcedure('AddVolunteer', paramData);
    
    }

    applyVolunteerFilter(filters) {
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

        addParam('FirstName', TYPES.VarChar);
        addParam('LastName', TYPES.VarChar);
        addParam('CanGiveMed', TYPES.Bit);

        return this.databaseConnection.callProcedure("ApplyVolunteerFilter", paramData);


    }

    updateVolunteer(volunteerData) {
        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (volunteerData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: volunteerData[paramName]
                });
            }
        }

        addParam('ID', TYPES.Int);
        addParam('FirstName', TYPES.VarChar);
        addParam('LastName', TYPES.VarChar);
        addParam('Sex', TYPES.VarChar);
        addParam('DOB', TYPES.VarChar);
        addParam('CanGiveMed', TYPES.Bit);
        addParam('MemberSince', TYPES.VarChar);
        addParam('ServicesEndOn', TYPES.VarChar);

        return this.databaseConnection.callProcedure('UpdateVolunteer', paramData);
    }
    
    deleteVolunteer(volunteerData) {
        const paramData = [
            {name : 'VolunteerID', type : TYPES.Int, value : volunteerData['VolunteerID']}
        ];
        
        return this.databaseConnection.callProcedure('DeleteVolunteer', paramData);

    }
    
    searchVolunteerByName(nameSearch) {
    
        const paramData = [
            {
                name: 'name_search',
                type: TYPES.VarChar,
                value: nameSearch
            }
        ];

        return this.databaseConnection.callProcedure('SearchVolunteerByName', paramData);

    }

    searchVolunteerByID(id_value) {
        const paramData = id_value ? [{name : 'ID', type : TYPES.Int, value : id_value}] : [];
        return this.databaseConnection.callProcedure('SearchVolunteerByID', paramData);
    }

    getAllVolunteersThatCanGiveMeds() {
        return this.databaseConnection.callProcedure('FetchAllVolunteers_CanGiveMeds');
    }

    insertECodeToMessage(statusCode) {
        switch(statusCode) {
            case 1:
                return 'Name cannot be null';
            case 2:
                return 'Medic permission cannot be null';
            case 55:
                return 'Invalid date of birth';
            case 56:
                return 'Invalid member since date';
            case 57:
                return 'Invalid services end on date';
            case 58:
                return 'Cannot be born in the future';
            case 59:
                return 'Cannot be a member since a future date';
            default:
                return 'There was an error adding the volunteer';
        }
    }

    updateECodeToMessage(statusCode) {
        switch(statusCode) {
            case 1:
                return 'Name cannot be null';
            case 2:
                return 'Medic permission cannot be null';
            case 55:
                return 'Invalid date of birth';
            case 56:
                return 'Invalid member since date';
            case 57:
                return 'Invalid services end on date';
            case 58:
                return 'Cannot be born in the future';
            case 59:
                return 'Cannot be a member since a future date';
            default:
                return 'There was an error updating the volunteer';
        }
    }


}

module.exports.VolunteerServices = new VolunteerServices(databaseConnection);

