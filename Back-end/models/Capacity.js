let mongoose = require('mongoose')
let Schema = mongoose.Schema;

let Bus_Location = new Schema({
    bus_id: {
        type: String,
        require: true
    },
    

    capacity: {
        type: Number,
        require: true
    }
})

module.exports = mongoose.model('Capacity', Bus_Location)