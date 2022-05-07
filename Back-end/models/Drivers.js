var mongoose = require('mongoose')
var Schema = mongoose.Schema;


var Drivers = new Schema({
    
    driver_name: {
        type: String,
        require: true
    },

    bus_id: {
        type: String,
        require: true
    },

    driver_id: {
        type: String,
        require: true

    }
})

module.exports = mongoose.model('Driver', Drivers)