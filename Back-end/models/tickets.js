var mongoose = require('mongoose')
var Schema = mongoose.Schema;
var ticket_Schema = new Schema({
    ticket_id: {
        type: String,
        require: true
    },

    Bus_id: {
        type: String,
        require: true
    },

    longitude: {
        type: String,
        require: true
    },

    latitude: {
        type: String,
        require: true
    },

    createdAt: { type: Date, default: Date.now }

})



module.exports = mongoose.model('Ticket', ticket_Schema)