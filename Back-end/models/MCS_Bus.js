let mongoose = require('mongoose')
let Schema = mongoose.Schema;

let MCS_Bus = new Schema({
    bus_id: {
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

module.exports = mongoose.model('MCS_Bus', MCS_Bus)