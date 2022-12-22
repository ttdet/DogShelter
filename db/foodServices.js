const tedious = require('tedious');
const Request = tedious.Request;
const TYPES = tedious.TYPES;
const databaseConnection = require('./databaseconnection').databaseConnection;

class FoodServices {

    constructor(databaseConnection) {
        this.databaseConnection = databaseConnection
    }

    addFood(foodData) {

        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (foodData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: foodData[paramName]
                });
            }
        }

        addParam('Name', TYPES.VarChar);
        addParam('Instructions', TYPES.VarChar);
        addParam('BoughtFrom', TYPES.VarChar);
        addParam('Stock', TYPES.Real);
        addParam('UnitPerStock', TYPES.VarChar);

        return this.databaseConnection.callProcedure('AddFood', paramData);
    
    }

    updateFood(foodData) {
        const paramData = [];

        const addParam = (paramName, paramType) => {
            if (foodData[paramName] !== undefined) {
                paramData.push({
                    name: paramName,
                    type: paramType,
                    value: foodData[paramName]
                });
            }
        }

        addParam('ID', TYPES.Int);
        addParam('Name', TYPES.VarChar);
        addParam('Instructions', TYPES.VarChar);
        addParam('BoughtFrom', TYPES.VarChar);
        addParam('Stock', TYPES.Real);
        addParam('UnitPerStock', TYPES.VarChar);

        return this.databaseConnection.callProcedure('UpdateFood', paramData);
    }

    deleteFood(foodData) {
        const paramData = [
            {name : 'FoodID', type : TYPES.Int, value : foodData['FoodID']}
        ];
        
        return this.databaseConnection.callProcedure('DeleteFood', paramData);

    }
    
    searchFoodByName(nameSearch) {
    
        const paramData = id_value ? [{name : 'Name', type : TYPES.Int, value : nameSearch}] : [];
        return this.databaseConnection.callProcedure('SearchFoodByName', paramData);
    }

    searchFoodByID(id_value) {
    
        const paramData = id_value ? [{name : 'ID', type : TYPES.Int, value : id_value}] : [];
        return this.databaseConnection.callProcedure('SearchFoodByID', paramData);
    }

}

module.exports.FoodServices = new FoodServices(databaseConnection);

