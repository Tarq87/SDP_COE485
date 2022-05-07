let mongoose = require('mongoose')
let Schema = mongoose.Schema;


let Out_Passengers = new Schema({
    user_id: {
        type: String,
        require: true
    },

    longitude: {
        type: Number,
        require: true
    },
    latitude: {
        type: Number,
        require: true
    }


})

module.exports = mongoose.model('out_passengers', Out_Passengers)