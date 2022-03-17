var mongoose = require('mongoose')
var Schema = mongoose.Schema;
var bcrypt = require('bcrypt')
var userSchema = new Schema({
    name: {
        type: String,
        require: true,
        unique: true

    },
    email: {
        type: String,
       // require: true,
        unique: true

    },
    password: {
        type: String,
        require: true
    }
})
// Encrypt the password before saving it
// https://mongoosejs.com/docs/middleware.html#pre
userSchema.pre('save', function (next) {
    var user = this;
    // isModified = Returns true if any of the given paths is modified, else false
    if (this.isModified('password') || this.isNew) {
        // https://heynode.com/blog/2020-04/salt-and-hash-passwords-bcrypt/
        const saltRounds = 10
        bcrypt.genSalt(saltRounds, function (err, salt) {
            if (err) {
                return next(err)
            }
            bcrypt.hash(user.password, salt, function (err, hash) {
                if (err) {
                    return next(err)
                }
                user.password = hash;
                next()
            })
        })
    }
    else {
        return next()
    }
})

userSchema.methods.comparePassword = function (passw, cb) {
    // passw = plaintext password.
    // this.password = hashed paaword.
    bcrypt.compare(passw, this.password, function (err, isMatch) {
        if(err) {
            return cb(err)
        }
        cb(null, isMatch)
    })
}

module.exports = mongoose.model('User', userSchema)