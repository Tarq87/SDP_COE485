let mongoose = require('mongoose')
let Schema = mongoose.Schema;


let Bus_stop = new Schema({
    name: {
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
    },


})



var Stop_Location = new Schema({
    name: {
        type: String,
        required: true
    }, 

    location: {
        type: {
          type: String, // Don't do `{ location: { type: String } }`
          enum: ['Point'], // 'location.type' must be 'Point'
          default : 'Point'
        },
        coordinates: {
          type: [Number],
          required: true
        }
    
      }

})


Stop_Location.index({location : "2dsphere"})
module.exports = mongoose.model('Location_Bus_Station', Stop_Location)