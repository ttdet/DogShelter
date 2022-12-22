const tedious = require('tedious');
const Request = tedious.Request;
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;

class ShiftServices {

    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
        
    }

    addShift(shiftData) {

        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (shiftData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: shiftData[paramName]
                });
            }
        }

        addParam('StartTime', TYPES.VarChar);
        addParam('Date', TYPES.VarChar);
        addParam('Span', TYPES.TinyInt);
        addParam('TODO', TYPES.VarChar);
        addParam('Note', TYPES.VarChar);
        return this.databaseConnection.callProcedure('AddShift', paramData);
    
    }

    addOnDuty(OnDutyData) {

        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (OnDutyData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: OnDutyData[paramName]
                });
            }
        }

        addParam('vfn', TYPES.VarChar);
        addParam('vln', TYPES.VarChar);
        addParam('vID', TYPES.TinyInt);
        addParam('sID', TYPES.VarChar);
        addParam('isLeader', TYPES.Bit);
        return this.databaseConnection.callProcedure('AddOnDuty', paramData);

    }

    assignShiftLeader(OnDutyID) {
        const paramData = [
            {name : 'OnDutyID', type : TYPES.Int, value : OnDutyID}
        ];

        return this.databaseConnection.callProcedure('AssignShiftLeader', paramData);
    }

    deleteOnDuty(OnDutyID) {
        const paramData = [
            {name : 'OnDutyID', type : TYPES.Int, value : OnDutyID}
        ];

        return this.databaseConnection.callProcedure('DeleteOnDuty', paramData);
    }

    updateShift(shiftData) {
        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (shiftData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: shiftData[paramName]
                });
            }
        }

        addParam('ID', TYPES.Int);
        addParam('StartTime', TYPES.VarChar);
        addParam('Date', TYPES.VarChar);
        addParam('Span', TYPES.TinyInt);
        addParam('TODO', TYPES.VarChar);
        addParam('Note', TYPES.VarChar);

        return this.databaseConnection.callProcedure('UpdateShift', paramData);
    }

    deleteShift(shiftData) {
        const paramData = [
            {name : 'ShiftID', type : TYPES.Int, value : shiftData['ShiftID']}
        ];
        
        return this.databaseConnection.callProcedure('DeleteShift', paramData);

    }

    searchShiftByID(id_value) {
        const paramData = id_value ? [{name : 'ID', type : TYPES.Int, value : id_value}] : [];
        return this.databaseConnection.callProcedure('SearchShiftByID', paramData);
    }

    getVolunteersOnDuty(ShiftID) {
        const paramData = ShiftID ? [{name : 'ID', type : TYPES.Int, value : ShiftID}] : [];
        return this.databaseConnection.callProcedure('GetVolunteersOnDuty', paramData);
    }

    insertionECodeToMsg(statusCode) {
        switch(statusCode) {
            case 3:
                return 'Shift already exists';
            case 85:
                return "Invalid date";
            case 86:
                return "Invalid time";
            default:
                return 'There was an error adding the shift';
        }
    }

    updateECodeToMsg(statusCode) {
        switch(statusCode) {
            case 85:
                return "Invalid date";
            case 86:
                return "Invalid time";
            default:
                return 'There was an error updating the shift';
        }
    }

    addOnDutyECodeToErrMsg(statusCode) {
        switch(statusCode) {
            case 13:
                return "Volunteer info needed";
            case 14:
                return "Only one of volunteer ID and volunteer name is needed";
            case 22:
                return "No volunteer with the given first name";
            case 21:
                return "More than one volunteer with the given first name";
            case 22:
                return "No volunteer with the given last name";
            case 23:
                return "More than one volunteer with the given last name";
            case 24:
                return "No volunteer with the given full name";
            case 25:
                return "More than one volunteer with the given full name" ;
            case 26:
                return "No volunteer with the given ID";
            case 95:
                return "This volunteer is already in the shift";
            case 99:
                return "Since there's no leader, the volunteer you added has been forcibly assigned as the shift leader"
            default:
                return 'There was an error adding the volunteer to the shift';
        }
    }
    
    



}

module.exports.ShiftServices = new ShiftServices(databaseConnection);

