let mongoose = require('mongoose')
let Schema = mongoose.Schema;

let Credit_Card = new Schema({
    user_id: {
        type: String,
        require: true
    },
    holder_name: {
        type: String,
        require: true
    },
    card_number: {
        type: Number,
        require: true
    },
    expiration: {
        type: String,
        require: true
    },
    cvv: {
        type: Number,
        require: true
    }
})

module.exports = mongoose.model('Credit_Card', Credit_Card)