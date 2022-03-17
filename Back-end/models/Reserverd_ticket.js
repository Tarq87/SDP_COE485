var mongoose = require('mongoose')
var Schema = mongoose.Schema;
var ticket_Schema = new Schema({

    user_id: {
        type: String,
        require: true
    },

})

module.exports = mongoose.model('R_Ticket', ticket_Schema)