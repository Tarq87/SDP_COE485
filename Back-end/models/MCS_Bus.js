var mongoose = require('mongoose')
var Schema = mongoose.Schema;

var MCS_Bus = new Schema({
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