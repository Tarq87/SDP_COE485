var mongoose = require('mongoose')
var Schema = mongoose.Schema;
var ticket_Schema = new Schema({
   
    ticket_id: {
        type: String,
        //require: true
    },

    user_id: {
        type: String,
    },

    bus_id: {
        type: String,
        //require: true
    },

    longitude: {
        type: String,
        require: true
    },

    latitude: {
        type: String,
        require: true
    },

    status: {
        type: String
    },

    bus_station: {
        type: String
    },

    createdAt: { type: Date, default: Date.now }

})



module.exports = mongoose.model('in/out data', ticket_Schema)