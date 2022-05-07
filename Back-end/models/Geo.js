let mongoose = require('mongoose')
let Schema = mongoose.Schema;

let GoeSchema = new Schema ({
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