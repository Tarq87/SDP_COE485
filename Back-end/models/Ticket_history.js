let mongoose = require('mongoose')
let Schema = mongoose.Schema;
let Ticket_history_schema = new Schema({

    ticket_id: {
        type: String,
        require: true
    },

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



module.exports = mongoose.model('Ticket History', Ticket_history_schema)