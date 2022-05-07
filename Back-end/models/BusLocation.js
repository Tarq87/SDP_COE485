var mongoose = require('mongoose')
var Schema = mongoose.Schema;


var Bus_Location = new Schema ({
    bus_id: {
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

Bus_Location.index({location : "2dsphere"})
module.exports = mongoose.model('Bus_Location', Bus_Location)