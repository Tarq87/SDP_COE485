var mongoose = require('mongoose')
var Schema = mongoose.Schema;

var GoeSchema = new Schema ({
    type: { 
        type: String, 
        default: "Point"
    }, 

    coordinates: {
        type: [Number], 
        index: "2dsphere"
    }
})

module.exports = mongoose.model('Goejson', GoeSchema)