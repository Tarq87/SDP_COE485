let mongoose = require('mongoose')
let Schema = mongoose.Schema;

let Balance = new Schema({
    user_id: {
        type: String,
        require: true
    },
    balance: {
        type: Number,
        require: true
    },
})

module.exports = mongoose.model('Balance', Balance)