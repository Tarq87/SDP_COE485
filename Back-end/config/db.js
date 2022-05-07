const mongoose = require('mongoose')
const dbConfig = require('./dbconfig')

const connectDB = async() => {
    try {
        const conn = await mongoose.connect(dbConfig.database, {
            useNewUrlParser: true,
            useUnifiedTopology: true
            // TWO OPTIONS ONLY WORKED FOR ME
            // IN UR CASE IT MAY BE TWO
        })
        console.log(`MongoDB Connected: ${conn.connection.host}`)
    }
    catch (err) {
        console.log(err)
        process.exit(1)
    }
}

module.exports = connectDB