let mongoose = require('mongoose')

let Schema = mongoose.Schema;



let Points = new Schema({

    user_id: {

        type: String,

        require: true

    },

    points: {

        type: Number,

        require: true

    }

})



module.exports = mongoose.model('Points', Points)