let mongoose = require('mongoose')
let Schema = mongoose.Schema;
let Activated_Ticket_schema = new Schema({

    user_id: {
        type: String,
        require: true
    },

    type: {
        type: Number,
        require: true

    },

    createdAt: { type: Date, expires: '60m', default: Date.now }
})



module.exports = mongoose.model('Activated_Ticket', Activated_Ticket_schema)