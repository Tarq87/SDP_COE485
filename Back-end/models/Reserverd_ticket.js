let mongoose = require('mongoose')
let Schema = mongoose.Schema;
let ticket_Schema = new Schema({

    user_id: {
        type: String,
        require: true
    },

    type: {
        type: Number,
        require: true
    },

    createdAt: { type: Date, default: Date.now }


})

module.exports = mongoose.model('R_Ticket', ticket_Schema)